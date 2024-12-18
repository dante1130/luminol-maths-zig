const std = @import("std");

const Vector = @import("vector.zig").Vector;
const Matrix = @import("matrix.zig").Matrix;
const unit = @import("units/unit.zig");

pub fn PerspectiveMatrixParams(comptime T: type) type {
    return struct {
        fov: unit.Angle(T, .degrees),
        aspect: T,
        near: T,
        far: T,
    };
}

pub fn left_handed_perspective_matrix(
    comptime T: type,
    params: PerspectiveMatrixParams(T),
) Matrix(4, 4, T) {
    const tan_half_fov = @tan(params.fov.as(.radians).angle / 2.0);
    const range = params.far - params.near;

    // [A] [0] [0] [0]
    // [0] [B] [0] [0]
    // [0] [0] [C] [D]
    // [0] [0] [E] [0]
    var perspective_matrix = Matrix(4, 4, T).zero();

    // A
    perspective_matrix.at(0, 0).* = 1 / (tan_half_fov * params.aspect);
    // B
    perspective_matrix.at(1, 1).* = 1 / tan_half_fov;
    // C
    perspective_matrix.at(2, 2).* = params.far / range;
    // D
    perspective_matrix.at(2, 3).* = 1;
    // E
    perspective_matrix.at(3, 2).* = -(params.far * params.near) / range;

    return perspective_matrix;
}

pub fn LookAtMatrixParams(comptime T: type) type {
    return struct {
        eye: Vector(3, T),
        target: Vector(3, T),
        up: Vector(3, T),
    };
}

pub fn left_handed_look_at_matrix(
    comptime T: type,
    params: LookAtMatrixParams(T),
) Matrix(4, 4, T) {
    const forward = params.target.sub(&params.eye).normalized();
    const right = params.up.cross(&forward).normalized();
    const up = forward.cross(&right);

    var look_at_matrix = Matrix(4, 4, T).identity();

    look_at_matrix.at(0, 0).* = right.x();
    look_at_matrix.at(1, 0).* = right.y();
    look_at_matrix.at(2, 0).* = right.z();

    look_at_matrix.at(0, 1).* = up.x();
    look_at_matrix.at(1, 1).* = up.y();
    look_at_matrix.at(2, 1).* = up.z();

    look_at_matrix.at(0, 2).* = forward.x();
    look_at_matrix.at(1, 2).* = forward.y();
    look_at_matrix.at(2, 2).* = forward.z();

    look_at_matrix.at(3, 0).* = -(right.dot(&params.eye));
    look_at_matrix.at(3, 1).* = -(up.dot(&params.eye));
    look_at_matrix.at(3, 2).* = -(forward.dot(&params.eye));

    return look_at_matrix;
}

pub fn translate(
    comptime M: usize,
    comptime vector_size: usize,
    comptime T: type,
    translation_vector: *const Vector(vector_size, T),
) Matrix(M, M, T) {
    comptime {
        const is_valid = (M == 2 and vector_size == 2) or (M == 3 and vector_size == 3) or (M == 4 and vector_size == 3);

        if (!is_valid) {
            @compileError("Invalid matrix size or vector size");
        }
    }

    var translation_matrix = Matrix(M, M, T).identity();

    for (0..vector_size) |i| {
        translation_matrix.at(M - 1, i).* = translation_vector.vec[i];
    }

    return translation_matrix;
}

pub fn translate_2x2(comptime T: type, translation_vector: *const Vector(2, T)) Matrix(2, 2, T) {
    return translate(2, 2, T, translation_vector);
}

pub fn translate_3x3(comptime T: type, translation_vector: *const Vector(3, T)) Matrix(3, 3, T) {
    return translate(3, 3, T, translation_vector);
}

pub fn translate_4x4(comptime T: type, translation_vector: *const Vector(3, T)) Matrix(4, 4, T) {
    return translate(4, 3, T, translation_vector);
}

pub fn rotate_2x2(
    comptime T: type,
    angle: unit.Angle(T, .radians),
) Matrix(2, 2, T) {
    const cos_angle = @cos(angle.angle);
    const sin_angle = @sin(angle.angle);

    var rotation_matrix = Matrix(2, 2, T).identity();

    rotation_matrix.at(0, 0).* = cos_angle;
    rotation_matrix.at(0, 1).* = sin_angle;
    rotation_matrix.at(1, 0).* = -sin_angle;
    rotation_matrix.at(1, 1).* = cos_angle;

    return rotation_matrix;
}

pub fn rotate_x(
    comptime M: usize,
    comptime T: type,
    angle: unit.Angle(T, .radians),
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle.angle);
    const sin_angle = @sin(angle.angle);

    var rotation_matrix = Matrix(M, M, T).identity();

    rotation_matrix.at(1, 1).* = cos_angle;
    rotation_matrix.at(1, 2).* = sin_angle;
    rotation_matrix.at(2, 1).* = -sin_angle;
    rotation_matrix.at(2, 2).* = cos_angle;

    return rotation_matrix;
}

pub fn rotate_y(
    comptime M: usize,
    comptime T: type,
    angle: unit.Angle(T, .radians),
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle.angle);
    const sin_angle = @sin(angle.angle);

    var rotation_matrix = Matrix(M, M, T).identity();

    rotation_matrix.at(0, 0).* = cos_angle;
    rotation_matrix.at(0, 2).* = -sin_angle;
    rotation_matrix.at(2, 0).* = sin_angle;
    rotation_matrix.at(2, 2).* = cos_angle;

    return rotation_matrix;
}

pub fn rotate_z(
    comptime M: usize,
    comptime T: type,
    angle: unit.Angle(T, .radians),
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle.angle);
    const sin_angle = @sin(angle.angle);

    var rotation_matrix = Matrix(M, M, T).identity();

    rotation_matrix.at(0, 0).* = cos_angle;
    rotation_matrix.at(0, 1).* = sin_angle;
    rotation_matrix.at(1, 0).* = -sin_angle;
    rotation_matrix.at(1, 1).* = cos_angle;

    return rotation_matrix;
}

pub fn scale(
    comptime M: usize,
    comptime vector_size: usize,
    comptime T: type,
    scale_vector: *const Vector(vector_size, T),
) Matrix(M, M, T) {
    comptime {
        const is_valid = (M == 2 and vector_size == 2) or (M == 3 and vector_size == 3) or (M == 4 and vector_size == 3);

        if (!is_valid) {
            @compileError("Invalid matrix size or vector size");
        }
    }

    var scale_matrix = Matrix(M, M, T).identity();

    for (0..vector_size) |i| {
        scale_matrix.at(i, i).* = scale_vector.vec[i];
    }

    return scale_matrix;
}

pub fn scale_2x2(comptime T: type, scale_vector: *const Vector(2, T)) Matrix(2, 2, T) {
    return scale(2, 2, T, scale_vector);
}

pub fn scale_3x3(comptime T: type, scale_vector: *const Vector(3, T)) Matrix(3, 3, T) {
    return scale(3, 3, T, scale_vector);
}

pub fn scale_4x4(comptime T: type, scale_vector: *const Vector(3, T)) Matrix(4, 4, T) {
    return scale(4, 3, T, scale_vector);
}

test "left_handed_perspective_matrix" {
    const perspective_matrix = left_handed_perspective_matrix(
        f32,
        .{
            .fov = unit.Degrees_f.init(90.0),
            .aspect = 16.0 / 9.0,
            .near = 0.1,
            .far = 100.0,
        },
    );

    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        0.5625, 0, 0,          0,
        0,      1, 0,          0,
        0,      0, 1.001001,   1,
        0,      0, -0.1001001, 0,
    }), perspective_matrix);
}

test "left_handed_look_at_matrix" {
    const look_at_matrix = left_handed_look_at_matrix(
        f32,
        .{
            .eye = Vector(3, f32).init(@Vector(3, f32){ 0, 0, -5 }),
            .target = Vector(3, f32).init(@Vector(3, f32){ 0, 0, 0 }),
            .up = Vector(3, f32).init(@Vector(3, f32){ 0, 1, 0 }),
        },
    );

    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 5, 1,
    }), look_at_matrix);
}

test "translate" {
    const translation_vector = Vector(3, f32).init(@Vector(3, f32){ 1, 2, 3 });
    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        1, 2, 3, 1,
    }), translate_4x4(f32, &translation_vector));
}

test "rotate_x" {
    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        1, 0,         0,         0,
        0, 0.8660254, 0.5,       0,
        0, -0.5,      0.8660254, 0,
        0, 0,         0,         1,
    }), rotate_x(4, f32, unit.Radians_f.init(std.math.pi / 6.0)));
}

test "rotate_y" {
    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        0.8660254, 0, -0.5,      0,
        0,         1, 0,         0,
        0.5,       0, 0.8660254, 0,
        0,         0, 0,         1,
    }), rotate_y(4, f32, unit.Radians_f.init(std.math.pi / 6.0)));
}

test "rotate_z" {
    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        0.8660254, 0.5,       0, 0,
        -0.5,      0.8660254, 0, 0,
        0,         0,         1, 0,
        0,         0,         0, 1,
    }), rotate_z(4, f32, unit.Radians_f.init(std.math.pi / 6.0)));
}

test "scale" {
    const scale_vector = Vector(3, f32).init(@Vector(3, f32){ 2, 3, 4 });
    try std.testing.expectEqual(Matrix(4, 4, f32).init(@Vector(16, f32){
        2, 0, 0, 0,
        0, 3, 0, 0,
        0, 0, 4, 0,
        0, 0, 0, 1,
    }), scale_4x4(f32, &scale_vector));
}

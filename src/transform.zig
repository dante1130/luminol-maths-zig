const Vector = @import("vector.zig").Vector;
const Matrix = @import("matrix.zig").Matrix;

pub fn PerspectiveMatrixParams(comptime T: type) type {
    return struct {
        fov_degrees: T,
        aspect: T,
        near: T,
        far: T,
    };
}

pub fn left_handed_perspective_matrix(
    comptime T: type,
    params: PerspectiveMatrixParams(T),
) Matrix(4, 4, T) {
    const tan_half_fov = @tan(params.fov_degrees) / 2;
    const range = params.near - params.far;

    // [A] [0] [0] [0]
    // [0] [B] [0] [0]
    // [0] [0] [C] [D]
    // [0] [0] [E] [0]
    var perspective_matrix = Matrix(4, 4, T).identity();

    // A
    perspective_matrix.at(0, 0).* = 1 / (tan_half_fov * params.aspect);
    // B
    perspective_matrix.at(1, 1).* = 1 / tan_half_fov;
    // C
    perspective_matrix.at(2, 2).* = params.far / range;
    // D
    perspective_matrix.at(2, 3).* = 1;
    // E
    perspective_matrix.at(3, 2).* = -params.far * params.near / range;

    return perspective_matrix;
}

pub fn LookAtMatrixParams(comptime T: type) type {
    return struct {
        eye: Vector(3, T),
        center: Vector(3, T),
        up: Vector(3, T),
    };
}

pub fn left_handed_look_at_matrix(
    comptime T: type,
    params: LookAtMatrixParams(T),
) Matrix(4, 4, T) {
    const forward = params.center.sub(&params.eye).normalized();
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
    angle_radians: T,
) Matrix(2, 2, T) {
    const cos_angle = @cos(angle_radians);
    const sin_angle = @sin(angle_radians);

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
    angle_radians: T,
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle_radians);
    const sin_angle = @sin(angle_radians);

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
    angle_radians: T,
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle_radians);
    const sin_angle = @sin(angle_radians);

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
    angle_radians: T,
) Matrix(M, M, T) {
    comptime {
        if (M != 3 and M != 4) {
            @compileError("Matrix must be 3x3 or 4x4");
        }
    }

    const cos_angle = @cos(angle_radians);
    const sin_angle = @sin(angle_radians);

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

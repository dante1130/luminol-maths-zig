const std = @import("std");

pub const Vector = @import("vector.zig").Vector;

pub const Vec2 = Vector(2, f64);
pub const Vec3 = Vector(3, f64);
pub const Vec4 = Vector(4, f64);

pub const Vec2f = Vector(2, f32);
pub const Vec3f = Vector(3, f32);
pub const Vec4f = Vector(4, f32);

pub const Matrix = @import("matrix.zig").Matrix;

pub const Mat2x2 = Matrix(2, 2, f64);
pub const Mat3x3 = Matrix(3, 3, f64);
pub const Mat4x4 = Matrix(4, 4, f64);

pub const Mat2x2f = Matrix(2, 2, f32);
pub const Mat3x3f = Matrix(3, 3, f32);
pub const Mat4x4f = Matrix(4, 4, f32);

pub const transform = @import("transform.zig");

test "dot" {
    var v1 = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 });
    var v2 = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 });
    try std.testing.expectEqual(0.0, v1.dot(&v2));

    v1 = Vec4f.init(@Vector(4, f32){ 1, 0, 0, 0 });
    v2 = Vec4f.init(@Vector(4, f32){ 0, 1, 0, 0 });
    try std.testing.expectEqual(0.0, v1.dot(&v2));

    v1 = Vec4f.init(@Vector(4, f32){ 0, 1, 0, 0 });
    v2 = Vec4f.init(@Vector(4, f32){ 1, 0, 0, 0 });
    try std.testing.expectEqual(0.0, v1.dot(&v2));

    v1 = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 1 });
    v2 = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 1 });
    try std.testing.expectEqual(1.0, v1.dot(&v2));

    v1 = Vec4f.init(@Vector(4, f32){ 1, 1, 1, 1 });
    v2 = Vec4f.init(@Vector(4, f32){ 1, 1, 1, 1 });
    try std.testing.expectEqual(4.0, v1.dot(&v2));

    v1 = Vec4f.init(@Vector(4, f32){ 1, 2, 3, 4 }).normalized();
    v2 = Vec4f.init(@Vector(4, f32){ 1, 2, 3, 4 }).normalized();
    try std.testing.expectApproxEqRel(1.0, v1.dot(&v2), 0.0001);

    v1 = Vec4f.init(@Vector(4, f32){ 1, 2, 3, 4 }).normalized();
    v2 = Vec4f.init(@Vector(4, f32){ -1, -2, -3, -4 }).normalized();
    try std.testing.expectApproxEqRel(-1.0, v1.dot(&v2), 0.0001);

    v1 = Vec4f.init(@Vector(4, f32){ 1, 2, 3, 4 }).normalized();
    v2 = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 }).normalized();
    try std.testing.expectApproxEqRel(0.0, v1.dot(&v2), 0.0001);
}

test "cross" {
    var v1 = Vec3f.init(@Vector(3, f32){ 0, 0, 0 });
    var v2 = Vec3f.init(@Vector(3, f32){ 0, 0, 0 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, 0 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ 1, 0, 0 });
    v2 = Vec3f.init(@Vector(3, f32){ 0, 1, 0 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, 1 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ 0, 1, 0 });
    v2 = Vec3f.init(@Vector(3, f32){ 1, 0, 0 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, -1 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ 1, 1, 1 });
    v2 = Vec3f.init(@Vector(3, f32){ 2, 2, 2 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, 0 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ 1, 2, 3 });
    v2 = Vec3f.init(@Vector(3, f32){ 0, 0, 0 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, 0 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ -1, -2, -3 });
    v2 = Vec3f.init(@Vector(3, f32){ 1, 2, 3 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ 0, 0, 0 }), v1.cross(&v2));

    v1 = Vec3f.init(@Vector(3, f32){ 1, 2, 3 });
    v2 = Vec3f.init(@Vector(3, f32){ 4, 5, 6 });
    try std.testing.expectEqual(Vec3f.init(@Vector(3, f32){ -3, 6, -3 }), v1.cross(&v2));
}

test "magnitude" {
    var v = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 });
    try std.testing.expectEqual(0.0, v.magnitude());

    v = Vec4f.init(@Vector(4, f32){ 1, 0, 0, 0 });
    try std.testing.expectEqual(1.0, v.magnitude());

    v = Vec4f.init(@Vector(4, f32){ 0, 1, 0, 0 });
    try std.testing.expectEqual(1.0, v.magnitude());

    v = Vec4f.init(@Vector(4, f32){ 0, 0, 1, 0 });
    try std.testing.expectEqual(1.0, v.magnitude());

    v = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 1 });
    try std.testing.expectEqual(1.0, v.magnitude());

    v = Vec4f.init(@Vector(4, f32){ 1, 1, 1, 1 });
    try std.testing.expectEqual(@sqrt(4.0), v.magnitude());
}

test "normalized" {
    var v = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){ 0, 0, 0, 0 }), v.normalized());

    v = Vec4f.init(@Vector(4, f32){ 1, 0, 0, 0 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){ 1, 0, 0, 0 }), v.normalized());

    v = Vec4f.init(@Vector(4, f32){ 0, 1, 0, 0 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){ 0, 1, 0, 0 }), v.normalized());

    v = Vec4f.init(@Vector(4, f32){ 0, 0, 1, 0 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){ 0, 0, 1, 0 }), v.normalized());

    v = Vec4f.init(@Vector(4, f32){ 0, 0, 0, 1 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){ 0, 0, 0, 1 }), v.normalized());

    v = Vec4f.init(@Vector(4, f32){ 1, 1, 1, 1 });
    try std.testing.expectEqual(Vec4f.init(@Vector(4, f32){
        1.0 / @sqrt(4.0),
        1.0 / @sqrt(4.0),
        1.0 / @sqrt(4.0),
        1.0 / @sqrt(4.0),
    }), v.normalized());
}

test "Mat1x1_identity" {
    try std.testing.expectEqual(Matrix(1, 1, f32).init(@Vector(1, f32){1}), Matrix(1, 1, f32).identity());
}

test "Mat4x4_identity" {
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }), Mat4x4f.identity());
}

test "Mat4x4_cofactor" {
    const mat = Mat4x4f.init(@Vector(16, f32){
        3, 0, 2, -1,
        1, 2, 0, -2,
        4, 0, 6, -3,
        5, 0, 2, 0,
    });

    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        12, -50, -30, -44,
        0,  10,  0,   0,
        -4, 10,  10,  8,
        0,  20,  10,  20,
    }), mat.cofactor());
}

test "Mat4x4_determinant" {
    const mat = Mat4x4f.init(@Vector(16, f32){
        3, 0, 2, -1,
        1, 2, 0, -2,
        4, 0, 6, -3,
        5, 0, 2, 0,
    });

    try std.testing.expectEqual(20.0, mat.determinant());
}

test "Mat4x4_adjugate" {
    const mat = Mat4x4f.init(@Vector(16, f32){
        3, 0, 2, -1,
        1, 2, 0, -2,
        4, 0, 6, -3,
        5, 0, 2, 0,
    });

    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        12,  0,  -4, 0,
        -50, 10, 10, 20,
        -30, 0,  10, 10,
        -44, 0,  8,  20,
    }), mat.adjugate());
}

test "Mat4x4_inverse" {
    const mat = Mat4x4f.init(@Vector(16, f32){
        3, 0, 2, -1,
        1, 2, 0, -2,
        4, 0, 6, -3,
        5, 0, 2, 0,
    });

    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        0.6,  0.0, -0.2, 0.0,
        -2.5, 0.5, 0.5,  1.0,
        -1.5, 0.0, 0.5,  0.5,
        -2.2, 0.0, 0.4,  1.0,
    }), mat.inverse());
}

test "translate" {
    const translation_vector = Vec3f.init(@Vector(3, f32){ 1, 2, 3 });
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        1, 2, 3, 1,
    }), transform.translate_4x4(f32, &translation_vector));
}

test "rotate_x" {
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        1, 0,         0,         0,
        0, 0.8660254, 0.5,       0,
        0, -0.5,      0.8660254, 0,
        0, 0,         0,         1,
    }), transform.rotate_x(4, f32, std.math.pi / 6.0));
}

test "rotate_y" {
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        0.8660254, 0, -0.5,      0,
        0,         1, 0,         0,
        0.5,       0, 0.8660254, 0,
        0,         0, 0,         1,
    }), transform.rotate_y(4, f32, std.math.pi / 6.0));
}

test "rotate_z" {
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        0.8660254, 0.5,       0, 0,
        -0.5,      0.8660254, 0, 0,
        0,         0,         1, 0,
        0,         0,         0, 1,
    }), transform.rotate_z(4, f32, std.math.pi / 6.0));
}

test "scale" {
    const scale_vector = Vec3f.init(@Vector(3, f32){ 2, 3, 4 });
    try std.testing.expectEqual(Mat4x4f.init(@Vector(16, f32){
        2, 0, 0, 0,
        0, 3, 0, 0,
        0, 0, 4, 0,
        0, 0, 0, 1,
    }), transform.scale_4x4(f32, &scale_vector));
}

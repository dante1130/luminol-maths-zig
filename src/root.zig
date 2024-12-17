const std = @import("std");

pub const Vector = @import("vector.zig").Vector;

pub const Vec2 = Vector(2, f64);
pub const Vec3 = Vector(3, f64);
pub const Vec4 = Vector(4, f64);

pub const Vec2f = Vector(2, f32);
pub const Vec3f = Vector(3, f32);
pub const Vec4f = Vector(4, f32);

pub const Matrix = @import("matrix.zig").Matrix;

pub const Mat2x2 = Matrix(2, 2, f32);
pub const Mat3x3 = Matrix(3, 3, f32);
pub const Mat4x4 = Matrix(4, 4, f32);

pub const Mat2x2f = Matrix(2, 2, f64);
pub const Mat3x3f = Matrix(3, 3, f64);
pub const Mat4x4f = Matrix(4, 4, f64);

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

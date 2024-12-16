const std = @import("std");

const vec = @import("vector.zig");
pub const Vec2 = vec.Vector(2, f64);
pub const Vec3 = vec.Vector(3, f64);
pub const Vec4 = vec.Vector(4, f64);

pub const Vec2f = vec.Vector(2, f32);
pub const Vec3f = vec.Vector(3, f32);
pub const Vec4f = vec.Vector(4, f32);

test "vector" {
    const v = Vec2.init(@Vector(2, f64){ 1, 2 });
    try std.testing.expectEqual(1.0, v.x());
    try std.testing.expectEqual(2.0, v.y());
}

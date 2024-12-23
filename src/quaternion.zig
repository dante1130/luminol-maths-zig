const std = @import("std");

const Vector = @import("vector.zig").Vector;
const unit = @import("units/unit.zig");

pub fn Quaternion(T: type) type {
    return struct {
        quat: Vector(4, T),

        pub fn init(quat: Vector(4, T)) @This() {
            return @This(){
                .quat = quat,
            };
        }

        pub fn angle_axis(angle: unit.Angle(T, .radians), axis: Vector(3, T)) @This() {
            const half_angle = angle.angle / 2;

            const vec_component = axis.mul_scalar(@sin(half_angle));

            return @This(){
                .quat = Vector(4, T).init(@Vector(4, T){
                    vec_component.x(),
                    vec_component.y(),
                    vec_component.z(),
                    @cos(half_angle),
                }),
            };
        }

        pub fn cross(self: @This(), other: @This()) @This() {
            return @This(){
                .quat = self.quat.cross(&other.quat),
            };
        }

        pub fn dot(self: @This(), other: @This()) T {
            return self.quat.dot(&other.quat);
        }

        pub fn normalize(self: @This()) @This() {
            return @This(){
                .quat = self.quat.normalized(),
            };
        }

        pub fn mul(self: @This(), other: @This()) @This() {
            return @This(){
                .quat = self.quat.mul(&other.quat),
            };
        }
    };
}

test "quaternion_angle_axis" {
    const angle = unit.Degrees_f.init(90).as(.radians);
    const q = Quaternion(f32).angle_axis(
        angle,
        Vector(3, f32).init(@Vector(3, f32){ 0, 0, 1 }),
    );

    try std.testing.expectEqual(q.quat.x(), 0);
    try std.testing.expectEqual(q.quat.y(), 0);
    try std.testing.expectEqual(q.quat.z(), @sin(angle.angle / 2));
    try std.testing.expectEqual(q.quat.w(), @cos(angle.angle / 2));
}

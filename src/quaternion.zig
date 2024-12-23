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

        pub fn conjugate(self: *const @This()) @This() {
            return @This(){
                .quat = Vector(4, T).init(@Vector(4, T){
                    -self.quat.x(),
                    -self.quat.y(),
                    -self.quat.z(),
                    self.quat.w(),
                }),
            };
        }

        pub fn cross(self: *const @This(), other: *const @This()) @This() {
            return @This(){
                .quat = self.quat.cross(&other.quat),
            };
        }

        pub fn normalize(self: *const @This()) @This() {
            return @This(){
                .quat = self.quat.normalized(),
            };
        }

        pub fn rotate_vector(self: *const @This(), vec: Vector(3, T)) Vector(3, T) {
            const quat_vec = Quaternion(T).init(
                Vector(4, T).init(
                    @Vector(4, T){
                        vec.x(),
                        vec.y(),
                        vec.z(),
                        0,
                    },
                ),
            );

            // r = q * v * q^-1
            return self.mul(&quat_vec).mul(&self.conjugate()).quat.slice(0, 3);
        }

        pub fn mul(self: *const @This(), other: *const @This()) @This() {
            const q1 = &self.quat;
            const q2 = &other.quat;

            const w = q1.w() * q2.w() - q1.x() * q2.x() - q1.y() * q2.y() - q1.z() * q2.z();
            const x = q1.w() * q2.x() + q1.x() * q2.w() + q1.y() * q2.z() - q1.z() * q2.y();
            const y = q1.w() * q2.y() + q1.y() * q2.w() + q1.z() * q2.x() - q1.x() * q2.z();
            const z = q1.w() * q2.z() + q1.z() * q2.w() + q1.x() * q2.y() - q1.y() * q2.x();

            return @This(){
                .quat = Vector(4, T).init(@Vector(4, T){
                    x,
                    y,
                    z,
                    w,
                }),
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

    try std.testing.expectEqual(Quaternion(f32).init(
        Vector(4, f32).init(
            @Vector(4, f32){
                0,
                0,
                @sin(angle.angle / 2),
                @cos(angle.angle / 2),
            },
        ),
    ), q);
}

test "quaternion_rotation_vector" {
    {
        const angle = unit.Degrees_f.init(90).as(.radians);
        const q = Quaternion(f32).angle_axis(
            angle,
            Vector(3, f32).init(@Vector(3, f32){ 1, 0, 0 }),
        );

        const vec = Vector(3, f32).init(@Vector(3, f32){ 0, 1, 0 });

        const rotated_vec = q.rotate_vector(vec);

        try std.testing.expectEqual(0, rotated_vec.x());
        try std.testing.expectEqual(0, rotated_vec.y());
        try std.testing.expectApproxEqRel(1, rotated_vec.z(), 0.0001);
    }

    {
        const angle = unit.Degrees_f.init(180).as(.radians);
        const q = Quaternion(f32).angle_axis(
            angle,
            Vector(3, f32).init(@Vector(3, f32){ 0, 1, 0 }),
        );

        const vec = Vector(3, f32).init(@Vector(3, f32){ 1, 2, 3 });

        const rotated_vec = q.rotate_vector(vec);

        try std.testing.expectApproxEqRel(-1, rotated_vec.x(), 0.0001);
        try std.testing.expectApproxEqRel(2, rotated_vec.y(), 0.0001);
        try std.testing.expectApproxEqRel(-3, rotated_vec.z(), 0.0001);
    }

    {
        const angle = unit.Degrees_f.init(120).as(.radians);
        const q = Quaternion(f32).angle_axis(
            angle,
            Vector(3, f32).init(@Vector(3, f32){ 1, 0, 0 }),
        );

        const vec = Vector(3, f32).init(@Vector(3, f32){ 0, 1, 0 });

        const rotated_vec = q.rotate_vector(vec);

        try std.testing.expectApproxEqRel(0, rotated_vec.x(), 0.0001);
        try std.testing.expectApproxEqRel(-0.5, rotated_vec.y(), 0.0001);
        try std.testing.expectApproxEqRel(@sin(angle.angle / 2), rotated_vec.z(), 0.0001);
    }
}

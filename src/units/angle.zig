const std = @import("std");

pub const AngleUnit = enum {
    radians,
    degrees,

    fn to_radians_factor(self: AngleUnit, comptime T: type) T {
        return switch (self) {
            .radians => 1,
            .degrees => std.math.rad_per_deg,
        };
    }
};

pub fn Angle(comptime T: type, comptime unit: AngleUnit) type {
    return struct {
        angle: T,

        pub fn init(angle: T) @This() {
            return Angle(T, unit){ .angle = angle };
        }

        pub fn as(self: *const @This(), comptime target_unit: AngleUnit) Angle(T, target_unit) {
            const radians = self.angle * unit.to_radians_factor(T);
            return Angle(T, target_unit).init(radians / target_unit.to_radians_factor(T));
        }
    };
}

test "angle" {
    const radians = Angle(f32, .radians).init(std.math.pi);
    try std.testing.expectEqual(180, radians.as(.degrees).angle);
}

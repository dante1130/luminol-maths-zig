const std = @import("std");

pub const TimeUnit = enum {
    nanosecond,
    millisecond,
    second,
    minute,

    fn to_seconds_factor(self: TimeUnit, comptime T: type) T {
        return switch (self) {
            .second => 1,
            .minute => std.time.s_per_min,
            .millisecond => 1 / @as(T, std.time.ms_per_s),
            .nanosecond => 1 / @as(T, std.time.ns_per_s),
        };
    }
};

pub fn Time(comptime T: type, comptime unit: TimeUnit) type {
    return struct {
        time: T,

        pub fn init(time: T) @This() {
            return Time(T, unit){ .time = time };
        }

        pub fn as(self: *const @This(), comptime target_unit: TimeUnit) Time(T, target_unit) {
            const seconds = self.time * unit.to_seconds_factor(T);
            return Time(T, target_unit).init(seconds / target_unit.to_seconds_factor(T));
        }
    };
}

test "time" {
    const seconds = Time(f32, .second).init(60);
    try std.testing.expectEqual(1, seconds.as(.minute).time);
    try std.testing.expectApproxEqRel(6e+4, seconds.as(.millisecond).time, 0.001);
    try std.testing.expectApproxEqRel(6e+10, seconds.as(.nanosecond).time, 0.001);
}

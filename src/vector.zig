const std = @import("std");

pub fn Vector(comptime N: usize, comptime T: type) type {
    return struct {
        vec: @Vector(N, T),
        const Self = @This();

        pub fn init(vec: @Vector(N, T)) Self {
            comptime {
                if (N < 2) {
                    @compileError("Vector must have at least 2 elements");
                }
            }

            return Vector(N, T){
                .vec = vec,
            };
        }

        pub fn x(self: *const Self) T {
            return self.vec[0];
        }

        pub fn y(self: *const Self) T {
            return self.vec[1];
        }

        pub fn z(self: *const Self) T {
            comptime {
                if (N < 3) {
                    @compileError("Vector must have at least 3 elements");
                }
            }

            return self.vec[2];
        }

        pub fn w(self: *const Self) T {
            comptime {
                if (N < 4) {
                    @compileError("Vector must have at least 4 elements");
                }
            }

            return self.vec[3];
        }

        pub fn add(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec + other.vec);
        }

        pub fn sub(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec - other.vec);
        }

        pub fn mul(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec * other.vec);
        }

        pub fn div(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec / other.vec);
        }

        pub fn dot(self: *const Self, other: *const Self) T {
            return @reduce(.Add, self.vec * other.vec);
        }
    };
}

test "vector" {
    const v = Vector(4, f32).init([4]f32{ 1, 2, 3, 4 });
    try std.testing.expectEqual(1.0, v.x());
    try std.testing.expectEqual(2.0, v.y());
    try std.testing.expectEqual(3.0, v.z());
    try std.testing.expectEqual(4.0, v.w());
}

test "add" {
    const v1 = Vector(4, f32).init(@Vector(4, f32){ 1, 2, 3, 4 });
    const v2 = Vector(4, f32).init(@Vector(4, f32){ 5, 6, 7, 8 });
    const v3 = v1.add(&v2);
    try std.testing.expectEqual(6.0, v3.x());
    try std.testing.expectEqual(8.0, v3.y());
    try std.testing.expectEqual(10.0, v3.z());
    try std.testing.expectEqual(12.0, v3.w());
}

test "sub" {
    const v1 = Vector(4, f32).init(@Vector(4, f32){ 1, 2, 3, 4 });
    const v2 = Vector(4, f32).init(@Vector(4, f32){ 5, 6, 7, 8 });
    const v3 = v1.sub(&v2);
    try std.testing.expectEqual(-4.0, v3.x());
    try std.testing.expectEqual(-4.0, v3.y());
    try std.testing.expectEqual(-4.0, v3.z());
    try std.testing.expectEqual(-4.0, v3.w());
}

test "mul" {
    const v1 = Vector(4, f32).init(@Vector(4, f32){ 1, 2, 3, 4 });
    const v2 = Vector(4, f32).init(@Vector(4, f32){ 5, 6, 7, 8 });
    const v3 = v1.mul(&v2);
    try std.testing.expectEqual(5.0, v3.x());
    try std.testing.expectEqual(12.0, v3.y());
    try std.testing.expectEqual(21.0, v3.z());
    try std.testing.expectEqual(32.0, v3.w());
}

test "div" {
    const v1 = Vector(4, f32).init(@Vector(4, f32){ 1, 2, 3, 4 });
    const v2 = Vector(4, f32).init(@Vector(4, f32){ 5, 6, 7, 8 });
    const v3 = v1.div(&v2);
    try std.testing.expectEqual(0.2, v3.x());
    try std.testing.expectEqual(0.33333334, v3.y());
    try std.testing.expectEqual(0.42857143, v3.z());
    try std.testing.expectEqual(0.5, v3.w());
}

test "dot" {
    const v1 = Vector(4, f32).init(@Vector(4, f32){ 1, 2, 3, 4 });
    const v2 = Vector(4, f32).init(@Vector(4, f32){ 5, 6, 7, 8 });
    try std.testing.expectEqual(70.0, v1.dot(&v2));
}

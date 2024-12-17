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

        pub fn add_scalar(self: *const Self, scalar: T) Self {
            const scalar_vec: @Vector(N, T) = @splat(scalar);
            return Self.init(self.vec + scalar_vec);
        }

        pub fn sub(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec - other.vec);
        }

        pub fn sub_scalar(self: *const Self, scalar: T) Self {
            const scalar_vec: @Vector(N, T) = @splat(scalar);
            return Self.init(self.vec - scalar_vec);
        }

        pub fn mul(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec * other.vec);
        }

        pub fn mul_scalar(self: *const Self, scalar: T) Self {
            const scalar_vec: @Vector(N, T) = @splat(scalar);
            return Self.init(self.vec * scalar_vec);
        }

        pub fn div(self: *const Self, other: *const Self) Self {
            return Self.init(self.vec / other.vec);
        }

        pub fn div_scalar(self: *const Self, scalar: T) Self {
            const scalar_vec: @Vector(N, T) = @splat(scalar);
            return Self.init(self.vec / scalar_vec);
        }

        pub fn magnitude(self: *const Self) T {
            return @sqrt(self.dot(self));
        }

        pub fn normalized(self: *const Self) Self {
            const mag = self.magnitude();

            if (mag == 0) {
                return Self.init(@splat(0.0));
            }

            return self.div_scalar(mag);
        }

        pub fn dot(self: *const Self, other: *const Self) T {
            return @reduce(.Add, self.vec * other.vec);
        }

        pub fn cross(self: *const Vector(3, T), other: *const Vector(3, T)) Self {
            const a1 = @Vector(3, T){ self.y(), self.z(), self.x() };
            const b1 = @Vector(3, T){ other.z(), other.x(), other.y() };
            const a2 = @Vector(3, T){ self.z(), self.x(), self.y() };
            const b2 = @Vector(3, T){ other.y(), other.z(), other.x() };

            return Self.init(a1 * b1 - a2 * b2);
        }
    };
}

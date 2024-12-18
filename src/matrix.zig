pub fn Matrix(comptime M: usize, comptime N: usize, comptime T: type) type {
    return struct {
        mat: @Vector(M * N, T),
        const Self = @This();

        pub fn init(mat: @Vector(M * N, T)) Self {
            return Self{
                .mat = mat,
            };
        }

        pub fn zero() Self {
            return Self.init(@splat(0.0));
        }

        pub fn identity() Self {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }
            }

            var mat = Self.zero();

            for (0..M) |i| {
                mat.mat[i * M + i] = 1.0;
            }

            return mat;
        }

        pub fn at(self: *const Self, row: usize, column: usize) *T {
            return @constCast(&self.mat[row * M + column]);
        }

        pub fn transpose(self: *const Self) Self {
            var mat = Self.zero();

            for (0..M) |i| {
                for (0..N) |j| {
                    mat.mat[i * N + j] = self.mat[j * M + i];
                }
            }

            return mat;
        }

        pub fn minor(self: *const Self, row: usize, column: usize) Matrix(M - 1, N - 1, T) {
            comptime {
                if (M != N and M <= 2) {
                    @compileError("Matrix must be square");
                }
            }

            var minor_matrix = Matrix(M - 1, N - 1, T).zero();
            var minor_row: usize = 0;

            for (0..M) |i| {
                if (i == row) {
                    continue;
                }

                var minor_column: usize = 0;

                for (0..N) |j| {
                    if (j == column) {
                        continue;
                    }

                    minor_matrix.mat[minor_row * (M - 1) + minor_column] = self.mat[i * M + j];
                    minor_column += 1;
                }

                minor_row += 1;
            }

            return minor_matrix;
        }

        pub fn cofactor(self: *const Self) Self {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }
            }

            var cofactor_matrix = Self.zero();

            for (0..M) |i| {
                for (0..N) |j| {
                    const sign: T = if ((i + j) % 2 == 0) 1 else -1;
                    cofactor_matrix.mat[i * M + j] = sign * self.minor(i, j).determinant();
                }
            }

            return cofactor_matrix;
        }

        pub fn determinant(self: *const Self) T {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }

                if (M == 1) {
                    return self.mat[0];
                }
            }

            switch (M) {
                2 => {
                    return self.mat[0] * self.mat[3] - self.mat[1] * self.mat[2];
                },
                else => {
                    var det: T = 0;
                    for (0..M) |i| {
                        det += self.mat[i] * self.cofactor().mat[i];
                    }
                    return det;
                },
            }
        }

        pub fn adjugate(self: *const Self) Self {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }
            }

            return self.cofactor().transpose();
        }

        pub fn inverse(self: *const Self) Self {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }
            }

            const det = self.determinant();

            if (det == 0) {
                return Self.zero();
            }

            return self.adjugate().div_scalar(det);
        }

        pub fn add(self: *const Self, other: *const Self) Self {
            return Self.init(self.mat + other.mat);
        }

        pub fn sub(self: *const Self, other: *const Self) Self {
            return Self.init(self.mat - other.mat);
        }

        pub fn mul(self: *const Self, other: *const Self) Self {
            var mat = Self.zero();

            for (0..M) |i| {
                for (0..N) |j| {
                    for (0..N) |k| {
                        mat.mat[i * M + j] += self.mat[i * M + k] * other.mat[k * M + j];
                    }
                }
            }

            return mat;
        }

        pub fn mul_scalar(self: *const Self, scalar: T) Self {
            const mat_scalar = Self.init(@splat(scalar));
            return self.mul(&mat_scalar);
        }

        pub fn div(self: *const Self, other: *const Self) Self {
            return Self.init(self.mat / other.mat);
        }

        pub fn div_scalar(self: *const Self, scalar: T) Self {
            const mat_scalar: @Vector(M * N, T) = @splat(scalar);
            return Self.init(self.mat / mat_scalar);
        }
    };
}

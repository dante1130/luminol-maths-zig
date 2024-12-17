pub fn Matrix(comptime M: usize, N: usize, comptime T: type) type {
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
                mat.mat[i * N + i] = 1.0;
            }

            return mat;
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
            var minor_row = 0;

            for (0..M) |i| {
                if (i == row) {
                    continue;
                }

                var minor_column = 0;

                for (0..N) |j| {
                    if (j == column) {
                        continue;
                    }

                    minor_matrix.mat[minor_row * N + minor_column] = self.mat[i * N + j];
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
                    const sign = if ((i + j) % 2 == 0) 1 else -1;
                    cofactor_matrix.mat[i * N + j] = sign * self.minor(i, j).determinant();
                }
            }

            return cofactor_matrix;
        }

        pub fn determinant(self: *const Self) T {
            comptime {
                if (M != N) {
                    @compileError("Matrix must be square");
                }

                switch (M) {
                    1 => {
                        return self.mat[0];
                    },
                    2 => {
                        return self.mat[0] * self.mat[3] - self.mat[1] * self.mat[2];
                    },
                    _ => {
                        var det = 0;
                        for (0..M) |i| {
                            det += self.mat[i * N + 0] * self.cofactor()[i * N + 0];
                        }
                        return det;
                    },
                }
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
                        mat.mat[i * N + j] += self.mat[i * N + k] * other.mat[k * N + j];
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
            const mat_scalar: @Vector(N * N, T) = @splat(scalar);
            return Self.init(self.mat / mat_scalar);
        }
    };
}
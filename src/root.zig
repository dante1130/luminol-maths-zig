const std = @import("std");

pub const Vector = @import("vector.zig").Vector;

pub const Vec2 = Vector(2, f64);
pub const Vec3 = Vector(3, f64);
pub const Vec4 = Vector(4, f64);

pub const Vec2f = Vector(2, f32);
pub const Vec3f = Vector(3, f32);
pub const Vec4f = Vector(4, f32);

pub const Matrix = @import("matrix.zig").Matrix;

pub const Mat2x2 = Matrix(2, 2, f64);
pub const Mat3x3 = Matrix(3, 3, f64);
pub const Mat4x4 = Matrix(4, 4, f64);

pub const Mat2x2f = Matrix(2, 2, f32);
pub const Mat3x3f = Matrix(3, 3, f32);
pub const Mat4x4f = Matrix(4, 4, f32);

pub const transform = @import("transform.zig");
pub const unit = @import("units/unit.zig");

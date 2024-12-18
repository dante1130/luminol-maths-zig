pub const Time = @import("time.zig").Time;

pub const Seconds = Time(f64, .second);
pub const Minutes = Time(f64, .minute);
pub const Milliseconds = Time(f64, .millisecond);
pub const Nanoseconds = Time(f64, .nanosecond);

pub const Seconds_f = Time(f32, .second);
pub const Minutes_f = Time(f32, .minute);
pub const Milliseconds_f = Time(f32, .millisecond);
pub const Nanoseconds_f = Time(f32, .nanosecond);

pub const Angle = @import("angle.zig").Angle;

pub const Degrees = Angle(f64, .degrees);
pub const Radians = Angle(f64, .radians);

pub const Degrees_f = Angle(f32, .degrees);
pub const Radians_f = Angle(f32, .radians);

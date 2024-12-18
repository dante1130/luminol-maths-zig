const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "luminol_maths",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const module = b.addModule("luminol_maths", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    module.linkLibrary(lib);

    const test_step = b.step("test", "Run unit tests");

    const test_root_source_files = [_][]const u8{
        "src/root.zig",
        "src/vector.zig",
        "src/matrix.zig",
        "src/transform.zig",
        "src/units/time.zig",
    };

    for (0..test_root_source_files.len) |i| {
        add_test(
            b,
            target,
            optimize,
            test_step,
            b.path(test_root_source_files[i]),
        );
    }
}

pub fn add_test(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    test_step: *std.Build.Step,
    root_source_file: std.Build.LazyPath,
) void {
    const new_test = b.addTest(.{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = optimize,
    });

    const run_test = b.addRunArtifact(new_test);
    test_step.dependOn(&run_test.step);
}

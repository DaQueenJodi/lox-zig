const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const use_llvm = b.option(bool, "llvm", "") orelse false;
    const exe = b.addExecutable(.{
        .name = "lox",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
        .use_llvm = use_llvm,
        .use_lld = use_llvm,
    });
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_exe_step = b.step("run", "");
    run_exe_step.dependOn(&run_exe.step);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "tests.zig" },
    });

    const run_tests = b.addRunArtifact(tests);
    const run_tests_step = b.step("test", "");
    run_tests_step.dependOn(&run_tests.step);
}

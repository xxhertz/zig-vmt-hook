const std = @import("std");

pub fn build(b: *std.Build) void {
    const module = b.addModule("hooking", .{
        .root_source_file = b.path("src/hooking.zig"),
    });
    const zigwin32_dep = b.dependency("zigwin32", .{});
    module.addImport("zigwin32", zigwin32_dep.module("zigwin32"));
}

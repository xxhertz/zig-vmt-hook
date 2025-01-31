const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("hooking", .{
        .root_source_file = b.path("src/hooking.zig"),
    });
}

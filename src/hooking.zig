const std = @import("std");
const win32 = @import("zigwin32");
const mem = win32.system.memory;

pub const hook_data = struct {
    original_ptr: usize,
    vtable: [*]align(1) usize,
    index: u32, // surely the program doesn't have a vtable of size 17179869184 bytes (or 34359738368 on x64)?
};

pub const hook_state = struct {
    var list: std.ArrayList(hook_data) = undefined;
    var allocator: std.mem.Allocator = undefined;
};

pub fn init(alloc: std.mem.Allocator) void {
    hook_state.list = std.ArrayList(hook_data).init(alloc);
    hook_state.allocator = alloc;
}

pub fn deinit() void {
    for (hook_state.list.items) |hook| {
        var old_protection: mem.PAGE_PROTECTION_FLAGS = .{};
        _ = mem.VirtualProtect(&hook.vtable[hook.index], @sizeOf(usize), .{ .PAGE_READWRITE = 1 }, &old_protection);
        hook.vtable[hook.index] = hook.original_ptr;
        _ = mem.VirtualProtect(&hook.vtable[hook.index], @sizeOf(usize), old_protection, &old_protection);
    }
}

pub fn virtual_hook(vtable: [*]align(1) usize, index: u32, hook_ptr: *const anyopaque) *anyopaque {
    hook_state.list.append(.{ .index = index, .original_ptr = vtable[index], .vtable = vtable }) catch @panic("error: either you forgot to call hooking.init(alloc), or some other error with the allocator occured");

    var old_protection: mem.PAGE_PROTECTION_FLAGS = .{};
    _ = mem.VirtualProtect(&vtable[index], @sizeOf(usize), .{ .PAGE_READWRITE = 1 }, &old_protection);
    vtable[index] = @intFromPtr(hook_ptr);
    _ = mem.VirtualProtect(&vtable[index], @sizeOf(usize), old_protection, &old_protection);

    return @ptrFromInt(vtable[index]);
}

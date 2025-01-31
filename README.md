# To get started:

```zig
// Import the library
const hooking = @import("vmthook");
```

```zig
// Initialize the library at runtime
hooking.init(allocator);
```

```zig
// Hook a function
original_func = @ptrCast(hooking.virtual_hook(vtable, 10, @intFromPtr(&hook)));
```

```zig
// Release all hooks
hooking.deinit();
```

This works for both x86 and x64, you can see examples in my recent projects:
* [zig-css-internal](https://github.com/xxhertz/zig-css-internal) for x86
* [zig-gmod-internal](https://github.com/xxhertz/zig-gmod-internal/blob/main/src/root.zig) for x64
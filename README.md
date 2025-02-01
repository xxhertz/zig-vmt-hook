# To get started:


```zig
// Fetch the library via `zig fetch --save=vmthook git+https://github.com/xxhertz/zig-vmt-hook#main`
// build.zig
const vmthook_dep = b.dependency("vmthook", .{});
// for dll/lib
lib.root_module.addImport("vmthook", vmthook_dep.module("hooking"));
// for exe
exe.addImport("vmthook", vmthook_dep.module("hooking"));
// for modules
exe.addImport("vmthook", vmthook_dep.module("hooking"));
```

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
original_func = @ptrCast(hooking.virtual_hook(vtable, 10, &hook));
```

```zig
// Release all hooks
hooking.deinit();
```

This works for both x86 and x64, you can see examples in my recent projects:
* [zig-css-internal](https://github.com/xxhertz/zig-css-internal) for x86
* [zig-gmod-internal](https://github.com/xxhertz/zig-gmod-internal/blob/main/src/root.zig) for x64
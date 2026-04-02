# liblegere

Analyze your texts readability.


`liblegere` delivers the formulas you need to calculate a text's readability.

# Usage

### Add to your Zig project

Install the library with:

```sh
zig fetch --save git+https://github.com/ivansantiagojr/liblegere.git
```

Then add to your `build.zig`:

```zig
const legere = b.dependency(
    "legere",
    .{ .target = target, .optimize = optimize },
);
```

And add the module to your executable or library:

```zig
legere.module("legere");
```

### Using a formula in your code

Import legere with:

```zig
const legere = @import("legere");

const result = legere.ari("Hello, world!"); // 4.0
```

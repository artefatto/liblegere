//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const tokenizer = @import("tokenizer.zig");
const formulas = @import("formulas.zig");

pub const ari = formulas.ari;

test {
    std.testing.refAllDecls(@This());
}

const std = @import("std");
const unicode = @import("unicode.zig");

pub fn countWords(text: []const u8) usize {
    var count: usize = 0;
    var it = std.mem.tokenizeAny(u8, text, " ");
    while (it.next()) |_| {
        count += 1;
    }

    return count;
}

pub fn countCharacters(text: []const u8) usize {
    var count: usize = 0;
    const view = std.unicode.Utf8View.init(text) catch return 0;
    var it = view.iterator();
    while (it.nextCodepoint()) |cp| {
        if (unicode.isAlphanumeric(cp)) count += 1;
    }
    return count;
}

pub fn countSentences(text: []const u8) usize {
    var count: usize = 0;
    var it = std.mem.tokenizeAny(u8, text, ".!?;");
    while (it.next()) |_| {
        count += 1;
    }

    return count;
}

test "countWords with single word" {
    try std.testing.expectEqual(1, countWords("hello"));
}

test "countWords with single word and punctuation" {
    try std.testing.expectEqual(1, countWords("hello."));
    try std.testing.expectEqual(1, countWords("hello,"));
    try std.testing.expectEqual(1, countWords("hello;"));
}

test "countWords with two words and punctuation" {
    try std.testing.expectEqual(2, countWords("hello world"));
    try std.testing.expectEqual(2, countWords("hello, world!"));
}

test "countWords with complex sentences" {
    try std.testing.expectEqual(7, countWords("All your codebase are belong to us!"));
}

test "countWords with trailing and leading spaces" {
    try std.testing.expectEqual(1, countWords("   hello"));
    try std.testing.expectEqual(1, countWords("hello   "));
    try std.testing.expectEqual(1, countWords("   hello   "));
}

test "countWords with multiple irregular spaces" {
    try std.testing.expectEqual(7, countWords("All    your  codebase are belong    to us!  "));
}

test "countWords considers characters between spaces as a word" {
    try std.testing.expectEqual(2, countWords("Hello !"));
}

test "countWords considers non-ascii" {
    try std.testing.expectEqual(2, countWords("Olá, mundo!"));
}

test "countCharacters with 5 characters" {
    try std.testing.expectEqual(5, countCharacters("hello"));
}

test "countCharacters does not consider spaces" {
    try std.testing.expectEqual(10, countCharacters("hello world"));
}

test "countCharacters does not count line breaks" {
    const text_with_line_breaks =
        \\hello
        \\world
    ;
    try std.testing.expectEqual(10, countCharacters(text_with_line_breaks));
}

test "countCharacters does not consider punctuations" {
    try std.testing.expectEqual(5, countCharacters("hello!"));
    try std.testing.expectEqual(0, countCharacters(",.;:!"));
}

test "countCharacters considers non-ascii characters" {
    try std.testing.expectEqual(3, countCharacters("Olá"));
    try std.testing.expectEqual(5, countCharacters("áéíóú"));
}

test "countSentences single sentence" {
    try std.testing.expectEqual(1, countSentences("Simple four word sentence."));
}

test "countSentences separated by period" {
    try std.testing.expectEqual(2, countSentences("First sentence. A second sentence."));
}

test "countSentences separated by exclamation mark" {
    try std.testing.expectEqual(2, countSentences("First sentence! A second sentence."));
}

test "countSentences separated by question mark" {
    try std.testing.expectEqual(2, countSentences("Is this the first sentence? A second sentence."));
}

test "countSentences separated by semicolon" {
    try std.testing.expectEqual(2, countSentences("First sentence; A second sentence."));
}

test "countSentences consecutive terminators count as one" {
    try std.testing.expectEqual(1, countSentences("A single sentence..."));
    try std.testing.expectEqual(1, countSentences("A single sentence?!"));
}

test "countSentences single sentence no terminator" {
    try std.testing.expectEqual(1, countSentences("Hello world"));
}

test "countSentences multiple sentences" {
    try std.testing.expectEqual(3, countSentences("Hello world. How are you? I am fine."));
}

test "countSentences empty string" {
    try std.testing.expectEqual(0, countSentences(""));
}

test "countSentences known limitation: abbreviations are counted as sentence terminators" {
    // Mr. Dr. etc. are not handled as abbreviations yet.
    // "Mr. Smith" is counted as 2 sentences instead of 1.
    // This is a known limitation to be addressed in a future version.
    try std.testing.expectEqual(2, countSentences("Mr. Smith went home."));
    try std.testing.expectEqual(3, countSentences("Dr. Smith and Mr. Jones went home."));
}

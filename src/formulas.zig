const std = @import("std");
const tokenizer = @import("tokenizer.zig");

pub fn ari(text: []const u8) !f64 {
    const chars = tokenizer.countCharacters(text);
    const words = tokenizer.countWords(text);
    const sentences = tokenizer.countSentences(text);

    const chars_per_words = @as(f64, @floatFromInt(chars)) / @as(f64, @floatFromInt(words));
    const words_per_sentences = @as(f64, @floatFromInt(words)) / @as(f64, @floatFromInt(sentences));

    const result = (4.71 * chars_per_words) + (0.5 * (words_per_sentences)) - 21.43;

    return @ceil(result);
}

test "ari returns correct score" {
    const text = "A simple sentence.";

    const chars = tokenizer.countCharacters(text);
    const words = tokenizer.countWords(text);
    const sentences = tokenizer.countSentences(text);

    try std.testing.expectEqual(15, chars);
    try std.testing.expectEqual(3, words);
    try std.testing.expectEqual(1, sentences);

    // Expected rounded up scoring
    try std.testing.expectEqual(4, ari(text));
}

const std = @import("std");

const Lexer = @This();

const TokenFlavor = enum {
    // zig fmt: off
    left_paren, right_paren, left_brace, right_brace,
    comma, dot, semicolon,
    mius, plus, slash, star,

    equal, not_equal, equal_equal,
    greater_than, greater_equal,
    less_than, less_equal,

    identifier, string, number,

    @"and", @"for", @"if", @"or", @"while", @"return",
    @"false", @"true", @"nil",
    @"var", @"super", @"this",

    class, fun,
    eof,
    // zig fmt: on
};

pub const Token = struct {
    flavor: TokenFlavor,
    lexeme: []const u8,
    line: u32,
    pub fn init(flavor: TokenFlavor, lexeme: []const u8, line: u32) Token {
        return .{
            .flavor = flavor,
            .lexeme = lexeme,
            .line = line,
        };
    }
    pub fn format(token: Token, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) void {
        try writer.print("[line {d}] {s}: {s}", .{token.line, @tagName(token.flavor), token.lexeme});
    }
};

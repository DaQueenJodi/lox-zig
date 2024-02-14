const std = @import("std");
const Lexer = @import("Lexer.zig");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();
    const stdin = std.io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args_iter = std.process.args();
    _ = args_iter.next() orelse unreachable;
    if (args_iter.next()) |path| {
        // if there is more than 1 argument, something is wrong
        if (args_iter.next() != null) {
            try stderr.writeAll("Usage: lox [script]\n");
            return error.UnexpectedArgument;
        }

        const file = try std.fs.cwd().openFile(path, .{});
        defer file.close();
        const stat = try file.stat();
        const buf = try allocator.alloc(u8, stat.size);
        defer allocator.free(buf);
        _ = try file.readAll(buf);

        run(buf);
        
    } else {
        var line_buf = std.BoundedArray(u8, 1024){};
        while (true) {
            try stdout.writeAll("> ");
            try stdin.readUntilDelimiterStreaming(line_buf.writer(), '\n', line_buf.len);
            defer line_buf.len = 0;
            run(line_buf.slice());
        }
    }
}

fn run(source: []const u8) void {
    const stdout = std.io.getStdOut().writer();
    var lexer = Lexer.init(source);
    const tokens = lexer.scanTokens();
    for (tokens) |token| {
        try stdout.print("{}\n", .{token});
    }
}


fn report_error(line: u32, message: []const u8) void {
    report(line, "", message);
}
fn report(line: u32, where: []const u8, message: []const u8) void {
    std.io.getStdOut().writer().print("[line {d}] Error {s}: {s}\n", .{line, where, message});
}

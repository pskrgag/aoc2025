const std = @import("std");
const fs = std.fs;

fn maxSlice(comptime T: type, slice: []const T) usize {
    if (slice.len == 0) @panic("Slice cannot be empty");

    var max_idx: usize = 0;
    for (slice[1..], 1..) |item, i| {
        if (item > slice[max_idx]) {
            max_idx = i;
        }
    }
    return max_idx;
}

fn part1() !void {
    const file = try fs.cwd().openFile("in", .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var file_reader_wrapper = file.reader(&file_buffer);
    const reader = &file_reader_wrapper.interface;

    var res: usize = 0;

    while (true) {
        const line = reader.takeDelimiter('\n') catch |err| switch (err) {
            else => return err,
        } orelse break;

        const maxFisrt = maxSlice(u8, line[0 .. line.len - 1]);
        const maxLast = maxFisrt + 1 + maxSlice(u8, line[maxFisrt + 1 ..]);

        res += (line[maxFisrt] - '0') * 10 + (line[maxLast] - '0');
    }
    std.debug.print("{d}\n", .{res});
}

fn part2() !void {
    const file = try fs.cwd().openFile("in", .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var file_reader_wrapper = file.reader(&file_buffer);
    const reader = &file_reader_wrapper.interface;

    var res: usize = 0;

    while (true) {
        const line = reader.takeDelimiter('\n') catch |err| switch (err) {
            else => return err,
        } orelse break;

        var prev: usize = 0xFFFFFFFFFFFFFFFF;
        var tmp: usize = 0;

        for (0..12) |i| {
            prev = prev +% 1 + maxSlice(u8, line[prev +% 1 .. line.len - 12 + i + 1]);
            tmp += (line[prev] - '0') * std.math.pow(usize, 10, 12 - i - 1);
        }

        res += tmp;
    }
    std.debug.print("{d}\n", .{res});
}

pub fn main() !void {
    try part2();
}


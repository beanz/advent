const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const WIDTH = 201;
const SIZE = WIDTH * WIDTH;
const Image = struct {
    lookup: [512]bool,
    image: [2][SIZE]bool,
    cur: usize,
    min: usize,
    max: usize,

    fn chomp(inp: []const u8) Image {
        var img = Image{
            .lookup = undefined,
            .image = .{.{false} ** SIZE} ** 2,
            .cur = 0,
            .min = 51,
            .max = undefined,
        };
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            switch (inp[i]) {
                '\n' => break,
                '#' => img.lookup[i] = true,
                '.' => {},
                else => unreachable,
            }
        }
        i += 2;
        var y: usize = 51;
        var j: usize = 51 + y * WIDTH;
        while (i < inp.len) : (i += 1) {
            switch (inp[i]) {
                '#' => {
                    img.image[img.cur][j] = true;
                    j += 1;
                },
                '.' => {
                    j += 1;
                },
                '\n' => {
                    y += 1;
                    j = 51 + y * WIDTH;
                },
                else => unreachable,
            }
        }
        img.max = y;
        return img;
    }

    fn enhance(self: *Image, default: bool) usize {
        var c: usize = 0;
        const next = 1 - self.cur;
        for ((self.min - 1)..(self.max + 1)) |y| {
            var nb: usize = if (default and self.lookup[0]) 0b11011011 else 0;
            for ((self.min - 1)..(self.max + 1)) |x| {
                nb = ((nb << 1) & 0b110110110) +
                    (self.get(x + 1, y - 1, default) << 6) +
                    (self.get(x + 1, y, default) << 3) +
                    self.get(x + 1, y + 1, default);
                const n = self.lookup[nb];
                self.image[next][x + y * WIDTH] = n;
                c += @intFromBool(n);
            }
        }
        self.min -= 1;
        self.max += 1;
        self.cur = next;
        return c;
    }

    fn get(self: *const Image, x: usize, y: usize, default: bool) usize {
        return @as(usize, @intFromBool(if (x < self.max and self.min <= y and y < self.max)
            self.image[self.cur][x + y * WIDTH]
        else
            default and self.lookup[0]));
    }
    pub fn format(self: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        for (self.min..self.max) |y| {
            for (self.min..self.max) |x| {
                try writer.print("{c}", .{@as(u8, if (self.image[self.cur][x + y * WIDTH]) '#' else '.')});
            }
            try writer.print("\n", .{});
        }
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i = Image.chomp(inp);
    _ = i.enhance(false);
    const p1 = i.enhance(true);
    var p2: usize = undefined;
    for (3..27) |_| {
        _ = i.enhance(false);
        p2 = i.enhance(true);
    }
    return [2]usize{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

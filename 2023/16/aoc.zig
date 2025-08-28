const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Dir = enum(u4) {
    UP = 1,
    DOWN = 2,
    RIGHT = 4,
    LEFT = 8,
};

const Beam = struct { x: isize, y: isize, d: Dir };

fn solve(inp: []const u8, w: usize, h: usize, x: isize, y: isize, d: Dir) !usize {
    var seen: [14000]u4 = std.mem.zeroes([14000]u4);
    var todo = try std.BoundedArray(Beam, 128).init(0);
    try todo.append(Beam{ .x = x, .y = y, .d = d });
    while (todo.len > 0) {
        const cur = todo.pop().?;
        if (cur.x < 0 or cur.x >= w or cur.y < 0 or cur.y >= h) {
            continue;
        }
        const iy: usize = @intCast(cur.y);
        const ix: usize = @intCast(cur.x);
        const i: usize = (w + 1) * iy + ix;
        if (seen[i] & @intFromEnum(cur.d) != 0) {
            continue;
        }
        seen[i] |= @intFromEnum(cur.d);
        switch (inp[i]) {
            '.' => switch (cur.d) {
                Dir.UP => try todo.append(Beam{ .x = cur.x, .y = cur.y - 1, .d = cur.d }),
                Dir.DOWN => try todo.append(Beam{ .x = cur.x, .y = cur.y + 1, .d = cur.d }),
                Dir.LEFT => try todo.append(Beam{ .x = cur.x - 1, .y = cur.y, .d = cur.d }),
                Dir.RIGHT => try todo.append(Beam{ .x = cur.x + 1, .y = cur.y, .d = cur.d }),
            },
            '-' => switch (cur.d) {
                Dir.LEFT => try todo.append(Beam{ .x = cur.x - 1, .y = cur.y, .d = cur.d }),
                Dir.RIGHT => try todo.append(Beam{ .x = cur.x + 1, .y = cur.y, .d = cur.d }),
                else => {
                    try todo.append(Beam{ .x = cur.x + 1, .y = cur.y, .d = Dir.RIGHT });
                    try todo.append(Beam{ .x = cur.x - 1, .y = cur.y, .d = Dir.LEFT });
                },
            },
            '|' => switch (cur.d) {
                Dir.UP => try todo.append(Beam{ .x = cur.x, .y = cur.y - 1, .d = cur.d }),
                Dir.DOWN => try todo.append(Beam{ .x = cur.x, .y = cur.y + 1, .d = cur.d }),
                else => {
                    try todo.append(Beam{ .x = cur.x, .y = cur.y - 1, .d = Dir.UP });
                    try todo.append(Beam{ .x = cur.x, .y = cur.y + 1, .d = Dir.DOWN });
                },
            },
            '/' => switch (cur.d) {
                Dir.UP => try todo.append(Beam{ .x = cur.x + 1, .y = cur.y, .d = Dir.RIGHT }),
                Dir.DOWN => try todo.append(Beam{ .x = cur.x - 1, .y = cur.y, .d = Dir.LEFT }),
                Dir.LEFT => try todo.append(Beam{ .x = cur.x, .y = cur.y + 1, .d = Dir.DOWN }),
                Dir.RIGHT => try todo.append(Beam{ .x = cur.x, .y = cur.y - 1, .d = Dir.UP }),
            },
            '\\' => switch (cur.d) {
                Dir.UP => try todo.append(Beam{ .x = cur.x - 1, .y = cur.y, .d = Dir.LEFT }),
                Dir.DOWN => try todo.append(Beam{ .x = cur.x + 1, .y = cur.y, .d = Dir.RIGHT }),
                Dir.LEFT => try todo.append(Beam{ .x = cur.x, .y = cur.y - 1, .d = Dir.UP }),
                Dir.RIGHT => try todo.append(Beam{ .x = cur.x, .y = cur.y + 1, .d = Dir.DOWN }),
            },
            else => unreachable,
        }
    }
    var c: usize = 0;
    for (seen) |e| {
        if (e != 0) {
            c += 1;
        }
    }
    return c;
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = inp.len / (w + 1);
    var p2: usize = 0;
    for (0..w) |x| {
        var s = try solve(inp, w, h, @intCast(x), 0, Dir.DOWN);
        if (s > p2) {
            p2 = s;
        }
        s = try solve(inp, w, h, @intCast(x), @intCast(h - 1), Dir.UP);
        if (s > p2) {
            p2 = s;
        }
    }
    for (0..h) |y| {
        var s = try solve(inp, w, h, 0, @intCast(y), Dir.LEFT);
        if (s > p2) {
            p2 = s;
        }
        s = try solve(inp, w, h, @intCast(w - 1), @intCast(y), Dir.RIGHT);
        if (s > p2) {
            p2 = s;
        }
    }
    return [2]usize{ try solve(inp, w, h, 0, 0, Dir.RIGHT), p2 };
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

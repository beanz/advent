const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(usize, parts);
}

const Dir = enum {
    NORTH,
    SOUTH,
    EAST,
    WEST,
    NONE,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const w: usize = 1 + (std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable);
    const s = std.mem.indexOfScalar(u8, inp, 'S') orelse unreachable;
    var from = firstMove(inp, s, w);

    var p = mov(s, w, from);
    var p1: usize = 1;
    var area = shoelace(@intCast(s), @intCast(p), @intCast(w));
    while (true) {
        const step = nextDir(inp[p], from);
        const n = mov(p, w, step);
        area += shoelace(@intCast(p), @intCast(n), @intCast(w));
        p = n;
        from = step;
        p1 += 1;
        if (p == s) {
            break;
        }
    }
    p1 /= 2;
    return [2]usize{ p1, @abs(area) / 2 - p1 + 1 };
}

fn nextDir(ch: u8, from: Dir) Dir {
    const ds = dirs(ch);
    if (ds[0] == opposite(from)) {
        return ds[1];
    } else {
        return ds[0];
    }
}

fn firstMove(inp: []const u8, s: usize, w: usize) Dir {
    if (s >= w and (dirs(inp[s - w])[0] == Dir.SOUTH or dirs(inp[s - w])[1] == Dir.SOUTH)) {
        return Dir.NORTH;
    } else if (s > 0 and (dirs(inp[s - 1])[0] == Dir.EAST or dirs(inp[s - 1])[1] == Dir.EAST)) {
        return Dir.WEST;
    } else if (s + w < inp.len and (dirs(inp[s + w])[0] == Dir.NORTH or dirs(inp[s + w])[1] == Dir.NORTH)) {
        return Dir.SOUTH;
    } else if (s + 1 < inp.len and (dirs(inp[s + 1])[0] == Dir.WEST or dirs(inp[s + 1])[1] == Dir.WEST)) {
        return Dir.EAST;
    }
    unreachable;
}

fn shoelace(a: isize, b: isize, w: isize) isize {
    const ax = @divFloor(a, w);
    const ay = @mod(a, w);
    const bx = @divFloor(b, w);
    const by = @mod(b, w);
    return (ax - bx) * (ay + by);
}

fn mov(i: usize, w: usize, d: Dir) usize {
    return switch (d) {
        Dir.NORTH => i - w,
        Dir.SOUTH => i + w,
        Dir.EAST => i + 1,
        Dir.WEST => i - 1,
        else => unreachable,
    };
}

fn opposite(d: Dir) Dir {
    return switch (d) {
        Dir.NORTH => Dir.SOUTH,
        Dir.SOUTH => Dir.NORTH,
        Dir.EAST => Dir.WEST,
        Dir.WEST => Dir.EAST,
        else => unreachable,
    };
}

fn dirs(ch: u8) [2]Dir {
    return switch (ch) {
        '|' => [2]Dir{ Dir.NORTH, Dir.SOUTH },
        '-' => [2]Dir{ Dir.EAST, Dir.WEST },
        'L' => [2]Dir{ Dir.NORTH, Dir.EAST },
        'J' => [2]Dir{ Dir.NORTH, Dir.WEST },
        '7' => [2]Dir{ Dir.SOUTH, Dir.WEST },
        'F' => [2]Dir{ Dir.SOUTH, Dir.EAST },
        else => [2]Dir{ Dir.NONE, Dir.NONE },
    };
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

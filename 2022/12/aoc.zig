const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

pub fn Grid(comptime T: type) type {
    return struct {
        m: []const u8,
        w: T,
        w1: T,
        h: T,
        uw1: usize,
        uh: usize,

        fn init(inp: []const u8) Grid(T) {
            const w = std.mem.indexOfScalar(u8, inp, '\n').? + 1;
            const h = inp.len / w;
            return Grid(T){
                .m = inp,
                .w = @intCast(w - 1),
                .w1 = @intCast(w),
                .h = @intCast(h),
                .uw1 = w,
                .uh = h,
            };
        }
        fn findXY(self: Grid(T), ch: u8) ?[2]T {
            const i = std.mem.indexOfScalar(u8, self.m, ch) orelse return null;
            return [2]T{ @intCast(i % self.uw1), @intCast(i / self.uw1) };
        }
        fn get(self: Grid(T), x: T, y: T) ?u8 {
            if (0 <= x and x < self.w and 0 <= y and y < self.h) {
                const i: usize = @as(usize, @intCast(x)) + @as(usize, @intCast(y)) * self.uw1;
                return self.m[i];
            }
            return null;
        }
    };
}

fn solve(comptime T: type, g: Grid(T), start: [2]T, goal: u8) !usize {
    var visited: [41][161]bool = .{.{false} ** 161} ** 41;
    const Rec = struct {
        x: T,
        y: T,
        h: u8,
        st: usize,
    };
    var back: [1024]Rec = undefined;
    var work = aoc.Deque(Rec).init(back[0..]);
    try work.push(Rec{ .x = start[0], .y = start[1], .h = 'z', .st = 0 });
    while (work.pop()) |cur| {
        if (g.get(cur.x, cur.y) == goal) {
            return cur.st;
        }
        for (&[_][2]T{ .{ 0, -1 }, .{ 1, 0 }, .{ 0, 1 }, .{ -1, 0 } }) |n| {
            const nx = n[0] + cur.x;
            const ny = n[1] + cur.y;
            if (g.get(nx, ny)) |ch| {
                const h = switch (ch) {
                    'S' => 'a',
                    'E' => 'z',
                    else => ch,
                };
                if (cur.h > 1 + h) {
                    continue;
                }
                if (visited[@intCast(ny)][@intCast(nx)]) {
                    continue;
                }
                visited[@intCast(ny)][@intCast(nx)] = true;
                try work.push(Rec{ .x = nx, .y = ny, .h = h, .st = cur.st + 1 });
            }
        }
    }
    unreachable;
}

fn parts(inp: []const u8) anyerror![2]usize {
    const g = Grid(i32).init(inp);
    const end = g.findXY('E').?;
    return [2]usize{ try solve(i32, g, end, 'S'), try solve(i32, g, end, 'a') };
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

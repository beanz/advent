const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases([9]u8, parts);
}

const Dock = struct {
    stacks: [9][60]u8,
    l: [9]usize,
    pub fn init() Dock {
        return Dock{
            .stacks = undefined,
            .l = .{0} ** 9,
        };
    }
    pub fn push(self: *Dock, stack: usize, crate: u8) void {
        self.stacks[stack][self.l[stack]] = crate;
        self.l[stack] += 1;
    }
    pub fn reverse(self: *Dock, stack: usize) void {
        std.mem.reverse(u8, self.stacks[stack][0..self.l[stack]]);
    }
    pub fn top(self: *Dock, stack: usize) ?u8 {
        if (self.l[stack] == 0) {
            return null;
        }
        return self.stacks[stack][self.l[stack] - 1];
    }
    pub fn move1(self: *Dock, from: usize, to: usize, n: usize) void {
        const fromEnd = self.l[from] - 1;
        const toEnd = self.l[to];
        for (0..n) |i| {
            self.stacks[to][toEnd + i] = self.stacks[from][fromEnd - i];
        }
        self.l[from] -= n;
        self.l[to] += n;
    }
    pub fn move2(self: *Dock, from: usize, to: usize, n: usize) void {
        const fromEnd = self.l[from];
        const toEnd = self.l[to];
        std.mem.copyForwards(u8, self.stacks[to][toEnd .. toEnd + n], self.stacks[from][fromEnd - n .. fromEnd]);
        self.l[from] -= n;
        self.l[to] += n;
    }
};

fn parts(inp: []const u8) anyerror![2][9]u8 {
    var dock1: Dock = Dock.init();
    var dock2: Dock = Dock.init();
    var i: usize = 0;
    var j: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '\n' => {
                if (j == 0) {
                    break;
                }
                j = 0;
            },
            'A'...'Z' => {
                j += 1;
                const stack = (j - 1) >> 2;
                dock1.push(stack, inp[i]);
                dock2.push(stack, inp[i]);
            },
            else => {
                j += 1;
            },
        }
    }
    for (0..9) |stack| {
        dock1.reverse(stack);
        dock2.reverse(stack);
    }
    i += 1;
    while (i < inp.len) : (i += 13) {
        i += 5;
        const n = try aoc.chompUint(usize, inp, &i);
        const from: usize = @intCast(inp[i + 6] - '1');
        const to: usize = @intCast(inp[i + 11] - '1');
        dock1.move1(from, to, n);
        dock2.move2(from, to, n);
    }
    var p1: [9]u8 = .{32} ** 9;
    var p2: [9]u8 = .{32} ** 9;
    for (0..9) |k| {
        p1[k] = dock1.top(k) orelse 32;
        p2[k] = dock2.top(k) orelse 32;
    }
    return [2][9]u8{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

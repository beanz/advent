const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Diag = struct {
    bits: usize,
    maxbit: usize,
    nums: []usize,
    allocator: std.mem.Allocator,

    pub fn fromInput(allocator: std.mem.Allocator, inp: anytype) !*Diag {
        var nums = try allocator.alloc(usize, inp.len);
        var diag = try allocator.create(Diag);
        diag.bits = inp[0].len - 1;
        diag.maxbit = @intCast((@as(u64, 1) << @as(u6, @intCast(diag.bits))));
        for (inp, 0..) |line, i| {
            nums[i] = try std.fmt.parseUnsigned(usize, line, 2);
        }
        diag.nums = nums;
        diag.allocator = allocator;
        return diag;
    }

    pub fn deinit(self: *Diag) void {
        self.allocator.free(self.nums);
        self.allocator.destroy(self);
    }

    pub fn part1(self: *Diag) usize {
        const total = self.nums.len;
        var gamma: usize = 0;
        var bit = self.maxbit;
        while (bit >= 1) : (bit /= 2) {
            var c: usize = 0;
            for (self.nums) |n| {
                if (n & bit != 0) {
                    c += 1;
                }
            }
            if (c * 2 > total) {
                gamma += bit;
            }
        }
        return gamma * (2 * self.maxbit - 1 ^ gamma);
    }

    pub fn match(self: *Diag, val: usize, mask: usize) usize {
        for (self.nums) |n| {
            if (n & mask == val) {
                return n;
            }
        }
        return 0;
    }

    pub fn reduce(self: *Diag, most: bool) usize {
        var mask: usize = 0;
        var val: usize = 0;
        var bit = self.maxbit;
        while (bit >= 1) : (bit /= 2) {
            var c: usize = 0;
            var total: usize = 0;
            for (self.nums) |n| {
                if (n & mask != val) {
                    continue;
                }
                total += 1;
                if (n & bit != 0) {
                    c += 1;
                }
            }
            if (total == 1) {
                return self.match(val, mask);
            }
            if ((c * 2 >= total) == most) {
                val += bit;
            }
            mask += bit;
        }
        return val;
    }

    pub fn part2(self: *Diag) usize {
        return self.reduce(true) * self.reduce(false);
    }
};

test "examples" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var t = Diag.fromInput(aoc.talloc, test1) catch unreachable;
    defer t.deinit();
    var ti = Diag.fromInput(aoc.talloc, inp) catch unreachable;
    defer ti.deinit();
    try aoc.assertEq(@as(usize, 198), t.part1());
    try aoc.assertEq(@as(usize, 749376), ti.part1());
    try aoc.assertEq(@as(usize, 230), t.part2());
    try aoc.assertEq(@as(usize, 2372923), ti.part2());
}

fn day03(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var diag = try Diag.fromInput(aoc.halloc, lines);
    defer diag.deinit();
    const p1 = diag.part1();
    const p2 = diag.part2();
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day03);
}

usingnamespace @import("aoc-lib.zig");

const Diag = struct {
    bits: usize,
    maxbit: usize,
    nums: []usize,
    allocator: *Allocator,

    pub fn fromInput(inp: anytype, allocator: *Allocator) !*Diag {
        var nums = try allocator.alloc(usize, inp.len);
        var diag = try allocator.create(Diag);
        diag.bits = inp[0].len - 1;
        diag.maxbit = @intCast(usize, (@as(u64, 1) << @intCast(u6, diag.bits)));
        for (inp) |line, i| {
            nums[i] = try parseUnsigned(usize, line, 2);
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
    const talloc = @import("std").testing.allocator;
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var t = Diag.fromInput(test1, talloc) catch unreachable;
    defer t.deinit();
    var ti = Diag.fromInput(inp, talloc) catch unreachable;
    defer ti.deinit();
    try assertEq(@as(usize, 198), t.part1());
    try assertEq(@as(usize, 749376), ti.part1());
    try assertEq(@as(usize, 230), t.part2());
    try assertEq(@as(usize, 2372923), ti.part2());
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    var lines = readLines(inp);
    var diag = try Diag.fromInput(lines, alloc);
    defer diag.deinit();
    var p1 = diag.part1();
    var p2 = diag.part2();
    if (!bench) {
        try print("Part1: {}\nPart2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

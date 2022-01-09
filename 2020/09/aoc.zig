usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test1 = try Ints(test1file, i64, talloc);
    defer talloc.free(test1);
    const inp = try Ints(inputfile, i64, talloc);
    defer talloc.free(inp);

    try assertEq(@as(i64, 127), part1(test1, 5));
    try assertEq(@as(i64, 62), part2(test1, 127));

    try assertEq(@as(i64, 31161678), part1(inp, 25));
    try assertEq(@as(i64, 5453868), part2(inp, 31161678));
}

fn part1(nums: []const i64, pre: usize) i64 {
    var i = pre;
    while (i < nums.len) : (i += 1) {
        var valid = false;
        var j: usize = i - pre;
        while (j <= i) : (j += 1) {
            var k: usize = j;
            while (k <= i) : (k += 1) {
                if (nums[j] + nums[k] == nums[i]) {
                    valid = true;
                }
            }
        }
        if (!valid) {
            return nums[i];
        }
    }
    return 0;
}

fn part2(nums: []const i64, p1: i64) i64 {
    var n: usize = 1;
    while (n < nums.len) : (n += 1) {
        var i: usize = 0;
        while (i < nums.len - n) : (i += 1) {
            var s: i64 = 0;
            var min: i64 = maxInt(i64);
            var max: i64 = minInt(i64);
            var j = i;
            while (j <= i + n) : (j += 1) {
                if (nums[j] < min) {
                    min = nums[j];
                }
                if (nums[j] > max) {
                    max = nums[j];
                }
                s += nums[j];
            }
            if (s == p1) {
                return min + max;
            }
        }
    }
    return 0;
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    var nums = try Ints(inp, i64, halloc);
    defer halloc.free(nums);
    var p1 = part1(nums, 25);
    var p2 = part2(nums, p1);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

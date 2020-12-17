usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test1 = readInts(test1file, i64);
    const inp = readInts(inputfile, i64);

    assertEq(@as(i64, 127), part1(test1, 5));
    assertEq(@as(i64, 62), part2(test1, 127));

    assertEq(@as(i64, 31161678), part1(inp, 25));
    assertEq(@as(i64, 5453868), part2(inp, 31161678));
}

fn part1(nums: []const i64, pre: usize) i64 {
    var i = pre;
    while (i < nums.len) {
        var valid = false;
        var j: usize = i - pre;
        while (j <= i) {
            var k: usize = j;
            while (k <= i) {
                if (nums[j] + nums[k] == nums[i]) {
                    valid = true;
                }
                k += 1;
            }
            j += 1;
        }
        if (!valid) {
            return nums[i];
        }
        i += 1;
    }
    return 0;
}

fn part2(nums: []const i64, p1: i64) i64 {
    var n: usize = 1;
    while (n < nums.len) {
        var i: usize = 0;
        while (i < nums.len - n) {
            var s: i64 = 0;
            var min: i64 = maxInt(i64);
            var max: i64 = minInt(i64);
            var j = i;
            while (j <= i + n) {
                if (nums[j] < min) {
                    min = nums[j];
                }
                if (nums[j] > max) {
                    max = nums[j];
                }
                s += nums[j];
                j += 1;
            }
            if (s == p1) {
                return min + max;
            }
            i += 1;
        }
        n += 1;
    }
    return 0;
}

pub fn main() anyerror!void {
    var nums = readInts(input(), i64);
    var p1 = part1(nums, 25);
    try print("Part1: {}\n", .{p1});
    try print("Part2: {}\n", .{part2(nums, p1)});
}

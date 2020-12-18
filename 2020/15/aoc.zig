usingnamespace @import("aoc-lib.zig");

fn calc(nums: []const usize, maxTurn: usize) usize {
    var lastSeen = alloc.alloc(usize, maxTurn) catch unreachable;
    memset(usize, lastSeen, 0);
    var n: usize = undefined;
    var p: usize = undefined;
    var t: usize = 1;
    while (t <= nums.len) {
        n = nums[t - 1];
        if (t > 1) {
            lastSeen[p] = t;
        }
        p = n;
        t += 1;
    }
    while (t <= maxTurn) {
        if (lastSeen[p] != 0) {
            n = t - lastSeen[p];
        } else {
            n = 0;
        }
        lastSeen[p] = t;
        p = n;
        t += 1;
    }
    return n;
}

fn part1(in: []const usize) usize {
    return calc(in, 2020);
}

fn part2(in: []const usize) usize {
    return calc(in, 30000000);
}

test "examples" {
    const test1 = readInts(test1file, usize);
    const test2 = readInts(test2file, usize);
    const test3 = readInts(test3file, usize);
    const test4 = readInts(test4file, usize);
    const test5 = readInts(test5file, usize);
    const test6 = readInts(test6file, usize);
    const test7 = readInts(test7file, usize);
    const inp = readInts(inputfile, usize);

    assertEq(@as(usize, 436), part1(test1));
    assertEq(@as(usize, 1), part1(test2));
    assertEq(@as(usize, 10), part1(test3));
    assertEq(@as(usize, 27), part1(test4));
    assertEq(@as(usize, 78), part1(test5));
    assertEq(@as(usize, 438), part1(test6));
    assertEq(@as(usize, 1836), part1(test7));
    assertEq(@as(usize, 260), part1(inp));

    assertEq(@as(usize, 175594), part2(test1));
    assertEq(@as(usize, 2578), part2(test2));
    assertEq(@as(usize, 3544142), part2(test3));
    assertEq(@as(usize, 261214), part2(test4));
    assertEq(@as(usize, 6895259), part2(test5));
    assertEq(@as(usize, 18), part2(test6));
    assertEq(@as(usize, 362), part2(test7));
    assertEq(@as(usize, 950), part2(inp));
}

pub fn main() anyerror!void {
    const ints = readInts(input(), usize);
    try print("Part1: {}\n", .{part1(ints)});
    try print("Part2: {}\n", .{part2(ints)});
}

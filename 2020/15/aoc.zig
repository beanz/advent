usingnamespace @import("aoc-lib.zig");

fn calc(nums: []const i64, maxTurn: i64) i64 {
    var lastSeen = AutoHashMap(i64, i64).init(alloc);
    var n: i64 = undefined;
    var p: i64 = undefined;
    var t: i64 = 1;
    while (t <= maxTurn) {
        if (t <= nums.len) {
            n = nums[math.absCast(t - 1)];
        } else {
            if (lastSeen.get(p)) |lt| {
                n = t - 1 - lt;
            } else {
                n = 0;
            }
        }
        if (t > 1) {
            lastSeen.put(p, t - 1) catch unreachable;
        }
        p = n;
        //if ((@mod(t,100000)) == 0) {
        //   warn("{}: {}\n", .{ t, n });
        //}
        t += 1;
    }
    return n;
}

fn part1(in: []const i64) i64 {
    return calc(in, 2020);
}

fn part2(in: []const i64) i64 {
    return calc(in, 30000000);
}

test "examples" {
    const test1 = readInts(test1file);
    const test2 = readInts(test2file);
    const test3 = readInts(test3file);
    const test4 = readInts(test4file);
    const test5 = readInts(test5file);
    const test6 = readInts(test6file);
    const test7 = readInts(test7file);
    const inp = readInts(inputfile);

    assertEq(@as(i64, 436), part1(test1));
    assertEq(@as(i64, 1), part1(test2));
    assertEq(@as(i64, 10), part1(test3));
    assertEq(@as(i64, 27), part1(test4));
    assertEq(@as(i64, 78), part1(test5));
    assertEq(@as(i64, 438), part1(test6));
    assertEq(@as(i64, 1836), part1(test7));
    assertEq(@as(i64, 260), part1(inp));

    // r = 175594;
    // assertEq(r, part2(test1));
    // r = 2578;
    // assertEq(r, part2(test2));
    // r = 3544142;
    // assertEq(r, part2(test3));
    // r = 261214;
    // assertEq(r, part2(test4));
    // r = 6895259;
    // assertEq(r, part2(test5));
    // r = 18;
    // assertEq(r, part2(test6));
    // r = 362;
    // assertEq(r, part2(test7));
    // r = 950;
    // assertEq(r, part2(inp));
}

pub fn main() anyerror!void {
    const ints = readInts(input());
    try print("Part1: {}\n", .{part1(ints)});
    try print("Part2: {}\n", .{part2(ints)});
}

usingnamespace @import("aoc-lib.zig");

fn calc(nums: []const usize, maxTurn: usize, alloc: *Allocator) usize {
    var lastSeen = alloc.alloc(usize, maxTurn) catch unreachable;
    defer alloc.free(lastSeen);
    memset(usize, lastSeen, 0);
    var n: usize = undefined;
    var p: usize = undefined;
    var t: usize = 1;
    while (t <= nums.len) : (t += 1) {
        n = nums[t - 1];
        if (t > 1) {
            lastSeen[p] = t;
        }
        p = n;
    }
    while (t <= maxTurn) : (t += 1) {
        if (lastSeen[p] != 0) {
            n = t - lastSeen[p];
        } else {
            n = 0;
        }
        lastSeen[p] = t;
        p = n;
    }
    return n;
}

fn part1(in: []const usize, alloc: *Allocator) usize {
    return calc(in, 2020, alloc);
}

fn part2(in: []const usize, alloc: *Allocator) usize {
    return calc(in, 30000000, alloc);
}

test "examples" {
    const test1 = try Ints(test1file, usize, talloc);
    defer talloc.free(test1);
    const test2 = try Ints(test2file, usize, talloc);
    defer talloc.free(test2);
    const test3 = try Ints(test3file, usize, talloc);
    defer talloc.free(test3);
    const test4 = try Ints(test4file, usize, talloc);
    defer talloc.free(test4);
    const test5 = try Ints(test5file, usize, talloc);
    defer talloc.free(test5);
    const test6 = try Ints(test6file, usize, talloc);
    defer talloc.free(test6);
    const test7 = try Ints(test7file, usize, talloc);
    defer talloc.free(test7);
    const inp = try Ints(inputfile, usize, talloc);
    defer talloc.free(inp);

    try assertEq(@as(usize, 436), part1(test1, talloc));
    try assertEq(@as(usize, 1), part1(test2, talloc));
    try assertEq(@as(usize, 10), part1(test3, talloc));
    try assertEq(@as(usize, 27), part1(test4, talloc));
    try assertEq(@as(usize, 78), part1(test5, talloc));
    try assertEq(@as(usize, 438), part1(test6, talloc));
    try assertEq(@as(usize, 1836), part1(test7, talloc));
    try assertEq(@as(usize, 260), part1(inp, talloc));

    try assertEq(@as(usize, 175594), part2(test1, talloc));
    try assertEq(@as(usize, 2578), part2(test2, talloc));
    try assertEq(@as(usize, 3544142), part2(test3, talloc));
    try assertEq(@as(usize, 261214), part2(test4, talloc));
    try assertEq(@as(usize, 6895259), part2(test5, talloc));
    try assertEq(@as(usize, 18), part2(test6, talloc));
    try assertEq(@as(usize, 362), part2(test7, talloc));
    try assertEq(@as(usize, 950), part2(inp, talloc));
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const ints = try Ints(inp, usize, halloc);
    defer halloc.free(ints);
    var p1 = part1(ints, halloc);
    var p2 = part2(ints, halloc);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    const test0 = try aoc.Ints(aoc.talloc, i64, aoc.test0file);
    defer aoc.talloc.free(test0);
    const test1 = try aoc.Ints(aoc.talloc, i64, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = try aoc.Ints(aoc.talloc, i64, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = try aoc.Ints(aoc.talloc, i64, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(i64, 8), part1(aoc.talloc, test0));
    try aoc.assertEq(@as(i64, 4), part2(aoc.talloc, test0));

    try aoc.assertEq(@as(i64, 35), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(i64, 8), part2(aoc.talloc, test1));

    try aoc.assertEq(@as(i64, 220), part1(aoc.talloc, test2));
    try aoc.assertEq(@as(i64, 19208), part2(aoc.talloc, test2));

    try aoc.assertEq(@as(i64, 1920), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(i64, 1511207993344), part2(aoc.talloc, inp));
}

fn part1(alloc: std.mem.Allocator, in: []const i64) i64 {
    var nums: []i64 = alloc.dupe(i64, in) catch unreachable;
    defer alloc.free(nums);
    std.sort.sort(i64, nums, {}, aoc.i64LessThan);
    var cj: i64 = 0;
    var c = std.AutoHashMap(i64, i64).init(alloc);
    defer c.deinit();
    for (nums) |j| {
        const d = j - cj;
        c.put(d, (c.get(d) orelse 0) + 1) catch unreachable;
        cj = j;
    }
    if (cj - nums[nums.len - 1] == 1) {
        return (1 + c.get(1).?) * c.get(3).?;
    } else {
        return c.get(1).? * (c.get(3).? + 1);
    }
}

fn count(cj: i64, tj: i64, ni: usize, nums: []i64, state: *std.AutoHashMap(usize, i64)) i64 {
    const k: usize = std.math.absCast(cj) + ni * nums.len;
    if (state.contains(k)) {
        return state.get(k).?;
    }
    if (ni >= nums.len) {
        return 1;
    }
    var c: i64 = 0;
    var i: usize = 0;
    while (ni + i < nums.len and i < 3) : (i += 1) {
        var j = nums[ni + i];
        if ((j - cj) <= 3) {
            c += count(j, tj, ni + i + 1, nums, state);
        }
    }
    state.put(k, c) catch unreachable;
    return c;
}

fn part2(alloc: std.mem.Allocator, in: []const i64) i64 {
    var nums: []i64 = alloc.dupe(i64, in) catch unreachable;
    defer alloc.free(nums);
    std.sort.sort(i64, nums, {}, aoc.i64LessThan);
    var state = std.AutoHashMap(usize, i64).init(alloc);
    defer state.deinit();
    return count(0, in[in.len - 1], 0, nums, &state);
}

fn day10(inp: []const u8, bench: bool) anyerror!void {
    var nums = try aoc.Ints(aoc.halloc, i64, inp);
    defer aoc.halloc.free(nums);
    var p1 = part1(aoc.halloc, nums);
    var p2 = part2(aoc.halloc, nums);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day10);
}

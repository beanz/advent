const std = @import("std");
const math = std.math;
const sort = std.sort;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const test0file = @embedFile("test0.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const test0 = try aoc.readInts(test0file);
    const test1 = try aoc.readInts(test1file);
    const test2 = try aoc.readInts(test2file);
    const inp = try aoc.readInts(input);

    var r: i64 = 8;
    assertEq(r, part1(test0));
    r = 4;
    assertEq(r, part2(test0));

    r = 35;
    assertEq(r, part1(test1));
    r = 8;
    assertEq(r, part2(test1));

    r = 220;
    assertEq(r, part1(test2));
    r = 19208;
    assertEq(r, part2(test2));

    r = 1920;
    assertEq(r, part1(inp));
    r = 1511207993344;
    assertEq(r, part2(inp));
}

fn bs(in: []const i64) []i64 {
    var nums: []i64 = std.mem.dupe(alloc, i64, in) catch unreachable;
    //std.sort.insertionSort(i64, nums[0..], {}, std.sort.asc(i64));
    var i: usize = 0;
    while (i < nums.len) {
        var j: usize = i + 1;
        while (j < nums.len) {
            if (nums[i] > nums[j]) {
                var t = nums[i];
                nums[i] = nums[j];
                nums[j] = t;
            }
            j += 1;
        }
        i += 1;
    }
    return nums;
}

fn part1(in: []const i64) i64 {
    var nums = bs(in);
    var cj: i64 = 0;
    var c = std.AutoHashMap(i64, i64).init(alloc);
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

fn count(cj : i64, tj :i64, ni : usize, nums : []i64, state: *std.AutoHashMap(usize,i64)) i64 {
    const k:usize = math.absCast(cj) + ni*nums.len;
    if (state.contains(k)) {
        return state.get(k).?;
    }
    if (ni >= nums.len) {
        return 1;
    }
    var c :i64 = 0;
    var rem = nums[1..];
    var i :usize = 0;
    while (ni+i < nums.len and i < 3) {
        var j = nums[ni+i];
        if ((j - cj) <= 3) {
            c += count(j, tj, ni+i+1, nums, state);
        }
        i += 1;
    }
    state.put(k, c) catch unreachable;
    return c;
}

fn part2(in: []const i64) i64 {
    var state = std.AutoHashMap(usize,i64).init(alloc);
    return count(0, in[in.len -1], 0, bs(in), &state);
}

// fn part2(in: []const i64) i64 {
//     var nums = alloc.alloc(i64, in.len) catch unreachable;
//     std.mem.copy(i64, nums[0..], in);
//     sort.sort(i64, nums[0..], null, sort.asc(i64));
//     return 0;
// }

pub fn main() anyerror!void {
    var nums = try aoc.readInts(input);
    try out.print("Part1: {}\n", .{part1(nums)});
    try out.print("Part2: {}\n", .{part2(nums)});
}

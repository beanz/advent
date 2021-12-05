usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test0 = readInts(test0file, i64);
    const test1 = readInts(test1file, i64);
    const test2 = readInts(test2file, i64);
    const inp = readInts(inputfile, i64);

    try assertEq(@as(i64, 8), part1(test0));
    try assertEq(@as(i64, 4), part2(test0));

    try assertEq(@as(i64, 35), part1(test1));
    try assertEq(@as(i64, 8), part2(test1));

    try assertEq(@as(i64, 220), part1(test2));
    try assertEq(@as(i64, 19208), part2(test2));

    try assertEq(@as(i64, 1920), part1(inp));
    try assertEq(@as(i64, 1511207993344), part2(inp));
}

fn part1(in: []const i64) i64 {
    var nums: []i64 = dupe(alloc, i64, in) catch unreachable;
    sort.sort(i64, nums, {}, i64LessThan);
    var cj: i64 = 0;
    var c = AutoHashMap(i64, i64).init(alloc);
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

fn count(cj: i64, tj: i64, ni: usize, nums: []i64, state: *AutoHashMap(usize, i64)) i64 {
    const k: usize = absCast(cj) + ni * nums.len;
    if (state.contains(k)) {
        return state.get(k).?;
    }
    if (ni >= nums.len) {
        return 1;
    }
    var c: i64 = 0;
    var rem = nums[1..];
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

fn part2(in: []const i64) i64 {
    var nums: []i64 = dupe(alloc, i64, in) catch unreachable;
    sort.sort(i64, nums, {}, i64LessThan);
    var state = AutoHashMap(usize, i64).init(alloc);
    return count(0, in[in.len - 1], 0, nums, &state);
}

pub fn main() anyerror!void {
    var nums = readInts(input(), i64);
    try print("Part1: {}\n", .{part1(nums)});
    try print("Part2: {}\n", .{part2(nums)});
}

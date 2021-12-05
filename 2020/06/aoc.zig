usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test1 = readChunks(test1file);
    assertEq(@as(usize, 11), part1(test1));
    assertEq(@as(usize, 6), part2(test1));

    const inp = readChunks(inputfile);
    assertEq(@as(usize, 6506), part1(inp));
    assertEq(@as(usize, 3243), part2(inp));
}

fn part1(inp: anytype) usize {
    var c: usize = 0;
    for (inp) |ent| {
        var m = AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var pit = split(ent, "\n");
        while (pit.next()) |ans| {
            for (ans) |ch| {
                minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |ch| {
            gc += 1;
        }
        c += gc;
    }
    return c;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    for (inp) |ent| {
        var m = AutoHashMap(u8, usize).init(alloc);
        defer m.deinit();
        var people: usize = 0;
        var pit = split(ent, "\n");
        while (pit.next()) |ans| {
            people += 1;
            for (ans) |ch| {
                minc(&m, ch);
            }
        }
        var gc: usize = 0;
        var mit = m.iterator();
        while (mit.next()) |ch| {
            if (ch.value_ptr.* == people) {
                gc += 1;
            }
        }
        c += gc;
    }
    return c;
}

pub fn main() anyerror!void {
    var dec = readChunks(input());
    try print("Part1: {}\n", .{part1(dec)});
    try print("Part2: {}\n", .{part2(dec)});
}

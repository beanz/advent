usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test1 = readChunks(test1file, talloc);
    defer talloc.free(test1);
    try assertEq(@as(usize, 11), part1(test1, talloc));
    try assertEq(@as(usize, 6), part2(test1, talloc));

    const inp = readChunks(inputfile, talloc);
    defer talloc.free(inp);
    try assertEq(@as(usize, 6506), part1(inp, talloc));
    try assertEq(@as(usize, 3243), part2(inp, talloc));
}

fn part1(inp: anytype, alloc: *Allocator) usize {
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

fn part2(inp: anytype, alloc: *Allocator) usize {
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

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    var dec = readChunks(inp, halloc);
    defer halloc.free(dec);
    var p1 = part1(dec, halloc);
    var p2 = part2(dec, halloc);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{p1, p2});
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

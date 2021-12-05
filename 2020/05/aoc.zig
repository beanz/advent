usingnamespace @import("aoc-lib.zig");

test "examples" {
    assertEq(@as(usize, 820), part1(readLines(test1file)));
    assertEq(@as(usize, 0), part2(readLines(test1file)));
    assertEq(@as(usize, 947), part1(readLines(inputfile)));
    assertEq(@as(usize, 636), part2(readLines(inputfile)));
}

fn seat(dir: []const u8) usize {
    var s: usize = 0;
    var sm: usize = 1024;
    for (dir) |ch| {
        switch (ch) {
            'F', 'L' => {
                sm /= 2;
            },
            'B', 'R' => {
                sm /= 2;
                s += sm;
            },
            else => {},
        }
    }
    return s;
}

fn part1(inp: anytype) usize {
    var m: usize = 0;
    for (inp) |dir| {
        const s = seat(dir);
        if (s > m) {
            m = s;
        }
    }
    return m;
}

fn part2(inp: anytype) usize {
    var plan = AutoHashMap(usize, bool).init(alloc);
    defer plan.deinit();
    for (inp) |dir| {
        plan.put(seat(dir), true) catch {};
    }
    var it = plan.iterator();
    while (it.next()) |e| {
        if (plan.contains(e.key_ptr.* - 2) and !plan.contains(e.key_ptr.* - 1)) {
            return e.key_ptr.* - 1;
        }
    }
    return 0;
}

pub fn main() anyerror!void {
    var plan = readLines(input());
    try print("Part1: {}\n", .{part1(plan)});
    try print("Part2: {}\n", .{part2(plan)});
}

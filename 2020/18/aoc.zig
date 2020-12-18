usingnamespace @import("aoc-lib.zig");

pub fn Calc(s: []const u8, part2: bool) usize {
    const v = parseUnsigned(usize, s, 10) catch {
        const l = s.len;
        if (s[l - 1] >= '0' and s[l - 1] <= '9') {
            const last = parseUnsigned(usize, s[l - 1 .. l], 10) catch unreachable;
            const prev = Calc(s[0 .. l - 4], part2);
            if (s[l - 3] == '+') {
                return prev + last;
            } else {
                return prev * last;
            }
        }
        if (s[l - 1] == ')') {
            var i: usize = l - 1;
            var lvl: usize = 1;
            while (lvl != 0) {
                if (i == 0) {
                    debug.panic("failed to find matching '(': {}", .{s});
                }
                i -= 1;
                if (s[i] == ')') {
                    lvl += 1;
                } else if (s[i] == '(') {
                    lvl -= 1;
                }
            }
            const bv = Calc(s[i + 1 .. l - 1], false);
            if (i == 0) {
                return bv;
            }
            const prev = Calc(s[0 .. i - 3], part2);
            if (s[i - 2] == '+') {
                return prev + bv;
            } else {
                return prev * bv;
            }
        }
        debug.panic("invalid: {}", .{s});
    };
    return v;
}

pub fn Part1(s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(l, false);
    }
    return t;
}

pub fn Part2(s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(l, true);
    }
    return t;
}

test "Calc" {
    assertEq(@as(usize, 10), Calc("10", false));
    assertEq(@as(usize, 5), Calc("2 + 3", false));
    assertEq(@as(usize, 6), Calc("2 * 3", false));
    assertEq(@as(usize, 9), Calc("1 + 2 * 3", false));
    assertEq(@as(usize, 6), Calc("(2 * 3)", false));
    assertEq(@as(usize, 9), Calc("(1 + 2) * 3", false));
    assertEq(@as(usize, 7), Calc("1 + (2 * 3)", false));
    assertEq(@as(usize, 71), Calc("1 + 2 * 3 + 4 * 5 + 6", false));
    assertEq(@as(usize, 51), Calc("1 + (2 * 3) + (4 * (5 + 6))", false));
    assertEq(@as(usize, 26), Calc("2 * 3 + (4 * 5)", false));
    assertEq(@as(usize, 437), Calc("5 + (8 * 3 + 9 + 3 * 4 * 3)", false));
    assertEq(@as(usize, 12240), Calc("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", false));
    assertEq(@as(usize, 13632), Calc("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", false));
}

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    assertEq(@as(usize, 26457), Part1(test1));
    assertEq(@as(usize, 694173), Part2(test1));
    assertEq(@as(usize, 510009915468), Part1(inp));
    assertEq(@as(usize, 321176691637769), Part2(inp));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    try print("Part1: {}\n", .{Part1(lines)});
    try print("Part2: {}\n", .{Part2(lines)});
}

usingnamespace @import("aoc-lib.zig");

test "examples" {
    try assertEq(@as(usize, 2), part1(test1file));
    try assertEq(@as(usize, 1), part2(test1file));
    try assertEq(@as(usize, 454), part1(inputfile));
    try assertEq(@as(usize, 649), part2(inputfile));
}

fn part1(inp: anytype) usize {
    var lit = split(inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = tokenize(line, "- :");
        const n1 = parseInt(i64, fit.next().?, 10) catch unreachable;
        const n2 = parseInt(i64, fit.next().?, 10) catch unreachable;
        const ch = (fit.next().?)[0];
        const str = fit.next().?;
        var cc: i64 = 0;
        for (str) |tch| {
            if (tch == ch) {
                cc += 1;
            }
        }
        if (cc >= n1 and cc <= n2) {
            c += 1;
        }
    }
    return c;
}

fn part2(inp: anytype) usize {
    var lit = split(inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = tokenize(line, "- :");
        const n1 = parseUnsigned(usize, fit.next().?, 10) catch unreachable;
        const n2 = parseUnsigned(usize, fit.next().?, 10) catch unreachable;
        const ch = (fit.next().?)[0];
        const str = fit.next().?;
        var cc: i64 = 0;
        for (str) |tch| {
            if (tch == ch) {
                cc += 1;
            }
        }
        const first = str[n1 - 1] == ch;
        const second = str[n2 - 1] == ch;
        if ((first or second) and !(first and second)) {
            c += 1;
        }
    }
    return c;
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const in = input();
    var p1 = part1(in);
    var p2 = part2(in);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{p1, p2});
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

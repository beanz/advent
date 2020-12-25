usingnamespace @import("aoc-lib.zig");

fn loopSize(t: u64) u64 {
    var p: u64 = 1;
    var s: u64 = 7;
    var l: u64 = 0;
    while (p != t) {
        p *= s;
        p %= 20201227;
        l += 1;
    }
    return l;
}

test "loop size" {
    assertEq(@as(u64, 8), loopSize(5764801));
    assertEq(@as(u64, 11), loopSize(17807724));
    assertEq(@as(u64, 13467729), loopSize(9033205));
    assertEq(@as(u64, 3020524), loopSize(9281649));
}

fn expMod(ia: u64, ib: u64, m: u64) u64 {
    var a = ia;
    var b = ib;
    var c: u64 = 1;
    while (b > 0) {
        if ((b % 2) == 1) {
            c *= a;
            c %= m;
        }
        a *= a;
        a %= m;
        b /= 2;
    }
    return c;
}

pub fn Part1(s: [][]const u8) !u64 {
    const cardPub = try parseUnsigned(u64, s[0], 10);
    const doorPub = try parseUnsigned(u64, s[1], 10);
    const ls = loopSize(cardPub);
    return expMod(doorPub, ls, 20201227);
}

test "part1" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    const rt = try Part1(test1);
    assertEq(@as(usize, 14897079), rt);
    const r = try Part1(inp);
    assertEq(@as(usize, 9714832), r);
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    const res = try Part1(lines);
    try print("Part1: {}\n", .{res});
}

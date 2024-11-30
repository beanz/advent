const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(u64, parts);
}

fn parts(inp: []const u8) anyerror![2]u64 {
    var i: usize = 0;
    while (inp[i] != '\n') : (i += 1) {}
    const steps = inp[0..i];
    const mod = i;
    _ = mod;
    i += 2;
    var g = try std.BoundedArray(u16, 800).init(0);
    var ml = std.mem.zeroes([26426]u16);
    var mr = std.mem.zeroes([26426]u16);
    while (i < inp.len) : (i += 17) {
        const f = readID(inp, i);
        const l = readID(inp, i + 7);
        const r = readID(inp, i + 12);
        if (inp[i + 2] == 'A' and f != 0) {
            try g.append(f);
        }
        ml[f] = l + 1; // add one so we can check for zeroes
        mr[f] = r + 1; // add one so we can check for zeroes
    }
    const p1 = run(steps, ml, mr, 0);
    var p2 = p1;
    for (0..g.len) |j| {
        const c = run(steps, ml, mr, g.get(j));
        p2 = lcm(p2, c);
    }
    return [2]u64{ p1, p2 };
}

fn run(steps: []const u8, ml: [26426]u16, mr: [26426]u16, start: u16) u64 {
    var c: u64 = 0;
    var p = start;
    while (true) {
        if (steps[c % steps.len] == 'L') {
            p = ml[p];
        } else {
            p = mr[p];
        }
        if (p == 0) {
            return 1;
        }
        p -= 1;
        c += 1;
        if ((p & 0x1f) == 25) {
            return c;
        }
    }
}

fn readID(inp: []const u8, i: usize) u16 {
    return (@as(u16, inp[i] - 'A') << 10) + (@as(u16, inp[i + 1] - 'A') << 5) + @as(u16, inp[i + 2] - 'A');
}

fn lcm(a: u64, b: u64) u64 {
    return (a * b) / gcd(a, b);
}

fn gcd(pa: u64, pb: u64) u64 {
    var a = pa;
    var b = pb;
    if (a > b) {
        const t = a;
        a = b;
        b = t;
    }
    while (a != 0) {
        const na = b % a;
        b = a;
        a = na;
    }
    return b;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

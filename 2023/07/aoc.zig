const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    try aoc.TestCases(u32, parts);
}

const HighCard: u4 = 0;
const OnePair: u4 = 1;
const TwoPair: u4 = 2;
const ThreeOfAKind: u4 = 3;
const FullHouse: u4 = 4;
const FourOfAKind: u4 = 5;
const FiveOfAKind: u4 = 6;

const Hand = struct {
    hand: []const u8,
    s1: u32,
    s2: u32,
    bid: u32,
};

fn parts(inp: []const u8) anyerror![2]u32 {
    var hands = try std.BoundedArray(Hand, 1000).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var h = inp[i .. i + 5];
        var s1: u32 = 0;
        var s2: u32 = 0;
        var c = std.mem.zeroes([256]u4);
        var lc: u8 = 0;
        var mc: u8 = 0;
        for (i..i + 5) |j| {
            if (c[inp[j]] == 0) {
                lc += 1;
            }
            c[inp[j]] += 1;
            if (mc < c[inp[j]]) {
                mc = c[inp[j]];
            }
            const cardScore: u4 = @intCast(switch (inp[j]) {
                'T' => 10,
                'J' => 11,
                'Q' => 12,
                'K' => 13,
                'A' => 14,
                else => inp[j] - '0',
            });
            s1 = (s1 << 4) + cardScore;
            s2 = (s2 << 4);
            if (cardScore != 11) {
                s2 += cardScore;
            }
        }
        i += 6;
        const bid = try aoc.chompUint(u32, inp, &i);
        var h1: u4 = switch (lc) {
            1 => FiveOfAKind,
            2 => switch (mc) {
                4 => FourOfAKind,
                else => FullHouse,
            },
            3 => switch (mc == 3) {
                true => ThreeOfAKind,
                false => TwoPair,
            },
            4 => OnePair,
            5 => HighCard,
            else => unreachable,
        };
        var h2 = switch (c['J']) {
            1 => switch (mc) {
                4 => FiveOfAKind,
                3 => FourOfAKind,
                2 => switch (lc) {
                    4 => ThreeOfAKind,
                    3 => h1 + 2,
                    else => h1 + 1,
                },
                else => h1 + 1,
            },
            2 => switch (lc) {
                2 => FiveOfAKind,
                3 => FourOfAKind,
                else => ThreeOfAKind,
            },
            3 => h1 + 2,
            4 => h1 + 1,
            else => h1,
        };
        s1 += @as(u32, h1) << 20;
        s2 += @as(u32, h2) << 20;
        try hands.append(Hand{
            .hand = h,
            .s1 = s1,
            .s2 = s2,
            .bid = bid,
        });
    }
    var h = hands.slice();
    std.sort.block(Hand, h, {}, cmpByScore1);
    var p1: u32 = 0;
    for (0..hands.len) |j| {
        var k: u32 = @intCast(j);
        p1 += (k + 1) * h[j].bid;
    }
    std.sort.block(Hand, h, {}, cmpByScore2);
    var p2: u32 = 0;
    for (0..hands.len) |j| {
        var k: u32 = @intCast(j);
        p2 += (k + 1) * h[j].bid;
    }
    return [2]u32{ p1, p2 };
}

fn cmpByScore1(context: void, a: Hand, b: Hand) bool {
    _ = context;
    return a.s1 < b.s1;
}

fn cmpByScore2(context: void, a: Hand, b: Hand) bool {
    _ = context;
    return a.s2 < b.s2;
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
        var t = a;
        a = b;
        b = t;
    }
    while (a != 0) {
        var na = b % a;
        b = a;
        a = na;
    }
    return b;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn digit(n: u8) u8 {
    return switch (n) {
        0b1110111 => 0,
        0b0100100 => 1,
        0b1011101 => 2,
        0b1101101 => 3,
        0b0101110 => 4,
        0b1101011 => 5,
        0b1111011 => 6,
        0b0100101 => 7,
        0b1111111 => 8,
        0b1101111 => 9,
        else => unreachable,
    };
}
const Entry = struct {
    output: [4]u8,
    pattern_of_len: [8]u8,
    fn solution(self: Entry) [7]u8 {
        const cf = self.pattern_of_len[2];
        const acf = self.pattern_of_len[3];
        const bcdf = self.pattern_of_len[4];
        const abcdefg = self.pattern_of_len[7];
        const a = acf ^ cf;
        const abfg = self.pattern_of_len[6];
        const cde = abcdefg ^ abfg;
        const c = cde & cf;
        const f = cf ^ c;
        const bg = abfg ^ (f | a);
        const b = bcdf & bg;
        const g = b ^ bg;
        const de = cde ^ c;
        const d = bcdf & de;
        const e = de ^ d;
        return [7]u8{ a, b, c, d, e, f, g };
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var entries: [200]Entry = undefined;
    var el: usize = 0;
    var output_len_2_3_4_7: usize = 0;
    {
        var pattern_of_len: [8]u8 = .{0} ** 8;
        var output: [4]u8 = .{0} ** 4;
        var output_i: usize = 0;
        var state = true;
        var n: u8 = 0;
        var l: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                'a'...'g' => {
                    l += 1;
                    n |= @as(u8, 1) << @intCast(ch - 'a');
                },
                ' ' => {
                    if (l != 0) {
                        if (state) {
                            pattern_of_len[l] ^= n;
                        } else {
                            output[output_i] = n;
                            output_i += 1;
                            if (l == 2 or l == 3 or l == 4 or l == 7) {
                                output_len_2_3_4_7 += 1;
                            }
                        }
                        n = 0;
                        l = 0;
                    }
                },
                '|' => {
                    state = false;
                },
                '\n' => {
                    if (l != 0) {
                        output[output_i] = n;
                        output_i = 0;
                        if (l == 2 or l == 3 or l == 4 or l == 7) {
                            output_len_2_3_4_7 += 1;
                        }
                        n = 0;
                        l = 0;
                    }
                    entries[el] = Entry{
                        .output = output,
                        .pattern_of_len = pattern_of_len,
                    };
                    el += 1;
                    state = true;
                    pattern_of_len = .{0} ** 8;
                    output = .{0} ** 4;
                },
                else => unreachable,
            }
        }
    }
    var total: usize = 0;
    for (entries[0..el]) |ent| {
        const sol = ent.solution();
        // (a, b, c, d, e, f, g)
        var n: usize = 0;
        for (&ent.output) |w| {
            var cvt: u8 = 0;
            if ((w & sol[0]) != 0) {
                cvt |= 1;
            }
            if ((w & sol[1]) != 0) {
                cvt |= 2;
            }
            if ((w & sol[2]) != 0) {
                cvt |= 4;
            }
            if ((w & sol[3]) != 0) {
                cvt |= 8;
            }
            if ((w & sol[4]) != 0) {
                cvt |= 16;
            }
            if ((w & sol[5]) != 0) {
                cvt |= 32;
            }
            if ((w & sol[6]) != 0) {
                cvt |= 64;
            }
            n = n * 10 + @as(usize, @intCast(digit(cvt)));
        }
        total += n;
    }
    return [2]usize{ output_len_2_3_4_7, total };
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

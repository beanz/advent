const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const State = enum {
    scanning,
    mul_m,
    mul_u,
    mul_l,
    mul_open,
    mul_op1,
    mul_comma,
    mul_op2,
    do_d,
    do_o,
    do_open,
    dont_n,
    dont_quote,
    dont_t,
    dont_open,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var state = State.scanning;
    var a: usize = 0;
    var b: usize = 0;
    var do: usize = 1;
    for (inp) |ch| {
        state = switch (state) {
            .scanning => switch (ch) {
                'm' => .mul_m,
                'd' => .do_d,
                else => continue,
            },
            .mul_m => switch (ch) {
                'u' => .mul_u,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_u => switch (ch) {
                'l' => .mul_l,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_l => switch (ch) {
                '(' => .mul_open,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_open => switch (ch) {
                '0'...'9' => {
                    state = .mul_op1;
                    a = @as(usize, ch - '0');
                    continue;
                },
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_op1 => switch (ch) {
                '0'...'9' => {
                    a = a * 10 + @as(usize, ch - '0');
                    continue;
                },
                ',' => .mul_comma,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_comma => switch (ch) {
                '0'...'9' => {
                    b = @as(usize, ch - '0');
                    state = .mul_op2;
                    continue;
                },
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .mul_op2 => switch (ch) {
                '0'...'9' => {
                    b = b * 10 + @as(usize, ch - '0');
                    continue;
                },
                ')' => {
                    p1 += a * b;
                    p2 += do * a * b;
                    state = .scanning;
                    continue;
                },
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .do_d => switch (ch) {
                'o' => .do_o,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .do_o => switch (ch) {
                '(' => .do_open,
                'n' => .dont_n,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .do_open => switch (ch) {
                ')' => {
                    do = 1;
                    state = .scanning;
                    continue;
                },
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .dont_n => switch (ch) {
                '\'' => .dont_quote,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .dont_quote => switch (ch) {
                't' => .dont_t,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .dont_t => switch (ch) {
                '(' => .dont_open,
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
            .dont_open => switch (ch) {
                ')' => {
                    do = 0;
                    state = .scanning;
                    continue;
                },
                'm' => .mul_m,
                'd' => .do_d,
                else => .scanning,
            },
        };
    }
    return [2]usize{ p1, p2 };
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

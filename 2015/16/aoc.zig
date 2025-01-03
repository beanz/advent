const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const tape = @embedFile("tape.txt");

fn parts(inp: []const u8) anyerror![2]usize {
    var constraint: [256]usize = .{9999} ** 256;
    {
        var i: usize = 0;
        while (i < tape.len) : (i += 1) {
            const id = try aoc.chompId(tape, &i, 167);
            i += 2;
            const n = try aoc.chompUint(usize, tape, &i);
            std.debug.assert(constraint[id] == 9999);
            constraint[id] = n;
        }
    }
    var p1: usize = 0;
    {
        var i: usize = 0;
        LOOP: while (i < inp.len) : (i += 1) {
            p1 += 1;
            while (inp[i] != ':') : (i += 1) {}
            i += 2;
            while (true) {
                const id = try aoc.chompId(inp, &i, 167);
                i += 2;
                const n = try aoc.chompUint(usize, inp, &i);
                if (constraint[id] != n) {
                    while (inp[i] != '\n') : (i += 1) {}
                    continue :LOOP;
                }
                if (inp[i] == '\n') {
                    break;
                }
                i += 2;
            }
            break;
        }
    }
    var p2: usize = 0;
    {
        var i: usize = 0;
        LOOP: while (i < inp.len) : (i += 1) {
            p2 += 1;
            while (inp[i] != ':') : (i += 1) {}
            i += 2;
            while (true) {
                const id = try aoc.chompId(inp, &i, 167);
                i += 2;
                const n = try aoc.chompUint(usize, inp, &i);
                const valid = switch (id) {
                    239, 27 => n > constraint[id], // cats or trees
                    15, 144 => n < constraint[id], // pomeranians or goldfish
                    else => n == constraint[id],
                };
                if (!valid) {
                    while (inp[i] != '\n') : (i += 1) {}
                    continue :LOOP;
                }
                if (inp[i] == '\n') {
                    break;
                }
                i += 2;
            }
            break;
        }
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

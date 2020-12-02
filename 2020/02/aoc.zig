const std = @import("std");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const example = @embedFile("test1.txt");
    var r: usize = 2;
    assertEq(r, part1(example));
    r = 1;
    assertEq(r, part2(example));
}

fn part1(inp: anytype) usize {
    var lit = std.mem.split(inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = std.mem.tokenize(line, "- :");
        const n1 = std.fmt.parseInt(i64, fit.next().?, 10) catch unreachable;
        const n2 = std.fmt.parseInt(i64, fit.next().?, 10) catch unreachable;
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
    var lit = std.mem.split(inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = std.mem.tokenize(line, "- :");
        const n1 = std.fmt.parseUnsigned(usize, fit.next().?, 10) catch unreachable;
        const n2 = std.fmt.parseUnsigned(usize, fit.next().?, 10) catch unreachable;
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

pub fn main() anyerror!void {
    //try out.print("{}\n", .{report.items.len});
    try out.print("Part1: {}\n", .{part1(input)});
    try out.print("Part2: {}\n", .{part2(input)});
}

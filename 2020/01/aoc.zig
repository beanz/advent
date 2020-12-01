const std = @import("std");
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "examples" {
    const example = @embedFile("test1.txt");
    var report = try readLinesInt(example);
    defer report.deinit();
    std.debug.assert(part1(report.items) == 514579);
    std.debug.assert(part2(report.items) == 241861950);
}

fn part1(exp: []i64) i64 {
    var i: usize = 0;
    while (i < exp.len) {
        var j: usize = i;
        while (j < exp.len) {
            if (exp[i] + exp[j] == 2020) {
                return exp[i] * exp[j];
            }
            j += 1;
        }
        i += 1;
    }
    return 0;
}

fn part2(exp: []i64) i64 {
    var i: usize = 0;
    while (i < exp.len) {
        var j: usize = i;
        while (j < exp.len) {
            var k: usize = i;
            while (k < exp.len) {
                if (exp[i] + exp[j] + exp[k] == 2020) {
                    return exp[i] * exp[j] * exp[k];
                }
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }
    return 0;
}

fn readLinesInt(inp: anytype) anyerror!std.ArrayListAligned(i64, null) {
    var report = ArrayList(i64).init(alloc);
    var lit = std.mem.split(inp, "\n");
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        const n = try std.fmt.parseInt(i64, line, 10);
        try report.append(n);
    }
    return report;
}

pub fn main() anyerror!void {
    var report = try readLinesInt(input);
    defer report.deinit();
    //try out.print("{}\n", .{report.items.len});
    try out.print("Part1: {}\n", .{part1(report.items)});
    try out.print("Part2: {}\n", .{part2(report.items)});
}

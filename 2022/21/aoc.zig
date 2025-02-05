const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(isize, parts);
}

const Op = enum { Noop, Add, Sub, Mul, Div };
const Node = struct {
    v: isize,
    op: Op,
    left: u32,
    right: u32,
    hasHumn: bool,
};

const ROOT_ID = root: {
    var i: usize = 0;
    break :root aoc.chompWord(usize, aoc.AlphaLowerWord, "root", &i) catch unreachable;
};

const HUMN_ID: usize = humn: {
    var i: usize = 0;
    break :humn aoc.chompWord(usize, aoc.AlphaLowerWord, "humn", &i) catch unreachable;
};

const ROOT = 0;
const HUMN = 1;

fn parts(inp: []const u8) anyerror![2]isize {
    const nodes: []Node = parse: {
        var nodes: [2560]Node = undefined;
        var ids: [531441]?u16 = .{null} ** 531441;
        ids[ROOT_ID] = 0;
        ids[HUMN_ID] = 1;
        var l: u16 = 2;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const id = id: {
                const n = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
                if (ids[n] == null) {
                    ids[n] = l;
                    l += 1;
                }
                break :id ids[n].?;
            };
            i += 2;
            if ('0' <= inp[i] and inp[i] <= '9') {
                const v = try aoc.chompUint(isize, inp, &i);
                nodes[id] = Node{ .v = v, .op = Op.Noop, .left = 0, .right = 0, .hasHumn = id == HUMN };
                continue;
            }
            const left = left: {
                const n = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
                if (ids[n] == null) {
                    ids[n] = l;
                    l += 1;
                }
                break :left ids[n].?;
            };
            i += 1;
            const op = switch (inp[i]) {
                '+' => Op.Add,
                '-' => Op.Sub,
                '*' => Op.Mul,
                '/' => Op.Div,
                else => unreachable,
            };
            i += 2;
            const right = right: {
                const n = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
                if (ids[n] == null) {
                    ids[n] = l;
                    l += 1;
                }
                break :right ids[n].?;
            };
            nodes[id] = Node{ .v = 0, .op = op, .left = left, .right = right, .hasHumn = id == HUMN };
        }
        break :parse nodes[0..l];
    };
    const p1 = part1(nodes, ROOT);
    nodes[ROOT].op = Op.Sub;
    const p2 = part2(nodes, ROOT, 0);
    return [2]isize{ p1, p2 };
}

fn part2(nodes: []Node, id: usize, value: isize) isize {
    const n = nodes[id];
    if (n.op == .Noop) {
        return value;
    }
    const left = nodes[n.left];
    const right = nodes[n.right];
    if (left.hasHumn) {
        return switch (n.op) {
            .Add => part2(nodes, n.left, value - right.v),
            .Sub => part2(nodes, n.left, value + right.v),
            .Mul => part2(nodes, n.left, @divTrunc(value, right.v)),
            .Div => part2(nodes, n.left, value * right.v),
            else => unreachable,
        };
    }
    return switch (n.op) {
        .Add => part2(nodes, n.right, value - left.v),
        .Sub => part2(nodes, n.right, left.v - value),
        .Mul => part2(nodes, n.right, @divTrunc(value, left.v)),
        .Div => part2(nodes, n.right, @divTrunc(left.v, value)),
        else => unreachable,
    };
}

fn part1(nodes: []Node, id: usize) isize {
    const n = nodes[id];
    if (n.op == .Noop) {
        return n.v;
    }
    const left = part1(nodes, n.left);
    const right = part1(nodes, n.right);
    const v = switch (n.op) {
        .Add => left + right,
        .Sub => left - right,
        .Mul => left * right,
        .Div => @divTrunc(left, right),
        else => unreachable,
    };
    const hasHumn = nodes[n.left].hasHumn or nodes[n.right].hasHumn;
    nodes[id].hasHumn = hasHumn;
    if (!hasHumn) {
        nodes[id].v = v;
        nodes[id].op = Op.Noop;
    }
    return v;
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

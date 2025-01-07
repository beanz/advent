const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases([8]u8, parts);
}

const Op = enum {
    Move,
    Rev,
    RotLetter,
    RotLeft,
    RotRight,
    SwapLetter,
    SwapPos,
};

const Inst = struct {
    op: Op,
    a: usize,
    b: usize,
};

fn parts(inp: []const u8) anyerror![2][8]u8 {
    var s = try std.BoundedArray(Inst, 128).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            'm' => { // move
                const a = @as(usize, inp[i + 14] - '0');
                const b = @as(usize, inp[i + 28] - '0');
                try s.append(Inst{ .op = Op.Move, .a = a, .b = b });
                i += 29;
            },
            'r' => { // rotate or reverse
                switch (inp[i + 8]) {
                    'p' => { // reverse pos
                        const a = @as(usize, inp[i + 18] - '0');
                        const b = @as(usize, inp[i + 28] - '0');
                        try s.append(Inst{ .op = Op.Rev, .a = a, .b = b });
                        i += 29;
                    },
                    'a' => { // rotate based
                        const a = @as(usize, inp[i + 35]);
                        try s.append(Inst{ .op = Op.RotLetter, .a = a, .b = 0 });
                        i += 36;
                    },
                    'e' => { // rotate left
                        const a = @as(usize, inp[i + 12] - '0');
                        try s.append(Inst{ .op = Op.RotLeft, .a = a, .b = 0 });
                        i += 18;
                        if (inp[i] == 's') { // steps
                            i += 1;
                        }
                    },
                    'i' => { // rotate right
                        const a = @as(usize, inp[i + 13] - '0');
                        try s.append(Inst{ .op = Op.RotRight, .a = a, .b = 0 });
                        i += 19;
                        if (inp[i] == 's') { // steps
                            i += 1;
                        }
                    },
                    else => unreachable,
                }
            },
            's' => { // swap
                switch (inp[i + 5]) {
                    'l' => { // letter
                        const a = @as(usize, inp[i + 12]);
                        const b = @as(usize, inp[i + 26]);
                        try s.append(Inst{ .op = Op.SwapLetter, .a = a, .b = b });
                        i += 27;
                    },
                    'p' => { // position
                        const a = @as(usize, inp[i + 14] - '0');
                        const b = @as(usize, inp[i + 30] - '0');
                        try s.append(Inst{ .op = Op.SwapPos, .a = a, .b = b });
                        i += 31;
                    },
                    else => unreachable,
                }
            },
            else => unreachable,
        }
    }
    const inst = s.slice();
    var p1: [8]u8 = .{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
    for (inst) |t| {
        switch (t.op) {
            Op.RotLetter => {
                var st: usize = std.mem.indexOfScalar(u8, &p1, @as(u8, @intCast(t.a))).?;
                if (st >= 4) {
                    st += 1;
                }
                st += 1;
                if (st > p1.len) {
                    st -= p1.len;
                }
                std.mem.rotate(u8, &p1, p1.len - st);
            },
            Op.SwapLetter => {
                const ia: usize = std.mem.indexOfScalar(u8, &p1, @as(u8, @intCast(t.a))).?;
                const ib: usize = std.mem.indexOfScalar(u8, &p1, @as(u8, @intCast(t.b))).?;
                aoc.swap(u8, &p1[ia], &p1[ib]);
            },
            Op.SwapPos => {
                aoc.swap(u8, &p1[t.a], &p1[t.b]);
            },
            Op.Rev => {
                std.mem.reverse(u8, p1[t.a .. t.b + 1]);
            },
            Op.RotRight => {
                std.mem.rotate(u8, &p1, p1.len - t.a);
            },
            Op.RotLeft => {
                std.mem.rotate(u8, &p1, t.a);
            },
            Op.Move => {
                if (t.a < t.b) {
                    const tmp = p1[t.a];
                    for (t.a..t.b) |k| {
                        p1[k] = p1[k + 1];
                    }
                    p1[t.b] = tmp;
                } else {
                    const tmp = p1[t.a];
                    var k = t.a;
                    while (k > t.b) : (k -= 1) {
                        p1[k] = p1[k - 1];
                    }
                    p1[t.b] = tmp;
                }
            },
        }
    }

    var p2: [8]u8 = .{ 'f', 'b', 'g', 'd', 'c', 'e', 'a', 'h' };
    std.mem.reverse(Inst, inst);
    for (inst) |t| {
        switch (t.op) {
            Op.RotLetter => {
                var st: usize = std.mem.indexOfScalar(u8, &p2, @as(u8, @intCast(t.a))).?;
                const o: usize = if (st & 1 == 1 or st == 0) 1 else 5;
                st = st / 2 + o;
                std.mem.rotate(u8, &p2, st);
            },
            Op.SwapLetter => {
                const ia: usize = std.mem.indexOfScalar(u8, &p2, @as(u8, @intCast(t.a))).?;
                const ib: usize = std.mem.indexOfScalar(u8, &p2, @as(u8, @intCast(t.b))).?;
                aoc.swap(u8, &p2[ia], &p2[ib]);
            },
            Op.SwapPos => {
                aoc.swap(u8, &p2[t.a], &p2[t.b]);
            },
            Op.Rev => {
                std.mem.reverse(u8, p2[t.a .. t.b + 1]);
            },
            Op.RotRight => {
                std.mem.rotate(u8, &p2, t.a);
            },
            Op.RotLeft => {
                std.mem.rotate(u8, &p2, p2.len - t.a);
            },
            Op.Move => {
                if (t.b < t.a) {
                    const tmp = p2[t.b];
                    for (t.b..t.a) |k| {
                        p2[k] = p2[k + 1];
                    }
                    p2[t.a] = tmp;
                } else {
                    const tmp = p2[t.b];
                    var k = t.b;
                    while (k > t.a) : (k -= 1) {
                        p2[k] = p2[k - 1];
                    }
                    p2[t.a] = tmp;
                }
            },
        }
    }

    return [2][8]u8{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

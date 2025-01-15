const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [11]u8,
    p2: [11]u8,
};

const Turn = enum {
    Ccw,
    Cw,
    Fwd,
};

const Cart = struct {
    dx: i32,
    dy: i32,
    turn: Turn,
};

fn parts(inp: []const u8) anyerror!Res {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const w1 = w + 1;
    const h = inp.len / w1;
    var carts = std.AutoHashMap([2]i32, Cart).init(aoc.halloc);
    defer carts.deinit();
    for (0..h) |y| {
        for (0..w) |x| {
            const dir = switch (inp[x + y * w1]) {
                '^' => [2]i32{ 0, -1 },
                'v' => [2]i32{ 0, 1 },
                '<' => [2]i32{ -1, 0 },
                '>' => [2]i32{ 1, 0 },
                else => continue,
            };
            try carts.put([2]i32{ @intCast(x), @intCast(y) }, Cart{ .dx = dir[0], .dy = dir[1], .turn = Turn.Ccw });
        }
    }

    var p1x: i32 = -1;
    var p1y: i32 = -1;
    var p2x: i32 = 0;
    var p2y: i32 = 0;
    while (true) {
        var s = try std.BoundedArray([2]i32, 150).init(0);
        var it = carts.keyIterator();
        while (it.next()) |k| {
            try s.append(k.*);
        }
        var pos = s.slice();
        std.mem.sort([2]i32, pos[0..], {}, pos_sort);
        for (pos) |k| {
            const cart = carts.fetchRemove(k) orelse continue;
            const nxt = [2]i32{ k[0] + cart.value.dx, k[1] + cart.value.dy };
            if (carts.fetchRemove(nxt)) |_| {
                //aoc.print("crash {},{}\n", .{ nxt[0], nxt[1] });
                if (p1x == -1) {
                    p1x = nxt[0];
                    p1y = nxt[1];
                }
                continue;
            }
            var dx: i32 = cart.value.dx;
            var dy: i32 = cart.value.dy;
            var turn: Turn = cart.value.turn;
            switch (inp[@as(usize, @intCast(nxt[0])) + @as(usize, @intCast(nxt[1])) * w1]) {
                '^',
                'v',
                '|',
                => {},
                '<', '>', '-' => {},
                '+' => {
                    switch (cart.value.turn) {
                        Turn.Ccw => {
                            dx = cart.value.dy;
                            dy = -cart.value.dx;
                            turn = Turn.Fwd;
                        },
                        Turn.Fwd => {
                            dx = cart.value.dx;
                            dy = cart.value.dy;
                            turn = Turn.Cw;
                        },
                        Turn.Cw => {
                            dx = -cart.value.dy;
                            dy = cart.value.dx;
                            turn = Turn.Ccw;
                        },
                    }
                },
                '\\' => {
                    dx = cart.value.dy;
                    dy = cart.value.dx;
                },
                '/' => {
                    dx = -cart.value.dy;
                    dy = -cart.value.dx;
                },
                else => unreachable,
            }
            try carts.put(nxt, Cart{ .dx = dx, .dy = dy, .turn = turn });
        }

        switch (carts.count()) {
            0 => unreachable,
            1 => {
                var kit = carts.keyIterator();
                const last = kit.next().?;
                p2x = last[0];
                p2y = last[1];
                break;
            },
            else => {},
        }
    }

    var res = Res{
        .p1 = .{32} ** 11,
        .p2 = .{32} ** 11,
    };
    {
        const l = std.fmt.formatIntBuf(&res.p1, p1x, 10, std.fmt.Case.lower, .{});
        res.p1[l] = ',';
        _ = std.fmt.formatIntBuf(res.p1[l + 1 ..], p1y, 10, std.fmt.Case.lower, .{});
    }
    {
        const l = std.fmt.formatIntBuf(&res.p2, p2x, 10, std.fmt.Case.lower, .{});
        res.p2[l] = ',';
        _ = std.fmt.formatIntBuf(res.p2[l + 1 ..], p2y, 10, std.fmt.Case.lower, .{});
    }
    return res;
}

fn pos_sort(_: void, a: [2]i32, b: [2]i32) bool {
    return a[0] + (a[1] << 8) < b[0] + (b[1] << 8);
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

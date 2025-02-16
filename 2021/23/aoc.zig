const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Pod = enum(u3) {
    None = 0,
    A = 1,
    B = 2,
    C = 3,
    D = 4,

    inline fn cost(self: *const Pod) usize {
        return switch (self.*) {
            .A => 1,
            .B => 10,
            .C => 100,
            .D => 1000,
            .None => unreachable,
        };
    }

    inline fn doorway(self: *const Pod) usize {
        return @as(usize, @intFromEnum(self.*)) * 2;
    }

    inline fn from(ch: u8) Pod {
        return switch (ch) {
            '.' => .None,
            'A' => .A,
            'B' => .B,
            'C' => .C,
            'D' => .D,
            else => unreachable,
        };
    }

    pub fn format(v: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, w: anytype) !void {
        return w.print("{c}", .{@as(u8, switch (v) {
            .None => '.',
            .A => 'A',
            .B => 'B',
            .C => 'C',
            .D => 'D',
        })});
    }
};

const UP: [27]?usize = initUp: {
    var up: [27]?usize = .{null} ** 27;
    up[11] = 2;
    up[12] = 4;
    up[13] = 6;
    up[14] = 8;
    for (0..4) |i| {
        up[15 + i] = 11 + i;
        up[19 + i] = 15 + i;
        up[23 + i] = 19 + i;
    }
    break :initUp up;
};

const DOWN: [27]?usize = initDown: {
    var down: [27]?usize = .{null} ** 27;
    down[2] = 11;
    down[4] = 12;
    down[6] = 13;
    down[8] = 14;
    for (0..4) |i| {
        down[11 + i] = 15 + i;
        down[15 + i] = 19 + i;
        down[19 + i] = 23 + i;
    }
    break :initDown down;
};

const Board = struct {
    b: [27]Pod,
    cost: usize,

    fn isWin(self: *const Board) bool {
        inline for (0..11) |i| {
            if (self.b[i] != Pod.None) {
                return false;
            }
        }
        inline for (0..4) |i| {
            if (self.b[11 + i * 4] != Pod.A) {
                return false;
            }
            if (self.b[12 + i * 4] != Pod.B) {
                return false;
            }
            if (self.b[13 + i * 4] != Pod.C) {
                return false;
            }
            if (self.b[14 + i * 4] != Pod.D) {
                return false;
            }
        }
        return true;
    }

    pub fn format(v: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, w: anytype) !void {
        return w.print("Cost: {}\n#############\n#{}{}{}{}{}{}{}{}{}{}{}#\n###{}#{}#{}#{}###\n  #{}#{}#{}#{}#  \n  #{}#{}#{}#{}#  \n  #{}#{}#{}#{}#  \n  #########", .{
            v.cost,
            v.b[0],
            v.b[1],
            v.b[2],
            v.b[3],
            v.b[4],
            v.b[5],
            v.b[6],
            v.b[7],
            v.b[8],
            v.b[9],
            v.b[10],

            v.b[11],
            v.b[12],
            v.b[13],
            v.b[14],

            v.b[15],
            v.b[16],
            v.b[17],
            v.b[18],

            v.b[19],
            v.b[20],
            v.b[21],
            v.b[22],

            v.b[23],
            v.b[24],
            v.b[25],
            v.b[26],
        });
    }

    const State = enum { Complete, Incomplete, Invaded };
    fn state(self: *const Board, pos: usize) State {
        const expect, var i: usize = switch (pos) {
            0, 1, 3, 5, 7, 9, 10 => unreachable,
            2 => .{ Pod.A, 11 },
            4 => .{ Pod.B, 12 },
            6 => .{ Pod.C, 13 },
            8 => .{ Pod.D, 14 },
            else => switch ((pos - 11) & 0x3) {
                0 => .{ Pod.A, 11 },
                1 => .{ Pod.B, 12 },
                2 => .{ Pod.C, 13 },
                3 => .{ Pod.D, 14 },
                else => unreachable,
            },
        };
        var res = State.Complete;
        while (i < self.b.len) : (i += 4) {
            if (self.b[i] == Pod.None) {
                res = State.Incomplete;
            } else if (self.b[i] != expect) {
                return State.Invaded;
            }
        }
        return res;
    }

    fn solve(start: *const Board) !usize {
        var seen = std.AutoHashMap(Board, void).init(aoc.halloc);
        defer seen.deinit();
        try seen.ensureTotalCapacity(500000);
        var work = std.PriorityQueue(Board, void, board_cmp).init(aoc.halloc, {});
        defer work.deinit();
        try work.ensureTotalCapacity(180000);
        try work.add(start.*);
        var res: usize = 0;
        while (work.removeOrNull()) |cur| {
            //aoc.print("POPPED: {any}\n", .{cur});
            if ((try seen.getOrPut(cur)).found_existing) {
                continue;
            }
            if (cur.isWin()) {
                //aoc.print("FOUND WIN\n{}\n", .{cur});
                res = cur.cost;
                break;
            }
            nextPos: for (0..cur.b.len) |pos| {
                if (cur.b[pos] == Pod.None) {
                    continue;
                }
                const cost = cur.b[pos].cost();
                if (pos > 10) { // in room
                    if (cur.state(pos) != State.Invaded) {
                        // don't leave completed room
                        continue :nextPos;
                    }
                    var steps: usize = 0;
                    var ni = pos;
                    while (UP[ni]) |j| {
                        //aoc.print("  going up {}\n", .{j});
                        steps += 1;
                        ni = j;
                        if (cur.b[j] != Pod.None) {
                            continue :nextPos;
                        }
                    }
                    for ([_]usize{ 7, 5, 3, 1, 0 }) |j| {
                        //aoc.print("  going right {}\n", .{j});
                        if (j > ni) {
                            continue;
                        }
                        if (cur.b[j] != Pod.None) {
                            break;
                        }
                        var n = Board{
                            .b = cur.b,
                            .cost = cur.cost + (steps + ni - j) * cost,
                        };
                        n.b[j] = cur.b[pos];
                        n.b[pos] = Pod.None;
                        //aoc.print("  adding right {}\n{}\n", .{ j, n });
                        try work.add(n);
                    }
                    for ([_]usize{ 3, 5, 7, 9, 10 }) |j| {
                        //aoc.print("  going left {}\n", .{j});
                        if (j < ni) {
                            continue;
                        }
                        if (cur.b[j] != Pod.None) {
                            break;
                        }
                        var n = Board{
                            .b = cur.b,
                            .cost = cur.cost + (steps + j - ni) * cost,
                        };
                        n.b[j] = cur.b[pos];
                        n.b[pos] = Pod.None;
                        //aoc.print("  adding left {}\n{}\n", .{ j, n });
                        try work.add(n);
                    }
                } else {
                    const door = cur.b[pos].doorway();
                    if (cur.state(door) != State.Incomplete) {
                        continue :nextPos;
                    }
                    var steps: usize = 0;
                    var j = pos;
                    //aoc.print("trying to move to doorway {} from {}\n", .{ door, j });

                    while (j < door) {
                        j += 1;
                        if (cur.b[j] != Pod.None) {
                            continue :nextPos;
                        }
                        steps += 1;
                    }
                    while (j > door) {
                        j -= 1;
                        if (cur.b[j] != Pod.None) {
                            continue :nextPos;
                        }
                        steps += 1;
                    }
                    var ni = DOWN[j].?;
                    j = ni;
                    while (j < cur.b.len) : (j += 4) {
                        if (cur.b[j] == Pod.None) {
                            steps += 1;
                            ni = j;
                        } else if (cur.b[j] != cur.b[pos]) {
                            continue :nextPos;
                        }
                    }
                    var n = Board{
                        .b = cur.b,
                        .cost = cur.cost + steps * cost,
                    };
                    n.b[ni] = cur.b[pos];
                    n.b[pos] = Pod.None;
                    //aoc.print("  adding down {}\n{}\n", .{ ni, n });
                    try work.add(n);
                }
            }
        }
        return res;
    }
};

fn board_cmp(_: void, a: Board, b: Board) std.math.Order {
    return std.math.order(a.cost, b.cost);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1b = p1Init: {
        var b: [27]Pod = .{Pod.None} ** 27;
        inline for (0..2) |i| {
            b[19 + i * 4] = Pod.A;
            b[20 + i * 4] = Pod.B;
            b[21 + i * 4] = Pod.C;
            b[22 + i * 4] = Pod.D;
        }
        break :p1Init Board{ .b = b, .cost = 0 };
    };
    var p2b = p2Init: {
        var b: [27]Pod = .{Pod.None} ** 27;
        b[15] = Pod.D;
        b[16] = Pod.C;
        b[17] = Pod.B;
        b[18] = Pod.A;
        b[19] = Pod.D;
        b[20] = Pod.B;
        b[21] = Pod.A;
        b[22] = Pod.C;
        break :p2Init Board{ .b = b, .cost = 0 };
    };
    for (0..4) |i| {
        {
            const p = Pod.from(inp[31 + i * 2]);
            p1b.b[11 + i] = p;
            p2b.b[11 + i] = p;
        }
        {
            const p = Pod.from(inp[45 + i * 2]);
            p1b.b[15 + i] = p;
            p2b.b[23 + i] = p;
        }
    }
    //aoc.print("{}\n{}\n", .{ p1b, p2b });
    const p1 = try p1b.solve();
    const p2 = try p2b.solve();
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

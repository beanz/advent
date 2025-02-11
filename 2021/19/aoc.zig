const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i16;

const Pos = struct {
    x: Int,
    y: Int,
    z: Int,

    fn add(a: *const Pos, b: *const Pos) Pos {
        return Pos{ .x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z };
    }
    fn manhattan(a: *const Pos, b: *const Pos) u16 {
        return @abs(a.x - b.x) + @abs(a.y - b.y) + @abs(a.z - b.z);
    }
    fn rotate(a: *const Pos, r: u8) Pos {
        return switch (r) {
            0 => Pos{ .x = a.x, .y = a.y, .z = a.z },
            1 => Pos{ .x = a.x, .y = a.z, .z = -a.y },
            2 => Pos{ .x = a.x, .y = -a.y, .z = -a.z },
            3 => Pos{ .x = a.x, .y = -a.z, .z = a.y },
            4 => Pos{ .x = a.y, .y = -a.x, .z = a.z },
            5 => Pos{ .x = a.y, .y = a.z, .z = a.x },
            6 => Pos{ .x = a.y, .y = a.x, .z = -a.z },
            7 => Pos{ .x = a.y, .y = -a.z, .z = -a.x },
            8 => Pos{ .x = -a.x, .y = -a.y, .z = a.z },
            9 => Pos{ .x = -a.x, .y = -a.z, .z = -a.y },
            10 => Pos{ .x = -a.x, .y = a.y, .z = -a.z },
            11 => Pos{ .x = -a.x, .y = a.z, .z = a.y },
            12 => Pos{ .x = -a.y, .y = a.x, .z = a.z },
            13 => Pos{ .x = -a.y, .y = -a.z, .z = a.x },
            14 => Pos{ .x = -a.y, .y = -a.x, .z = -a.z },
            15 => Pos{ .x = -a.y, .y = a.z, .z = -a.x },
            16 => Pos{ .x = a.z, .y = a.y, .z = -a.x },
            17 => Pos{ .x = a.z, .y = a.x, .z = a.y },
            18 => Pos{ .x = a.z, .y = -a.y, .z = a.x },
            19 => Pos{ .x = a.z, .y = -a.x, .z = -a.y },
            20 => Pos{ .x = -a.z, .y = -a.y, .z = -a.x },
            21 => Pos{ .x = -a.z, .y = -a.x, .z = a.y },
            22 => Pos{ .x = -a.z, .y = a.y, .z = a.x },
            23 => Pos{ .x = -a.z, .y = a.x, .z = -a.y },
            else => unreachable,
        };
    }

    pub fn format(self: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("{},{},{}", .{ self.x, self.y, self.z });
    }
};

const Scanner = struct {
    pos: ?Pos,
    b: [28]Pos,
    len: usize,
    d: [406]u16,
    dlen: usize,

    fn chomp(inp: []const u8, i: *usize) !Scanner {
        i.* += 12;
        _ = try aoc.chompUint(u8, inp, i);
        i.* += 5;
        var s = Scanner{ .pos = null, .b = undefined, .len = 0, .d = undefined, .dlen = 0 };
        while (i.* < inp.len and inp[i.*] != '\n') {
            const x = try aoc.chompInt(Int, inp, i);
            i.* += 1;
            const y = try aoc.chompInt(Int, inp, i);
            i.* += 1;
            const z = try aoc.chompInt(Int, inp, i);
            i.* += 1;
            s.b[s.len] = Pos{ .x = x, .y = y, .z = z };
            s.len += 1;
        }
        for (0..s.len) |j| {
            for (j + 1..s.len) |k| {
                s.d[s.dlen] = s.b[j].manhattan(&s.b[k]);
                s.dlen += 1;
            }
        }
        std.mem.sort(u16, s.d[0..s.dlen], {}, std.sort.asc(u16));
        return s;
    }
    pub fn format(self: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        if (self.pos) |p| {
            try writer.print("{},{},{}\n", .{ p.x, p.y, p.z });
        } else {
            try writer.print("?,?,?\n", .{});
        }
        for (self.b[0..self.len]) |b| {
            try writer.print("  {},{},{}\n", .{ b.x, b.y, b.z });
        }
    }
};

const Solver = struct {
    s: [37]Scanner,
    len: usize,

    fn chomp(inp: []const u8) !Solver {
        var s = Solver{ .s = undefined, .len = 0 };
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            s.s[s.len] = try Scanner.chomp(inp, &i);
            s.len += 1;
        }
        return s;
    }

    fn solve(self: *Solver) ![2]usize {
        var adj: [37]u64 = .{0} ** 37;
        {
            for (0..self.len) |i| {
                for (i + 1..self.len) |j| {
                    const c = self.countCommonDistances(i, j);
                    if (c >= 60) {
                        adj[i] |= @as(u64, 1) << @intCast(j);
                        adj[j] |= @as(u64, 1) << @intCast(i);
                    }
                }
            }
        }
        self.s[0].pos = Pos{ .x = 0, .y = 0, .z = 0 };
        var back: [33]usize = undefined;
        var todo = aoc.Deque(usize).init(back[0..]);
        try todo.push(0);
        while (todo.pop()) |i| {
            var it = aoc.biterator(usize, adj[i]);
            while (it.next()) |j| {
                if (self.s[j].pos) |_| {
                    continue;
                }
                try self.alignBeacons(i, j);
                try todo.push(j);
            }
        }

        var set = std.AutoHashMap(Pos, void).init(aoc.halloc);
        for (self.s[0..self.len]) |sc| {
            for (sc.b[0..sc.len]) |b| {
                try set.put(b, {});
            }
        }

        var p2: usize = 0;
        {
            for (0..self.len) |i| {
                for (i + 1..self.len) |j| {
                    const md = self.s[i].pos.?.manhattan(&self.s[j].pos.?);
                    if (md > p2) {
                        p2 = md;
                    }
                }
            }
        }

        return [2]usize{ set.count(), p2 };
    }

    fn alignBeacons(self: *Solver, known: usize, unknown: usize) !void {
        var nb = try std.BoundedArray(Pos, 28).init(0);
        for (self.s[known].b[0..self.s[known].len]) |kb| {
            for (self.s[unknown].b[0..self.s[unknown].len]) |ub| {
                for (0..24) |r| {
                    const rotatedUb = ub.rotate(@intCast(r));
                    const transform = Pos{
                        .x = kb.x - rotatedUb.x,
                        .y = kb.y - rotatedUb.y,
                        .z = kb.z - rotatedUb.z,
                    };
                    try nb.resize(0);

                    var c: usize = 0;
                    for (self.s[unknown].b[0..self.s[unknown].len]) |oub| {
                        if (ub.x == oub.x and ub.y == oub.y and ub.z == oub.z) {
                            continue;
                        }
                        const roub = oub.rotate(@intCast(r));
                        const troub = roub.add(&transform);
                        var found = false;
                        for (self.s[known].b[0..self.s[known].len]) |fb| {
                            if (fb.x == troub.x and fb.y == troub.y and fb.z == troub.z) {
                                found = true;
                                break;
                            }
                        }
                        c += @intFromBool(found);
                        try nb.append(troub);
                    }
                    if (c >= 10) {
                        //aoc.print("  found {} rotation {any} for {}\n", .{ c, transform, unknown });
                        self.s[unknown].pos = transform;
                        const nbs = nb.slice();
                        for (0..nbs.len) |i| {
                            self.s[unknown].b[i].x = nbs[i].x;
                            self.s[unknown].b[i].y = nbs[i].y;
                            self.s[unknown].b[i].z = nbs[i].z;
                        }
                        self.s[unknown].len = nbs.len;
                        return;
                    }
                }
            }
        }
        unreachable; // failed to align
    }

    fn countCommonDistances(self: *const Solver, i: usize, j: usize) usize {
        var ii: usize = 0;
        var jj: usize = 0;
        var c: usize = 0;
        while (ii < self.s[i].dlen and jj < self.s[j].dlen) {
            switch (std.math.order(self.s[i].d[ii], self.s[j].d[jj])) {
                .eq => {
                    c += 1;
                    ii += 1;
                    jj += 1;
                },
                .lt => ii += 1,
                .gt => jj += 1,
            }
        }
        return c;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try Solver.chomp(inp);
    return s.solve();
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

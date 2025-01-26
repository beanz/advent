const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const AA = id('A', 'A');
const ZZ = id('Z', 'Z');

const Donut = struct {
    m: []const u8,
    w: usize,
    h: usize,
    start: usize,
    end: usize,
    portal: [16000]usize,
    inner: [16000]bool,
    id2portal: [676]?usize,

    fn init(m: []const u8) Donut {
        const w = init: {
            const w = std.mem.indexOfScalar(u8, m, '\n').?;
            break :init w + 1;
        };
        const h = @divTrunc(m.len, w);
        var donut = Donut{
            .m = m,
            .w = w,
            .h = h,
            .start = 0,
            .end = 0,
            .portal = .{0} ** 16000,
            .inner = .{false} ** 16000,
            .id2portal = .{null} ** 676,
        };
        for (3..w - 4) |x| {
            const t = x;
            switch (m[t]) {
                'A'...'Z' => |ch| {
                    donut.addOuterPortal(id(ch, m[t + w]), t + w * 2);
                },
                else => {},
            }
            const b = x + (h - 1) * w;
            switch (m[b]) {
                'A'...'Z' => |ch| {
                    donut.addOuterPortal(id(m[b - w], ch), b - w * 2);
                },
                else => {},
            }
        }
        for (3..h - 3) |y| {
            const l = y * w;
            switch (m[l]) {
                'A'...'Z' => |ch| {
                    donut.addOuterPortal(id(ch, m[l + 1]), l + 2);
                },
                else => {},
            }
            const r = y * w + w - 2;
            switch (m[r]) {
                'A'...'Z' => |ch| {
                    donut.addOuterPortal(id(m[r - 1], ch), r - 2);
                },
                else => {},
            }
        }
        var p = 2 + 2 * w;
        while (m[p] != ' ') : (p += 1 + w) {}
        while (true) {
            switch (m[p]) {
                'A'...'Z' => |ch| {
                    donut.addInnerPortal(id(ch, m[p + w]), p - w);
                },
                '#' => break,
                else => {},
            }
            p += 1;
        }
        p += w - 1;
        while (true) {
            switch (m[p]) {
                'A'...'Z' => |ch| {
                    donut.addInnerPortal(id(m[p - 1], ch), p + 1);
                },
                '#' => break,
                else => {},
            }
            p += w;
        }
        p -= w + 1;
        while (true) {
            switch (m[p]) {
                'A'...'Z' => |ch| {
                    donut.addInnerPortal(id(m[p - w], ch), p + w);
                },
                '#' => break,
                else => {},
            }
            p -= 1;
        }
        p -= w - 1;
        while (true) {
            switch (m[p]) {
                'A'...'Z' => |ch| {
                    donut.addInnerPortal(id(ch, m[p + 1]), p - 1);
                },
                '#' => break,
                else => {},
            }
            p -= w;
        }
        donut.start = donut.id2portal[AA].?;
        donut.end = donut.id2portal[ZZ].?;
        return donut;
    }
    fn addOuterPortal(self: *Donut, p: usize, i: usize) void {
        self.id2portal[p] = i;
    }
    fn addInnerPortal(self: *Donut, p: usize, i: usize) void {
        const o = self.id2portal[p] orelse unreachable;
        //self.id2portal[p] = null;
        self.portal[i] = o;
        self.inner[i] = true;
        self.portal[o] = i;
    }
    fn find(self: Donut, part2: bool) anyerror!usize {
        var back: [8192]Rec = undefined;
        var work = aoc.Deque(Rec).init(back[0..]);
        try work.push(Rec{ .pos = self.start, .steps = 0, .z = 0 });
        var visited: [2097152]bool = .{false} ** 2097152;
        while (work.pop()) |cur| {
            if (cur.pos == self.end and cur.z == 0) {
                return cur.steps;
            }
            const vk = cur.vkey();
            if (visited[vk]) {
                continue;
            }
            visited[vk] = true;
            const portal = self.portal[cur.pos];
            if (portal != 0) {
                if (!part2 or cur.z > 0 or self.inner[cur.pos]) {
                    const z = if (part2) (if (self.inner[cur.pos]) cur.z + 1 else cur.z - 1) else cur.z;
                    try work.push(Rec{
                        .pos = portal,
                        .z = z,
                        .steps = cur.steps + 1,
                    });
                }
            }
            for (&[4]usize{ cur.pos - self.w, cur.pos + 1, cur.pos + self.w, cur.pos - 1 }) |np| {
                if (self.m[np] != '.') {
                    continue;
                }
                try work.push(Rec{
                    .pos = np,
                    .z = cur.z,
                    .steps = cur.steps + 1,
                });
            }
        }
        return 0;
    }
    const Rec = struct {
        pos: usize,
        steps: u32,
        z: u8,
        pub fn vkey(self: Rec) usize {
            return (self.pos << 7) + @as(usize, @intCast(self.z));
        }
    };
};

inline fn id(a: u8, b: u8) usize {
    return @as(usize, @intCast(a - 'A')) * 26 + @as(usize, @intCast(b - 'A'));
}

inline fn idStr(p: usize) [2]u8 {
    return [2]u8{ @as(u8, @intCast(@divTrunc(p, 26))) + 'A', @as(u8, @intCast(@rem(p, 26))) + 'A' };
}

fn parts(inp: []const u8) anyerror![2]usize {
    const m = Donut.init(inp);
    const p1 = try m.find(false);
    const p2 = try m.find(true);
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

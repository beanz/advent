const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Dir = enum(u2) {
    Right = 0,
    Down = 1,
    Left = 2,
    Up = 3,
    fn inc(self: Dir) [2]i16 {
        return switch (self) {
            .Right => [2]i16{ 1, 0 },
            .Down => [2]i16{ 0, 1 },
            .Left => [2]i16{ -1, 0 },
            .Up => [2]i16{ 0, -1 },
        };
    }
};

const Pos = struct {
    x: i16,
    y: i16,
    dir: Dir,
    fn password(self: Pos) usize {
        return 1000 * @as(usize, @intCast(self.y + 1)) + 4 * @as(usize, @intCast(self.x + 1)) + @as(usize, @intCast(@intFromEnum(self.dir)));
    }
};

const Face = struct {
    x: i16,
    y: i16,
    face: usize,
};

const Next = struct {
    face: usize,
    dir: Dir,
};

const Sq = enum {
    Wrap,
    Empty,
    Block,
};

const Board = struct {
    m: [][]const u8,
    start: Pos,
    cur: Pos,
    walk: []const u8,
    w: usize,
    h: usize,
    iw: i16,
    ih: i16,
    dim: i16,
    faces: [6][2]i16,
    next: [6][4]Next,

    fn get(self: *Board, x: i16, y: i16) Sq {
        const xu: usize = @intCast(x);
        const yu: usize = @intCast(y);
        if (xu > self.w or yu > self.h) {
            unreachable;
        }
        if (xu >= self.m[yu].len) {
            return Sq.Wrap;
        }
        return switch (self.m[yu][xu]) {
            ' ' => Sq.Wrap,
            '.' => Sq.Empty,
            else => Sq.Block,
        };
    }
    fn part(self: *Board, part2: bool) usize {
        var walk_i: usize = 0;
        self.cur = self.start;
        while (walk_i < self.walk.len) : (walk_i += 1) {
            switch (self.walk[walk_i]) {
                'L' => {
                    self.cur.dir = @enumFromInt(@intFromEnum(self.cur.dir) -% 1);
                },
                'R' => {
                    self.cur.dir = @enumFromInt(@intFromEnum(self.cur.dir) +% 1);
                },
                else => |ch| {
                    var n: usize = @intCast(ch & 0xf);
                    if (walk_i + 1 < self.walk.len and ('0' <= self.walk[walk_i + 1] and self.walk[walk_i + 1] <= '9')) {
                        walk_i += 1;
                        n = n * 10 + @as(usize, @intCast(self.walk[walk_i] & 0xf));
                    }
                    if (part2) {
                        for (0..n) |_| {
                            const blocked = self.mov2();
                            if (blocked) {
                                break;
                            }
                        }
                    } else {
                        for (0..n) |_| {
                            const blocked = self.mov();
                            if (blocked) {
                                break;
                            }
                        }
                    }
                },
            }
        }
        return self.cur.password();
    }
    fn mov(self: *Board) bool {
        const i = self.cur.dir.inc();
        var nx = self.cur.x;
        var ny = self.cur.y;
        nx = @rem(nx + self.iw + i[0], self.iw);
        ny = @rem(ny + self.ih + i[1], self.ih);
        var sq = self.get(nx, ny);
        while (sq == Sq.Wrap) {
            nx = @rem(nx + self.iw + i[0], self.iw);
            ny = @rem(ny + self.ih + i[1], self.ih);
            sq = self.get(nx, ny);
        }
        if (sq != Sq.Empty) {
            return true;
        }
        self.cur.x = nx;
        self.cur.y = ny;
        return false;
    }
    fn mov2(self: *Board) bool {
        const f = self.face(self.cur.x, self.cur.y);
        var nface = f.face;
        const i = self.cur.dir.inc();
        var nfx = f.x + i[0];
        var nfy = f.y + i[1];
        var ndir = self.cur.dir;
        if (nfy < 0) {
            const nxt = self.next[f.face][@intFromEnum(Dir.Up)];
            ndir = nxt.dir;
            nface = nxt.face;
            self.wrap(&nfx, &nfy, self.cur.dir, ndir);
        }
        if (nfy == self.dim) {
            const nxt = self.next[f.face][@intFromEnum(Dir.Down)];
            ndir = nxt.dir;
            nface = nxt.face;
            self.wrap(&nfx, &nfy, self.cur.dir, ndir);
        }
        if (nfx < 0) {
            const nxt = self.next[f.face][@intFromEnum(Dir.Left)];
            ndir = nxt.dir;
            nface = nxt.face;
            self.wrap(&nfx, &nfy, self.cur.dir, ndir);
        }
        if (nfx == self.dim) {
            const nxt = self.next[f.face][@intFromEnum(Dir.Right)];
            ndir = nxt.dir;
            nface = nxt.face;
            self.wrap(&nfx, &nfy, self.cur.dir, ndir);
        }
        const n = self.flat(nfx, nfy, nface);
        const sq = self.get(n[0], n[1]);
        if (sq != Sq.Empty) {
            return false;
        }
        self.cur.x = n[0];
        self.cur.y = n[1];
        self.cur.dir = ndir;
        return false;
    }
    fn wrap(self: *Board, x: *i16, y: *i16, oldDir: Dir, newDir: Dir) void {
        if (oldDir == newDir) {
            switch (oldDir) {
                .Up => {
                    y.* = self.dim - 1;
                    return;
                },
                .Down => {
                    y.* = 0;
                    return;
                },
                .Left => {
                    x.* = self.dim - 1;
                    return;
                },
                .Right => {
                    x.* = 0;
                    return;
                },
            }
        }
        if (oldDir == Dir.Up and newDir == Dir.Right) {
            y.* = x.*;
            x.* = 0;
            return;
        }
        if (oldDir == Dir.Down and newDir == Dir.Up) {
            x.* = self.dim - 1 - x.*;
            y.* = self.dim - 1;
            return;
        }
        if (oldDir == Dir.Right and newDir == Dir.Down) {
            x.* = self.dim - 1 - y.*;
            y.* = 0;
            return;
        }
        if (oldDir == Dir.Down and newDir == Dir.Left) {
            y.* = x.*;
            x.* = self.dim - 1;
            return;
        }
        if (oldDir == Dir.Left and newDir == Dir.Down) {
            x.* = y.*;
            y.* = 0;
            return;
        }
        if (oldDir == Dir.Left and newDir == Dir.Right) {
            x.* = 0;
            y.* = self.dim - 1 - y.*;
            return;
        }
        if (oldDir == Dir.Right and newDir == Dir.Left) {
            x.* = self.dim - 1;
            y.* = self.dim - 1 - y.*;
            return;
        }
        if (oldDir == Dir.Right and newDir == Dir.Up) {
            x.* = y.*;
            y.* = self.dim - 1;
            return;
        }
        unreachable;
    }
    fn flat(self: *Board, x: i16, y: i16, f: usize) [2]i16 {
        const fxy = self.faces[f];
        const cx = fxy[0];
        const cy = fxy[1];
        return [2]i16{ cx * self.dim + x, cy * self.dim + y };
    }
    fn face(self: *Board, x: i16, y: i16) Face {
        const cx = @divTrunc(x, self.dim);
        const cy = @divTrunc(y, self.dim);
        const fx = @rem(x, self.dim);
        const fy = @rem(y, self.dim);
        return Face{ .x = fx, .y = fy, .face = self.faceFor(cx, cy) };
    }
    fn faceFor(self: *Board, cx: i16, cy: i16) usize {
        for (self.faces, 0..) |f, i| {
            if (f[0] == cx and f[1] == cy) {
                return i;
            }
        }
        unreachable;
    }
};

const TEST_DIM: i16 = 4;
const TEST_FACES = [6][2]i16{ .{ 2, 0 }, .{ 0, 1 }, .{ 1, 1 }, .{ 2, 1 }, .{ 2, 2 }, .{ 3, 2 } };
const TEST_NEXT = [6][4]Next{
    .{
        Next{
            .face = 5,
            .dir = Dir.Left,
        },
        Next{
            .face = 3,
            .dir = Dir.Down,
        },
        Next{
            .face = 2,
            .dir = Dir.Down,
        },
        Next{
            .face = 1,
            .dir = Dir.Down,
        },
    },
    .{
        Next{
            .face = 2,
            .dir = Dir.Right,
        },
        Next{
            .face = 4,
            .dir = Dir.Up,
        },
        Next{
            .face = 5,
            .dir = Dir.Up,
        },
        Next{
            .face = 0,
            .dir = Dir.Down,
        },
    },
    .{
        Next{
            .face = 3,
            .dir = Dir.Right,
        },
        Next{
            .face = 4,
            .dir = Dir.Right,
        },
        Next{
            .face = 1,
            .dir = Dir.Left,
        },
        Next{
            .face = 0,
            .dir = Dir.Right,
        },
    },
    .{
        Next{
            .face = 5,
            .dir = Dir.Down,
        },
        Next{
            .face = 4,
            .dir = Dir.Down,
        },
        Next{
            .face = 2,
            .dir = Dir.Left,
        },
        Next{
            .face = 0,
            .dir = Dir.Up,
        },
    },
    .{
        Next{
            .face = 5,
            .dir = Dir.Right,
        },
        Next{
            .face = 1,
            .dir = Dir.Up,
        },
        Next{
            .face = 2,
            .dir = Dir.Up,
        },
        Next{
            .face = 3,
            .dir = Dir.Up,
        },
    },
    .{
        Next{
            .face = 0,
            .dir = Dir.Left,
        },
        Next{
            .face = 1,
            .dir = Dir.Right,
        },
        Next{
            .face = 4,
            .dir = Dir.Left,
        },
        Next{
            .face = 3,
            .dir = Dir.Left,
        },
    },
};

const REAL_DIM: i16 = 50;
const REAL_FACES = [6][2]i16{ .{ 1, 0 }, .{ 2, 0 }, .{ 1, 1 }, .{ 0, 2 }, .{ 1, 2 }, .{ 0, 3 } };
const REAL_NEXT = [6][4]Next{
    .{
        Next{
            .face = 1,
            .dir = Dir.Right,
        },
        Next{
            .face = 2,
            .dir = Dir.Down,
        },
        Next{
            .face = 3,
            .dir = Dir.Right,
        },
        Next{
            .face = 5,
            .dir = Dir.Right,
        },
    },
    .{
        Next{
            .face = 4,
            .dir = Dir.Left,
        },
        Next{
            .face = 2,
            .dir = Dir.Left,
        },
        Next{
            .face = 0,
            .dir = Dir.Left,
        },
        Next{
            .face = 5,
            .dir = Dir.Up,
        },
    },
    .{
        Next{
            .face = 1,
            .dir = Dir.Up,
        },
        Next{
            .face = 4,
            .dir = Dir.Down,
        },
        Next{
            .face = 3,
            .dir = Dir.Down,
        },
        Next{
            .face = 0,
            .dir = Dir.Up,
        },
    },
    .{
        Next{
            .face = 4,
            .dir = Dir.Right,
        },
        Next{
            .face = 5,
            .dir = Dir.Down,
        },
        Next{
            .face = 0,
            .dir = Dir.Right,
        },
        Next{
            .face = 2,
            .dir = Dir.Right,
        },
    },
    .{
        Next{
            .face = 1,
            .dir = Dir.Left,
        },
        Next{
            .face = 5,
            .dir = Dir.Left,
        },
        Next{
            .face = 3,
            .dir = Dir.Left,
        },
        Next{
            .face = 2,
            .dir = Dir.Up,
        },
    },
    .{
        Next{
            .face = 4,
            .dir = Dir.Up,
        },
        Next{
            .face = 1,
            .dir = Dir.Down,
        },
        Next{
            .face = 0,
            .dir = Dir.Down,
        },
        Next{
            .face = 3,
            .dir = Dir.Up,
        },
    },
};

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m: [200][]const u8 = undefined;
    var w: usize = 0;
    var h: usize = 0;
    var i: usize = 0;
    while (i < inp.len and inp[i] != '\n') : (i += 1) {
        const j = i;
        while (inp[i] != '\n') : (i += 1) {}
        const l = inp[j..i];
        m[h] = l;
        if (l.len > w) {
            w = l.len;
        }
        h += 1;
    }
    var sx: usize = 0;
    while (m[0][sx] == ' ') : (sx += 1) {}
    var board = Board{
        .m = m[0..h],
        .start = Pos{ .x = @intCast(sx), .y = 0, .dir = Dir.Right },
        .cur = undefined,
        .walk = inp[i + 1 .. inp.len - 1],
        .w = w,
        .h = h,
        .iw = @as(i16, @intCast(w)),
        .ih = @as(i16, @intCast(h)),
        .dim = if (h == 12) TEST_DIM else REAL_DIM,
        .faces = if (h == 12) TEST_FACES else REAL_FACES,
        .next = if (h == 12) TEST_NEXT else REAL_NEXT,
    };
    const p1 = board.part(false);
    const p2 = board.part(true);
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

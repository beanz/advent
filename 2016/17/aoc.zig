const std = @import("std");
const aoc = @import("aoc-lib.zig");
const Md5 = std.crypto.hash.Md5;

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const WORK_SIZE = 256;
const PATH_LEN = 640;

const Search = struct {
    p: [PATH_LEN]u8,
    i: usize,
    x: usize,
    y: usize,
};

const Res = struct {
    p1: [32]u8,
    p2: usize,
};

fn parts(inp: []const u8) anyerror!Res {
    const code = inp[0 .. inp.len - 1];
    var b: [PATH_LEN + 8]u8 = .{0} ** (PATH_LEN + 8);
    std.mem.copyForwards(u8, &b, code);
    var h: [Md5.digest_length]u8 = .{0} ** Md5.digest_length;
    var back: [WORK_SIZE]Search = .{undefined} ** WORK_SIZE;
    var todo: aoc.Deque(Search) = aoc.Deque(Search).init(&back);
    try todo.push(Search{ .p = .{32} ** PATH_LEN, .i = 0, .x = 0, .y = 0 });
    var res = Res{ .p1 = undefined, .p2 = 0 };
    var min: usize = 32;
    while (todo.shift()) |cur| {
        if (cur.x == 3 and cur.y == 3) {
            if (min > cur.i) {
                std.mem.copyForwards(u8, &res.p1, cur.p[0..cur.i]);
                min = cur.i;
            }
            if (res.p2 < cur.i) {
                res.p2 = cur.i;
            }
            continue;
        }
        const d = doors(cur.p[0..cur.i], inp.len - 1, b[0..], &h);
        if (cur.y > 0 and d[0]) {
            var n = Search{ .p = .{32} ** PATH_LEN, .i = cur.i + 1, .x = cur.x, .y = cur.y - 1 };
            std.mem.copyForwards(u8, &n.p, cur.p[0..cur.i]);
            n.p[cur.i] = 'U';
            try todo.push(n);
        }
        if (cur.y < 3 and d[1]) {
            var n = Search{ .p = .{32} ** PATH_LEN, .i = cur.i + 1, .x = cur.x, .y = cur.y + 1 };
            std.mem.copyForwards(u8, &n.p, cur.p[0..cur.i]);
            n.p[cur.i] = 'D';
            try todo.push(n);
        }
        if (cur.x > 0 and d[2]) {
            var n = Search{ .p = .{32} ** PATH_LEN, .i = cur.i + 1, .x = cur.x - 1, .y = cur.y };
            std.mem.copyForwards(u8, &n.p, cur.p[0..cur.i]);
            n.p[cur.i] = 'L';
            try todo.push(n);
        }
        if (cur.x < 3 and d[3]) {
            var n = Search{ .p = .{32} ** PATH_LEN, .i = cur.i + 1, .x = cur.x + 1, .y = cur.y };
            std.mem.copyForwards(u8, &n.p, cur.p[0..cur.i]);
            n.p[cur.i] = 'R';
            try todo.push(n);
        }
    }
    for (min..32) |j| {
        res.p1[j] = 32;
    }
    return res;
}

fn doors(path: []const u8, l: usize, b: []u8, h: *[Md5.digest_length]u8) [4]bool {
    std.mem.copyForwards(u8, b[l..], path);
    Md5.hash(b[0 .. l + path.len], h, .{});
    return [4]bool{
        h[0] & 0xf0 > 0xa0,
        h[0] & 0x0f > 0x0a,
        h[1] & 0xf0 > 0xa0,
        h[1] & 0x0f > 0x0a,
    };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

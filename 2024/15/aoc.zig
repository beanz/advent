const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var m1: [3000]u8 = .{0} ** 3000;
    var m2: [6000]u8 = .{0} ** 6000;
    var wi: ?usize = null;
    var si: usize = 0;
    var m2i: usize = 0;
    var i: usize = 0;
    while (i < inp.len and !(inp[i] == '\n' and inp[i + 1] == '\n')) : (i += 1) {
        switch (inp[i]) {
            '\n' => {
                if (wi == null) {
                    wi = i;
                }
                m2[m2i] = '\n';
                m2i += 1;
            },
            '@' => {
                si = i;
                m2[m2i] = '.';
                m2i += 1;
                m2[m2i] = '.';
                m2i += 1;
            },
            'O' => {
                m2[m2i] = '[';
                m2i += 1;
                m2[m2i] = ']';
                m2i += 1;
            },
            '#' => {
                m2[m2i] = '#';
                m2i += 1;
                m2[m2i] = '#';
                m2i += 1;
            },
            else => {
                m2[m2i] = '.';
                m2i += 1;
                m2[m2i] = '.';
                m2i += 1;
            },
        }
    }
    for (0..i) |j| {
        m1[j] = inp[j];
    }
    //@memcpy(&m1[0..i], inp[0..i]);
    const moves = inp[i + 2 ..];
    const w = wi.? + 1;
    const sx = si % w;
    const sy = si / w;
    const p1 = try robot(m1[0..i], w, sx, sy, inp[i + 2 ..], false);
    const p2 = try robot(m2[0..m2i], w * 2 - 1, sx * 2, sy, moves, true);
    return [2]usize{ p1, p2 };
}

const Box = struct {
    x: usize,
    y: usize,
    ch: u8,
};

const Pos = struct {
    x: usize,
    y: usize,
};

fn robot(map: []u8, w: usize, sx: usize, sy: usize, moves: []const u8, part2: bool) anyerror!usize {
    const h = (map.len + 1) / w;
    var rx = sx;
    var ry = sy;
    map[rx + ry * w] = '.';
    var boxes = try std.BoundedArray(Box, 1024).init(0);
    var check = try std.BoundedArray(Pos, 256).init(0);
    var ncheck = try std.BoundedArray(Pos, 256).init(0);
    for (moves) |m| {
        if (m == '\n') {
            continue;
        }
        var nx = rx;
        var ny = ry;
        switch (m) {
            '^' => ny -= 1,
            '>' => nx += 1,
            'v' => ny += 1,
            else => nx -= 1,
        }
        const ch = map[nx + ny * w];
        if (ch == '#') {
            continue;
        }
        if (ch == '.') {
            rx = nx;
            ry = ny;
            continue;
        }
        var can_move = true;
        if (part2 and (m == 'v' or m == '^')) {
            try check.append(Pos{ .x = rx, .y = ry });
            try ncheck.resize(0);
            while (!(check.len == 0)) {
                for (check.slice()) |c| {
                    const cx = c.x;
                    const cy = if (m == '^') c.y - 1 else c.y + 1;
                    const cch = map[cx + cy * w];
                    if (cch == '#') {
                        can_move = false;
                        break;
                    }
                    if (cch == '[') {
                        try ncheck.append(Pos{ .x = cx, .y = cy });
                        try boxes.append(Box{ .x = cx, .y = cy, .ch = cch });
                        try ncheck.append(Pos{ .x = cx + 1, .y = cy });
                        try boxes.append(Box{ .x = cx + 1, .y = cy, .ch = ']' });
                    } else if (cch == ']') {
                        try ncheck.append(Pos{ .x = cx, .y = cy });
                        try boxes.append(Box{ .x = cx, .y = cy, .ch = cch });
                        try ncheck.append(Pos{ .x = cx - 1, .y = cy });
                        try boxes.append(Box{ .x = cx - 1, .y = cy, .ch = '[' });
                    }
                }
                try check.resize(0);
                const tc = check;
                check = ncheck;
                ncheck = tc;
            }
        } else {
            var tx = nx;
            var ty = ny;
            while (true) {
                const tch = map[tx + ty * w];
                if (tch == '#') {
                    can_move = false;
                    break;
                }
                if (tch == '.') {
                    break;
                }
                try boxes.append(Box{ .x = tx, .y = ty, .ch = tch });
                switch (m) {
                    '^' => ty -= 1,
                    '>' => tx += 1,
                    'v' => ty += 1,
                    else => tx -= 1,
                }
            }
        }
        if (!can_move) {
            try boxes.resize(0);
            continue;
        }
        for (boxes.slice()) |b| {
            map[b.x + w * b.y] = '.';
        }
        for (boxes.slice()) |b| {
            var bx = b.x;
            var by = b.y;
            switch (m) {
                '^' => by -= 1,
                '>' => bx += 1,
                'v' => by += 1,
                else => bx -= 1,
            }
            map[bx + w * by] = b.ch;
        }
        try boxes.resize(0);
        rx = nx;
        ry = ny;
    }
    return score(map, w, h);
}

fn score(map: []const u8, w: usize, h: usize) usize {
    var sc: usize = 0;
    for (0..h) |y| {
        for (0..w - 1) |x| {
            if (map[x + y * w] == 'O' or map[x + y * w] == '[') {
                sc += x + y * 100;
            }
        }
    }
    return sc;
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

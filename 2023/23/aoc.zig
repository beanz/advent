const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w: usize = 1 + std.mem.indexOfScalar(u8, inp, '\n').?;
    const h: usize = inp.len / w;
    var jp: [20022]?usize = .{null} ** 20022;
    var js = try std.BoundedArray([2]usize, 64).init(0);
    try js.append([2]usize{ 1, 0 });
    jp[1] = 0;
    try js.append([2]usize{ w - 3, h - 1 });
    jp[w - 3 + (h - 1) * w] = 1;
    //const start = 0;
    //const end = 1;
    var l: usize = 2;
    for (1..h - 1) |y| {
        for (1..w - 2) |x| {
            const i = y * w + x;
            if (inp[i] != '.') {
                continue;
            }
            const c = @as(usize, @intFromBool(inp[i - 1] != '#')) +
                @as(usize, @intFromBool(inp[i + 1] != '#')) +
                @as(usize, @intFromBool(inp[i - w] != '#')) +
                @as(usize, @intFromBool(inp[i + w] != '#'));
            if (c <= 2) {
                continue;
            }
            jp[i] = l;
            try js.append([2]usize{ x, y });
            l += 1;
        }
    }
    const junctions = js.slice();
    var d: [2048]usize = .{std.math.maxInt(usize)} ** 2048;
    {
        const SRec = struct {
            x: usize,
            y: usize,
            px: usize,
            py: usize,
            st: usize,
        };
        var back: [512]SRec = undefined;
        var work = aoc.Deque(SRec).init(back[0..]);
        for (0..l) |j| {
            d[j + j * l] = 0;
            //aoc.print("{},{} {}:\n", .{ junctions[j][0], junctions[j][1], j });
            const p = junctions[j];
            try work.push(SRec{ .x = p[0], .y = p[1], .px = 0, .py = 0, .st = 0 });
            while (work.pop()) |cur| {
                //aoc.print("  {any}\n", .{cur});
                const i = cur.x + cur.y * w;
                if (jp[i]) |k| {
                    if (cur.st != 0) {
                        d[j + k * l] = cur.st;
                        continue;
                    }
                }
                if (!(j == 0 and cur.px == 0 and cur.py == 0) and inp[i - w] != '#' and inp[i - w] != 'v' and cur.py != cur.y - 1) {
                    try work.push(SRec{ .x = cur.x, .y = cur.y - 1, .px = cur.x, .py = cur.y, .st = cur.st + 1 });
                }
                if (j != 1 and inp[i + w] != '#' and inp[i + w] != '^' and cur.py != cur.y + 1) {
                    try work.push(SRec{ .x = cur.x, .y = cur.y + 1, .px = cur.x, .py = cur.y, .st = cur.st + 1 });
                }
                if (inp[i - 1] != '#' and inp[i - 1] != '>' and cur.px != cur.x - 1) {
                    try work.push(SRec{ .x = cur.x - 1, .y = cur.y, .px = cur.x, .py = cur.y, .st = cur.st + 1 });
                }
                if (inp[i + 1] != '#' and inp[i + 1] != '<' and cur.px != cur.x + 1) {
                    try work.push(SRec{ .x = cur.x + 1, .y = cur.y, .px = cur.x, .py = cur.y, .st = cur.st + 1 });
                }
            }
        }
        // for (0..l) |k| {
        //     for (0..l) |i| {
        //         for (0..l) |j| {
        //             const st = d[i + k * l] +| d[k + j * l];
        //             if (d[i + j * l] > st) {
        //                 d[i + j * l] = st;
        //             }
        //         }
        //     }
        // }
    }
    var p1: usize = 0;
    var back: [64]Rec = undefined;
    {
        var work = aoc.Deque(Rec).init(back[0..]);
        try work.push(Rec{ .p = 0, .seen = 0, .st = 0 });
        while (work.shift()) |cur| {
            if (cur.p == 1) {
                if (p1 < cur.st) {
                    p1 = cur.st;
                }
                continue;
            }
            const bit = @as(u64, 1) << @as(u6, @intCast(cur.p));
            if (cur.seen & bit != 0) {
                continue;
            }
            const nseen = cur.seen | bit;
            for (0..l) |j| {
                switch (d[cur.p + j * l]) {
                    0 => {
                        continue;
                    },
                    std.math.maxInt(usize) => {
                        continue;
                    },
                    else => |st| {
                        try work.push(Rec{ .p = j, .seen = nseen, .st = cur.st + st });
                    },
                }
            }
        }
    }
    var p2: usize = 0;
    {
        var work = aoc.Deque(Rec).init(back[0..]);
        try work.push(Rec{ .p = 0, .seen = 0b1, .st = 0 });
        var seen = std.AutoHashMap(u64, usize).init(aoc.halloc);
        try seen.ensureTotalCapacity(16777216);
        while (work.shift()) |cur| {
            if (cur.p == 1) {
                if (p2 < cur.st) {
                    p2 = cur.st;
                }
                continue;
            }
            const k = cur.key();
            if (seen.get(k)) |st| {
                if (st > cur.st) {
                    continue;
                }
            }
            try seen.put(k, cur.st);
            for (0..l) |j| {
                switch (d[cur.p + j * l]) {
                    0 => {},
                    std.math.maxInt(usize) => {},
                    else => |st| {
                        const bit = @as(u64, 1) << @as(u6, @intCast(j));
                        if (cur.seen & bit == 0) {
                            const nseen = cur.seen | bit;
                            try work.push(Rec{ .p = j, .seen = nseen, .st = cur.st + st });
                        }
                    },
                }
                switch (d[cur.p * l + j]) {
                    0 => {},
                    std.math.maxInt(usize) => {},
                    else => |st| {
                        const bit = @as(u64, 1) << @as(u6, @intCast(j));
                        if (cur.seen & bit == 0) {
                            const nseen = cur.seen | bit;
                            try work.push(Rec{ .p = j, .seen = nseen, .st = cur.st + st });
                        }
                    },
                }
            }
        }
        aoc.print("{}\n", .{seen.count()});
    }
    return [2]usize{ p1, p2 };
}

const Rec = struct {
    p: usize,
    seen: u64,
    st: usize,
    fn key(self: *const Rec) u64 {
        return (self.seen << 8) + @as(u64, @intCast(self.p));
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

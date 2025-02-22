const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const SIZE = 26 * 26 * 26 * 2 * 4;
const IN = 442;

const check = struct {
    key: u2,
    op: u8,
    val: usize,
    nxt: usize,
};

const search = struct {
    state: usize,
    min: [4]usize,
    max: [4]usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var rules: [SIZE]?check = .{null} ** SIZE;
    while (i < inp.len) : (i += 1) {
        const id = chompID(inp, &i);
        var k: usize = 0;
        while (inp[i] != '}') {
            i += 1;
            if (inp[i + 1] != '<' and inp[i + 1] != '>') {
                const nxt = chompID(inp, &i);
                rules[id * 4 + k] = check{ .key = 0, .op = ':', .val = 0, .nxt = nxt };
                k += 1;
                break;
            }
            const key = key_ch(inp[i]);
            const op = inp[i + 1];
            i += 2;
            const val = try aoc.chompUint(usize, inp, &i);
            var c = check{ .key = key, .op = op, .val = val, .nxt = 0 };
            i += 1;
            c.nxt = chompID(inp, &i);
            rules[id * 4 + k] = c;
            k += 1;
        }
        i += 1;
        if (i + 1 < inp.len and inp[i + 1] == '\n') {
            break;
        }
    }
    i += 2;
    var p1: usize = 0;
    while (i < inp.len) : (i += 1) {
        var p: [4]usize = .{0} ** 4;
        while (inp[i] != '}') {
            i += 1;
            const k = key_ch(inp[i]);
            i += 2;
            p[@as(usize, k)] = try aoc.chompUint(usize, inp, &i);
        }
        var state: usize = IN;
        while (true) {
            if (state == 0) {
                break;
            }
            if (state == 1) {
                p1 += p[0] + p[1] + p[2] + p[3];
                break;
            }
            for (0..4) |k| {
                if (rules[state * 4 + k]) |chk| {
                    if (chk.op == ':') {
                        state = chk.nxt;
                        break;
                    }
                    if (chk.op == '<') {
                        if (p[chk.key] < chk.val) {
                            state = chk.nxt;
                            break;
                        }
                        continue;
                    }
                    if (p[chk.key] > chk.val) {
                        state = chk.nxt;
                        break;
                    }
                } else {
                    break;
                }
            }
        }
        i += 1;
    }

    var p2: usize = 0;
    var todo = try std.BoundedArray(search, 512).init(0);
    try todo.append(search{
        .state = IN,
        .min = [4]usize{ 1, 1, 1, 1 },
        .max = [4]usize{ 4000, 4000, 4000, 4000 },
    });
    while (todo.len > 0) {
        var cur = todo.pop();
        if (cur.state == 0) {
            continue;
        }
        if (cur.state == 1) {
            p2 += (cur.max[0] - cur.min[0] + 1) * (cur.max[1] - cur.min[1] + 1) * (cur.max[2] - cur.min[2] + 1) * (cur.max[3] - cur.min[3] + 1);
        }
        for (0..4) |k| {
            if (rules[cur.state * 4 + k]) |chk| {
                if (chk.op == ':') {
                    try todo.append(search{
                        .state = chk.nxt,
                        .min = [4]usize{ cur.min[0], cur.min[1], cur.min[2], cur.min[3] },
                        .max = [4]usize{ cur.max[0], cur.max[1], cur.max[2], cur.max[3] },
                    });
                    continue;
                }
                var ntrue = search{
                    .state = chk.nxt,
                    .min = [4]usize{ cur.min[0], cur.min[1], cur.min[2], cur.min[3] },
                    .max = [4]usize{ cur.max[0], cur.max[1], cur.max[2], cur.max[3] },
                };
                if (chk.op == '>') {
                    ntrue.min[chk.key] = if (cur.min[chk.key] > chk.val + 1)
                        cur.min[chk.key]
                    else
                        chk.val + 1;
                    cur.max[chk.key] = if (cur.max[chk.key] < chk.val)
                        cur.max[chk.key]
                    else
                        chk.val;
                } else {
                    ntrue.max[chk.key] = if (cur.max[chk.key] < chk.val - 1)
                        cur.max[chk.key]
                    else
                        chk.val - 1;
                    cur.min[chk.key] = if (cur.min[chk.key] > chk.val)
                        cur.min[chk.key]
                    else
                        chk.val;
                }
                try todo.append(ntrue);
            } else {
                break;
            }
        }
    }
    return [2]usize{ p1, p2 };
}

fn key_ch(ch: u8) u2 {
    switch (ch) {
        'x' => return 0,
        'm' => return 1,
        'a' => return 2,
        else => return 3,
    }
}

fn chompID(inp: anytype, i: *usize) usize {
    var id: usize = 0;
    while (i.* < inp.len) : (i.* += 1) {
        switch (inp[i.*]) {
            'R' => {
                i.* += 1;
                return 0;
            },
            'A' => {
                i.* += 1;
                return 1;
            },
            'a'...'z' => {
                id = 26 * id + @as(usize, inp[i.*] - 'a');
                continue;
            },
            else => {},
        }
        break;
    }
    return id << 1;
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

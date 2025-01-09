const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: [8]u8,
    p2: usize,
};

fn parts(inp: []const u8) anyerror!Res {
    var words = std.AutoHashMap(usize, usize).init(aoc.halloc);
    defer words.deinit();
    var word: [1500]usize = .{0} ** 1500;
    var weight: [1500]usize = .{0} ** 1500;
    var child: [1500]bool = .{false} ** 1500;
    var children_back: [1500 * 10]usize = .{0} ** (1500 * 10);
    var children = aoc.ListOfLists(usize).init(children_back[0..], 1500);
    var id: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const lw = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
        var wid = id;
        if (words.get(lw)) |x| {
            wid = x;
        } else {
            try words.put(lw, id);
            id += 1;
        }
        word[wid] = lw;
        i += 2;
        const w = try aoc.chompUint(usize, inp, &i);
        weight[wid] = w;
        i += 1;
        if (inp[i] == '\n') {
            continue;
        }
        i += 4;
        while (i < inp.len) {
            const cw = try aoc.chompWord(usize, aoc.AlphaLowerWord, inp, &i);
            var cid = id;
            if (words.get(cw)) |x| {
                cid = x;
            } else {
                try words.put(cw, id);
                id += 1;
            }
            word[cid] = cw;
            child[cid] = true;
            try children.put(wid, cid);
            if (inp[i] != ',') {
                break;
            }
            i += 2;
        }
    }
    var p1: usize = 0;
    for (0..id) |wid| {
        if (!child[wid]) {
            p1 = wid;
            break;
        }
    }
    var res = Res{
        .p1 = .{32} ** 8,
        .p2 = @as(usize, @intCast(-try balance(p1, weight, children))),
    };
    aoc.unchompWord(usize, aoc.AlphaLowerWord, word[p1], &res.p1);
    return res;
}

fn balance(id: usize, weight: [1500]usize, children: aoc.ListOfLists(usize)) anyerror!isize {
    const w = weight[id];
    const cl = children.sublen(id);
    if (cl == 0) {
        return @as(isize, @intCast(w));
    }
    var good: ?usize = null;
    var gid: usize = 0;
    var bad: ?usize = null;
    var bid: usize = 0;
    for (0..cl) |c| {
        const cid = try children.get(id, c);
        const cw = try balance(cid, weight, children);
        if (cw < 0) {
            return cw;
        }
        const wu = @as(usize, @intCast(cw));
        if (good == null) {
            good = wu;
            gid = cid;
        } else if (wu == good) {
            if (bad != null) {
                break;
            }
            continue;
        } else if (bad == null) {
            bad = wu;
            bid = cid;
        } else if (bad == wu) {
            // good and bad are wrong way around
            aoc.swap(?usize, &good, &bad);
            aoc.swap(usize, &gid, &bid);
            break;
        } else {
            aoc.print("{any} {any}  {}\n", .{ good, bad == null, w });
            unreachable;
        }
    }
    if (bad) |bw| {
        const correction = @as(isize, @intCast(weight[bid])) + @as(isize, @intCast(good.?)) - @as(isize, @intCast(bw));
        return -@as(isize, @intCast(correction));
    }
    return @as(isize, @intCast(w + good.? * cl));
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

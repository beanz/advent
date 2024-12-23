const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Block = struct {
    size: u8,
    id: ?usize,
};

const File = struct {
    size: u8,
    idx: usize,
    id: usize,
};

const Free = struct {
    size: u8,
    idx: usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var blocks_ = try std.BoundedArray(Block, 20480).init(0);
    var files_ = try std.BoundedArray(File, 10240).init(0);
    var frees_ = try std.BoundedArray(Free, 10240).init(0);
    {
        var i: usize = 0;
        var j: usize = 0;
        while (j < inp.len - 1) : (j += 1) {
            const ch = inp[j];
            const size = ch - '0';
            if (j & 1 == 0) {
                const id = j / 2;
                try blocks_.append(Block{ .size = size, .id = id });
                try files_.append(File{ .size = size, .id = id, .idx = i });
            } else {
                if (size != 0) {
                    try blocks_.append(Block{ .size = size, .id = null });
                    try frees_.append(Free{ .size = size, .idx = i });
                }
            }
            i += @as(usize, size);
        }
    }
    var blocks = blocks_.slice();
    var p1: usize = 0;
    var j: usize = 0;
    var head: usize = 0;
    var tail = blocks.len - 1;
    while (head <= tail) {
        var v = blocks[head].id;
        if (v == null) {
            if (blocks[tail].id == null) {
                tail -= 1;
                continue;
            }
            v = blocks[tail].id;
            blocks[tail].size -= 1;
            if (blocks[tail].size == 0) {
                tail -= 1;
            }
        }
        p1 += (j * v.?);
        blocks[head].size -= 1;
        if (blocks[head].size == 0) {
            head += 1;
        }
        j += 1;
    }

    var files = files_.slice();
    var frees = frees_.slice();
    var p2: usize = 0;
    var first_free: [10]usize = .{0} ** 10;
    var i = files.len;
    while (i != 0) {
        i -= 1;
        const size = files[i].size;
        if (size == 0) {
            continue;
        }
        var jj = first_free[@as(usize, size)];
        while (jj < frees.len and files[i].idx > frees[jj].idx) {
            if (files[i].size > frees[jj].size) {
                jj += 1;
                continue;
            }
            first_free[@as(usize, size)] = jj;
            files[i].idx = frees[jj].idx;
            frees[jj].idx += files[i].size;
            frees[jj].size -= files[i].size;
            break;
        }
        for (0..size) |kk| {
            p2 += (files[i].idx + kk) * (files[i].id);
        }
    }
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

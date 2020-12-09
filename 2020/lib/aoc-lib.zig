const std = @import("std");
const ArrayList = std.ArrayList;
const alloc = std.heap.page_allocator;

pub fn readInts(inp: anytype) anyerror![]const i64 {
    var ints = ArrayList(i64).init(alloc);
    var it = std.mem.tokenize(inp, ":, \n");
    while (it.next()) |is| {
        if (is.len == 0) {
            break;
        }
        const i = std.fmt.parseInt(i64, is, 10) catch {
            continue;
        };
        try ints.append(i);
    }
    return ints.items;
}

pub fn readLines(inp: anytype) anyerror!std.ArrayListAligned([]const u8, null) {
    var lines = ArrayList([]const u8).init(alloc);
    var lit = std.mem.split(inp, "\n");
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        try lines.append(line);
    }
    return lines;
}

pub fn readChunks(inp: anytype) anyerror!std.ArrayListAligned([]const u8, null) {
    var chunks = ArrayList([]const u8).init(alloc);
    var cit = std.mem.split(inp, "\n\n");
    while (cit.next()) |chunk| {
        if (chunk.len == 0) {
            break;
        }
        if (chunk[chunk.len - 1] == '\n') {
            try chunks.append(chunk[0 .. chunk.len - 1]);
        } else {
            try chunks.append(chunk);
        }
    }
    return chunks;
}

pub fn minc(m: anytype, k: anytype) void {
    if (m.*.get(k)) |v| {
        m.*.put(k, v + 1) catch {};
    } else {
        m.*.put(k, 1) catch {};
    }
}

pub fn exists(m: anytype, k: anytype) bool {
    return m.get(k) orelse false;
}

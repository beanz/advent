pub const std = @import("std");
pub const Args = std.process.args;

// mem
pub const alloc = std.heap.page_allocator;
pub const free = alloc.free;
pub const dupe = std.mem.dupe;
pub const copy = std.mem.copy;
pub const memset = std.mem.set;
pub const Allocator = std.mem.Allocator;
pub const ArenaAllocator = std.heap.ArenaAllocator;

// sort
pub const sort = std.sort;
pub fn i64LessThan(c: void, a: i64, b: i64) bool {
    return a < b;
}

pub fn i64GreaterThan(c: void, a: i64, b: i64) bool {
    return a > b;
}

pub fn usizeLessThan(c: void, a: usize, b: usize) bool {
    return a < b;
}

pub fn usizeGreaterThan(c: void, a: usize, b: usize) bool {
    return a > b;
}

// io
pub const out = &std.io.getStdOut().writer();
pub const print = out.print;
pub const debug = std.debug;
pub const warn = debug.warn;
pub const inputfile = @embedFile("input.txt");
pub const test0file = @embedFile("test0.txt");
pub const test1file = @embedFile("test1.txt");
pub const test2file = @embedFile("test2.txt");
pub const test3file = @embedFile("test3.txt");
pub const test4file = @embedFile("test4.txt");
pub const test5file = @embedFile("test5.txt");
pub const test6file = @embedFile("test6.txt");
pub const test7file = @embedFile("test7.txt");
pub const test8file = @embedFile("test8.txt");
pub const test9file = @embedFile("test9.txt");

pub fn input() []const u8 {
    var args = Args();
    _ = args.skip();
    var res: []const u8 = inputfile;
    if (args.next(alloc)) |arg1| {
        free(arg1 catch unreachable);
        res = test1file;
    }
    return res;
}

// parsing
pub const split = std.mem.split;
pub const tokenize = std.mem.tokenize;
pub const parseInt = std.fmt.parseInt;
pub const parseUnsigned = std.fmt.parseUnsigned;

// math
pub const absCast = math.absCast;
pub const math = std.math;
pub const minInt = math.minInt;
pub const maxInt = math.maxInt;

// data
pub const ArrayList = std.ArrayList;
pub const StringHashMap = std.StringHashMap;
pub const AutoHashMap = std.AutoHashMap;
pub const Stack = std.atomic.Stack;

// test
pub const assert = std.testing.expect;
pub const assertEq = std.testing.expectEqual;
pub fn assertStrEq(exp: []const u8, act: []const u8) anyerror!void {
    if (!std.mem.eql(u8, exp, act)) {
        warn("expected, '{s}' but was '{s}'\n", .{ exp, act });
    }
    try assert(std.mem.eql(u8, exp, act));
}

pub fn DEBUG() i32 {
    const debug = try std.os.getEnvVarOwned(alloc, "AoC_DEBUG");
    const i = try parseInt(i32, name, 10);
    alloc.free(debug);
    return i;
}

pub fn readInts(inp: anytype, T: type) []T {
    var ints = ArrayList(T).init(alloc);
    var it = std.mem.tokenize(inp, ":, \n");
    while (it.next()) |is| {
        if (is.len == 0) {
            break;
        }
        const i = std.fmt.parseInt(T, is, 10) catch {
            continue;
        };
        ints.append(i) catch unreachable;
    }
    return ints.toOwnedSlice();
}

pub fn readLines(inp: anytype) [][]u8 {
    var lines = ArrayList([]u8).init(alloc);
    var lit = std.mem.split(inp, "\n");
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        lines.append(line) catch unreachable;
    }
    return lines.toOwnedSlice();
}

pub fn readChunks(inp: anytype) [][]u8 {
    var chunks = ArrayList([]u8).init(alloc);
    var cit = std.mem.split(inp, "\n\n");
    while (cit.next()) |chunk| {
        if (chunk.len == 0) {
            break;
        }
        if (chunk[chunk.len - 1] == '\n') {
            chunks.append(chunk[0 .. chunk.len - 1]) catch unreachable;
        } else {
            chunks.append(chunk) catch unreachable;
        }
    }
    return chunks.toOwnedSlice();
}

pub fn readChunkyObjects(inp: anytype, chunkSep: []const u8, recordSep: []const u8, fieldSep: []const u8) [](StringHashMap([]const u8)) {
    var report = ArrayList(StringHashMap([]const u8)).init(alloc);
    var cit = split(inp, chunkSep);
    while (cit.next()) |chunk| {
        if (chunk.len == 0) {
            break;
        }
        var map = StringHashMap([]const u8).init(alloc);
        var fit = tokenize(chunk, recordSep);
        while (fit.next()) |field| {
            if (field.len == 0) {
                break;
            }
            var kvit = split(field, fieldSep);
            const k = kvit.next().?;
            const v = kvit.next().?;
            map.put(k, v) catch unreachable;
        }
        report.append(map) catch unreachable;
    }
    return report.toOwnedSlice();
}

pub fn minc(m: anytype, k: anytype) void {
    if (m.*.get(k)) |v| {
        m.*.put(k, v + 1) catch {};
    } else {
        m.*.put(k, 1) catch {};
    }
}

pub fn stringLessThan(c: void, a: []const u8, b: []const u8) bool {
    var i: usize = 0;
    while (i < a.len and i < b.len and a[i] == b[i]) {
        i += 1;
    }
    if (a[i] == b[i]) {
        return a.len < b.len;
    }
    return a[i] < b[i];
}

pub fn rotateLines(lines: [][]const u8) [][]const u8 {
    const end = lines.len - 1;
    var tmp = alloc.alloc([]u8, lines[0].len) catch unreachable;
    var i: usize = 0;
    while (i < lines[0].len) {
        tmp[i] = alloc.alloc(u8, lines.len) catch unreachable;
        i += 1;
    }
    i = 0;
    while (i < lines[0].len) {
        var j: usize = 0;
        while (j < lines.len) {
            tmp[i][j] = lines[end - j][i];
            j += 1;
        }
        i += 1;
    }
    return tmp;
}

pub fn reverseLines(lines: [][]const u8) void {
    const end = lines.len - 1;
    var j: usize = 0;
    while (j < lines.len / 2) {
        var tmp = lines[j];
        lines[j] = lines[end - j];
        lines[end - j] = tmp;
        j += 1;
    }
}

pub fn countCharsInLines(lines: [][]const u8, findCh: u8) usize {
    var c: usize = 0;
    for (lines) |line| {
        for (line) |ch| {
            if (ch == findCh) {
                c += 1;
            }
        }
    }
    return c;
}

pub fn prettyLines(lines: [][]const u8) void {
    for (lines) |line| {
        warn("{}\n", .{line});
    }
}
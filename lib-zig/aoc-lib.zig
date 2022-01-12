const std = @import("std");
const Args = std.process.args;

// mem
pub const halloc = std.heap.page_allocator;
pub const talloc = std.testing.allocator;

// sort
pub const sort = std.sort;
pub fn i64LessThan(_: void, a: i64, b: i64) bool {
    return a < b;
}

pub fn i64GreaterThan(_: void, a: i64, b: i64) bool {
    return a > b;
}

pub fn usizeLessThan(_: void, a: usize, b: usize) bool {
    return a < b;
}

pub fn usizeGreaterThan(_: void, a: usize, b: usize) bool {
    return a > b;
}

// io
pub const out = &std.io.getStdOut().writer();
pub const print = out.print;

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
    if (args.next(halloc)) |arg1| {
        halloc.free(arg1 catch unreachable);
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

// test
pub const assert = std.testing.expect;
pub const assertEq = std.testing.expectEqual;
pub fn assertStrEq(exp: []const u8, act: []const u8) anyerror!void {
    if (!std.mem.eql(u8, exp, act)) {
        std.debug.print("expected, '{s}' but was '{s}'\n", .{ exp, act });
    }
    try assert(std.mem.eql(u8, exp, act));
}

pub fn DEBUG() i32 {
    const debuglevel = @import("std").process.getEnvVarOwned(halloc, "AoC_DEBUG") catch return 0;
    const i = parseInt(i32, debuglevel, 10) catch return 0;
    halloc.free(debuglevel);
    return i;
}

pub fn Ints(alloc: std.mem.Allocator, comptime T: type, inp: anytype) anyerror![]T {
    var ints = std.ArrayList(T).init(alloc);
    var it = std.mem.tokenize(u8, inp, ":, \n");
    while (it.next()) |is| {
        if (is.len == 0) {
            break;
        }
        const i = std.fmt.parseInt(T, is, 10) catch {
            continue;
        };
        try ints.append(i);
    }
    return ints.toOwnedSlice();
}

pub fn BoundedInts(comptime T: type, comptime expected: usize, inp: anytype) anyerror![]T {
    var ints = try std.BoundedArray(T, expected).init(0);
    var n: T = 0;
    var num = false;
    for (inp) |ch| {
        if ('0' <= ch and ch <= '9') {
            num = true;
            n = n * 10 + @as(T, ch - '0');
        } else if (num) {
            try ints.append(n);
            n = 0;
            num = false;
        }
    }
    if (num) {
        try ints.append(n);
    }
    return ints.slice();
}

pub fn readLines(alloc: std.mem.Allocator, inp: anytype) [][]const u8 {
    var lines = std.ArrayList([]const u8).init(alloc);
    var lit = std.mem.split(u8, inp, "\n");
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        lines.append(line) catch unreachable;
    }
    return lines.toOwnedSlice();
}

pub fn readChunks(alloc: std.mem.Allocator, inp: anytype) [][]const u8 {
    var chunks = std.ArrayList([]const u8).init(alloc);
    var cit = std.mem.split(u8, inp, "\n\n");
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

pub fn readChunkyObjects(alloc: std.mem.Allocator, inp: anytype, chunkSep: []const u8, recordSep: []const u8, fieldSep: []const u8) [](std.StringHashMap([]const u8)) {
    var report = std.ArrayList(std.StringHashMap([]const u8)).init(alloc);
    var cit = split(u8, inp, chunkSep);
    while (cit.next()) |chunk| {
        if (chunk.len == 0) {
            break;
        }
        var map = std.StringHashMap([]const u8).init(alloc);
        var fit = tokenize(u8, chunk, recordSep);
        while (fit.next()) |field| {
            if (field.len == 0) {
                break;
            }
            var kvit = split(u8, field, fieldSep);
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

pub fn stringLessThan(_: void, a: []const u8, b: []const u8) bool {
    var i: usize = 0;
    while (i < a.len and i < b.len and a[i] == b[i]) {
        i += 1;
    }
    if (a[i] == b[i]) {
        return a.len < b.len;
    }
    return a[i] < b[i];
}

pub fn rotateLinesNonSymmetric(alloc: std.mem.Allocator, lines: [][]const u8) [][]u8 {
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

pub fn rotateLines(lines: [][]u8) void {
    const l = lines.len;
    assertEq(l, lines[0].len) catch unreachable;
    var i: usize = 0;
    while (i < l) : (i += 1) {
        var j = i;
        while (j < l - i - 1) : (j += 1) {
            var tmp = lines[i][j];
            lines[i][j] = lines[l - j - 1][i];
            lines[l - j - 1][i] = lines[l - i - 1][l - j - 1];
            lines[l - i - 1][l - j - 1] = lines[j][l - i - 1];
            lines[j][l - i - 1] = tmp;
        }
    }
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
        std.debug.print("{}\n", .{line});
    }
}

pub fn BENCH() bool {
    const is_bench = @import("std").process.getEnvVarOwned(halloc, "AoC_BENCH") catch return false;
    halloc.free(is_bench);
    return true;
}

pub fn benchme(inp: []const u8, call: fn (in: []const u8, bench: bool) anyerror!void) anyerror!void {
    var it: i128 = 0;
    const is_bench = BENCH();
    var start = @import("std").time.nanoTimestamp();
    var elapsed: i128 = 0;
    while (true) {
        try call(inp, is_bench);
        it += 1;
        elapsed = @import("std").time.nanoTimestamp() - start;
        if (!is_bench or elapsed > 1000000000) {
            break;
        }
    }
    if (is_bench) {
        try print("bench {} iterations in {}ns: {}ns\n", .{ it, elapsed, @divTrunc(elapsed, it) });
    }
}

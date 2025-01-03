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
//pub const out = &std.io.getStdOut().writer();
pub const print = &std.debug.print;

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
    if (args.next()) |filename| {
        const inp = std.fs.cwd().readFileAlloc(halloc, filename, std.math.maxInt(usize)) catch unreachable;
        //defer halloc.free(inp);
        res = inp;
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

pub fn BoundedInts(comptime T: type, b: anytype, inp: anytype) anyerror![]T {
    var n: T = 0;
    var num = false;
    for (inp) |ch| {
        if ('0' <= ch and ch <= '9') {
            num = true;
            n = n * 10 + @as(T, ch - '0');
        } else if (num) {
            try b.append(n);
            n = 0;
            num = false;
        }
    }
    if (num) {
        try b.append(n);
    }
    return b.slice();
}

pub fn BoundedSignedInts(comptime T: type, b: anytype, inp: anytype) anyerror![]T {
    var n: T = 0;
    var m: T = 1;
    var num = false;
    for (inp) |ch| {
        if (ch == '-') {
            m = -1;
            num = true;
        } else if ('0' <= ch and ch <= '9') {
            num = true;
            n = n * 10 + @as(T, ch - '0');
        } else if (num) {
            try b.append(n * m);
            n = 0;
            m = 1;
            num = false;
        } else {
            m = 1;
        }
    }
    if (num) {
        try b.append(n * m);
    }
    return b.slice();
}

pub fn chompUint(comptime T: type, inp: anytype, i: *usize) anyerror!T {
    var n: T = 0;
    std.debug.assert(i.* < inp.len and '0' <= inp[i.*] and inp[i.*] <= '9');
    while (i.* < inp.len) : (i.* += 1) {
        if ('0' <= inp[i.*] and inp[i.*] <= '9') {
            n = n * 10 + @as(T, inp[i.*] - '0');
            continue;
        }
        break;
    }
    return n;
}

pub fn chompInt(comptime T: type, inp: anytype, i: *usize) anyerror!T {
    var n: T = 0;
    var neg: bool = false;
    std.debug.assert(i.* < inp.len and (('0' <= inp[i.*] and inp[i.*] <= '9') or (inp[i.*] == '-')));
    while (i.* < inp.len) : (i.* += 1) {
        if ('0' <= inp[i.*] and inp[i.*] <= '9') {
            n = n * 10 + @as(T, inp[i.*] - '0');
            continue;
        }
        if (inp[i.*] == '-') {
            neg = true;
            continue;
        }
        break;
    }
    if (neg) {
        return -n;
    }
    return n;
}

pub fn chompId(inp: []const u8, i: *usize, prime: u8) anyerror!u8 {
    var id: u8 = 0;
    std.debug.assert(i.* < inp.len and (('0' <= inp[i.*] and inp[i.*] <= '9') or ('a' <= inp[i.*] and inp[i.*] <= 'z') or ('A' <= inp[i.*] and inp[i.*] <= 'Z')));
    while (i.* < inp.len and (('0' <= inp[i.*] and inp[i.*] <= '9') or ('a' <= inp[i.*] and inp[i.*] <= 'z') or ('A' <= inp[i.*] and inp[i.*] <= 'Z'))) : (i.* += 1) {
        id = (id *% prime) ^ inp[i.*];
    }
    return id;
}

pub fn max(comptime T: type, a: T, b: T) T {
    if (a > b) {
        return a;
    }
    return b;
}

pub fn min(comptime T: type, a: T, b: T) T {
    if (a < b) {
        return a;
    }
    return b;
}

pub fn splitToOwnedSlice(alloc: std.mem.Allocator, inp: []const u8, sep: []const u8) ![][]const u8 {
    var bits = std.ArrayList([]const u8).init(alloc);
    var it = std.mem.split(u8, inp, sep);
    while (it.next()) |bit| {
        if (bit.len == 0) {
            break;
        }
        try bits.append(bit);
    }
    return bits.toOwnedSlice();
}

pub fn readLines(alloc: std.mem.Allocator, inp: anytype) anyerror![][]const u8 {
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

pub fn readChunks(alloc: std.mem.Allocator, inp: anytype) anyerror![][]const u8 {
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

pub fn readChunkyObjects(alloc: std.mem.Allocator, inp: anytype, chunkSep: []const u8, recordSep: []const u8, fieldSep: []const u8) anyerror![](std.StringHashMap([]const u8)) {
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
            const tmp = lines[i][j];
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
        const tmp = lines[j];
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

pub fn benchme(inp: []const u8, comptime call: fn (in: []const u8, bench: bool) anyerror!void) anyerror!void {
    var it: i128 = 0;
    const is_bench = BENCH();
    const start = @import("std").time.nanoTimestamp();
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
        print("bench {} iterations in {}ns: {}ns\n", .{ it, elapsed, @divTrunc(elapsed, it) });
    }
}

pub const ByteMap = struct {
    m: []const u8,
    w: usize,
    h: usize,
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, inp: []const u8) !*ByteMap {
        var bm = try alloc.create(ByteMap);
        bm.m = inp;
        bm.alloc = alloc;
        var w: usize = 0;
        while (w < inp.len and inp[w] != '\n') : (w += 1) {}
        bm.w = w + 1;
        bm.h = inp.len / bm.w;
        // try print("{} x {} = {}\n", .{ bm.w, bm.h, inp.len });
        return bm;
    }
    pub fn deinit(self: *ByteMap) void {
        self.alloc.destroy(self);
    }
    pub fn width(self: *ByteMap) usize {
        return self.w - 1;
    }
    pub fn height(self: *ByteMap) usize {
        return self.h;
    }
    pub fn size(self: *ByteMap) usize {
        return (self.w - 1) * self.h;
    }
    pub fn indexToXY(self: *ByteMap, i: usize) [2]usize {
        return [2]usize{ i % self.w, i / self.w };
    }
    pub fn xyToIndex(self: *ByteMap, x: usize, y: usize) usize {
        return x + y * self.w;
    }
    pub fn contains(self: *ByteMap, i: usize) bool {
        return i >= 0 and (i % self.w) < (self.w - 1) and i < self.w * self.h;
    }
    pub fn containsXY(self: *ByteMap, x: usize, y: usize) bool {
        return x < self.w - 1 and y < self.h;
    }
    pub fn get(self: *ByteMap, i: usize) u8 {
        return self.m[i];
    }
    pub fn getXY(self: *ByteMap, x: usize, y: usize) u8 {
        return self.m[x + y * self.w];
    }
    pub fn set(self: *ByteMap, i: usize, v: u8) void {
        self.m[i] = v;
    }
    pub fn setXY(self: *ByteMap, x: usize, y: usize, v: u8) void {
        self.m[x + y * self.w] = v;
    }
    pub fn add(self: *ByteMap, i: usize, v: u8) void {
        self.m[i] += v;
    }
    pub fn addXY(self: *ByteMap, x: usize, y: usize, v: u8) void {
        self.m[x + y * self.w] += v;
    }
    pub fn visit(self: *ByteMap, call: fn (i: usize, v: u8) [2]u8) usize {
        const changes: usize = 0;
        var y: usize = 0;
        while (y < self.h) : (y += 1) {
            var x: usize = 0;
            while (x < self.h - 1) : (x += 1) {
                const i = x + y * self.w;
                const res = call(i, self.m[i]);
                if (res[1] != 0) {
                    self.m[i] = res[0];
                }
            }
        }
        return changes;
    }
};

test "bytemap" {
    var bm = try ByteMap.init(talloc, "2199943210\n3987894921\n9856789892\n8767896789\n9899965678\n");
    defer bm.deinit();
    try assertEq(@as(usize, 10), bm.width());
    try assertEq(@as(usize, 5), bm.height());
    try assertEq(true, bm.containsXY(0, 0));
    try assertEq(true, bm.contains(bm.xyToIndex(0, 0)));
    try assertEq(true, bm.containsXY(9, 0));
    try assertEq(true, bm.contains(bm.xyToIndex(9, 0)));
    try assertEq(false, bm.containsXY(10, 0));
    try assertEq(false, bm.contains(bm.xyToIndex(10, 0)));
    try assertEq(true, bm.containsXY(0, 4));
    try assertEq(true, bm.contains(bm.xyToIndex(0, 4)));
    try assertEq(false, bm.containsXY(0, 5));
    try assertEq(false, bm.contains(bm.xyToIndex(0, 5)));
}

pub fn TestCases(comptime T: type, comptime call: fn (in: []const u8) anyerror![2]T) anyerror!void {
    var file = try std.fs.cwd().openFile("TC.txt", .{});
    defer file.close();
    var br = std.io.bufferedReader(file.reader());
    var is = br.reader();
    var buf: [1024]u8 = undefined;
    while (true) {
        const filename = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
        const inp = try std.fs.cwd().readFileAlloc(talloc, filename, std.math.maxInt(usize));
        defer talloc.free(inp);
        const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
        var i: usize = 0;
        const p1 = try switch (T) {
            isize, i64, i32, i16, i8 => chompInt(T, p1s, &i),
            else => chompUint(T, p1s, &i),
        };
        const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
        i = 0;
        const p2 = try switch (T) {
            isize, i64, i32, i16, i8 => chompInt(T, p2s, &i),
            else => chompUint(T, p2s, &i),
        };
        const p = try call(inp);
        try assertEq([2]T{ p1, p2 }, p);
        if (try is.readUntilDelimiterOrEof(&buf, '\n')) |_| {
            continue;
        }
        break;
    }
}

pub fn Deque(comptime T: type) type {
    return struct {
        buf: []T,
        head: usize,
        tail: usize,
        length: usize,

        const Self = @This();

        pub fn init(buf: []T) Self {
            return Self{ .buf = buf, .head = 0, .tail = 0, .length = 0 };
        }
        pub fn len(self: Self) usize {
            return self.length;
        }
        pub fn is_empty(self: Self) bool {
            return self.length == 0;
        }
        pub fn clear(self: *Self) void {
            self.head = 0;
            self.tail = 0;
            self.length = 0;
        }
        pub fn push(self: *Self, v: T) anyerror!void {
            if (self.length == self.buf.len) {
                return error.OverFlow;
            }
            self.buf[self.tail] = v;
            self.tail += 1;
            if (self.tail == self.buf.len) {
                self.tail = 0;
            }
            self.length += 1;
        }
        pub fn pop(self: *Self) ?T {
            if (self.length == 0) {
                return null;
            }
            const r = self.buf[self.head];
            self.head += 1;
            if (self.head == self.buf.len) {
                self.head = 0;
            }
            self.length -= 1;
            return r;
        }
    };
}

pub inline fn swap(comptime T: type, a: *T, b: *T) void {
    const tmp = a.*;
    a.* = b.*;
    b.* = tmp;
}

pub fn permute(comptime T: type, items: []T) PermIter(T) {
    return PermIter(T){
        .items = items[0..],
        .len = items.len,
        .state = [_]u4{0} ** 32,
        .index = 0,
        .first = true,
    };
}

pub fn PermIter(comptime T: type) type {
    return struct {
        items: []T,
        len: usize,
        state: [32]u4,
        index: u4,
        first: bool,

        const Self = @This();

        pub fn next(self: *Self) ?[]T {
            if (self.first) {
                self.first = false;
                return self.items;
            }
            while (self.index < self.len) {
                if (self.state[self.index] < self.index) {
                    if (self.index & 0x1 == 0) {
                        swap(T, &self.items[0], &self.items[self.index]);
                    } else {
                        swap(T, &self.items[self.state[self.index]], &self.items[self.index]);
                    }
                    self.state[self.index] += 1;
                    self.index = 0;
                    return self.items;
                } else {
                    self.state[self.index] = 0;
                    self.index += 1;
                }
            }
            return null;
        }
    };
}

pub fn uintIter(comptime T: type, inp: []const u8) UintIter(T) {
    return UintIter(T){
        .inp = inp[0..],
        .i = 0,
    };
}

pub fn UintIter(comptime T: type) type {
    return struct {
        inp: []const u8,
        i: usize,

        const Self = @This();

        pub fn next(self: *Self) ?T {
            var n: T = 0;
            var num = false;
            while (self.i < self.inp.len) {
                const ch = self.inp[self.i];
                self.i += 1;
                if ('0' <= ch and ch <= '9') {
                    num = true;
                    n = n * 10 + @as(T, ch - '0');
                } else if (num) {
                    return n;
                }
            }
            if (num) {
                return n;
            }
            return null;
        }
    };
}

pub fn intIter(comptime T: type, inp: []const u8) IntIter(T) {
    return IntIter(T){
        .inp = inp[0..],
        .i = 0,
    };
}

pub fn IntIter(comptime T: type) type {
    return struct {
        inp: []const u8,
        i: usize,

        const Self = @This();

        pub fn next(self: *Self) ?T {
            var n: T = 0;
            var m: T = 1;
            var num = false;
            while (self.i < self.inp.len) {
                const ch = self.inp[self.i];
                self.i += 1;
                if (ch == '-') {
                    m = -1;
                    num = true;
                } else if ('0' <= ch and ch <= '9') {
                    num = true;
                    n = n * 10 + @as(T, ch - '0');
                } else if (num) {
                    return n * m;
                } else {
                    m = 1;
                }
            }
            if (num) {
                return n * m;
            }
            return null;
        }
    };
}

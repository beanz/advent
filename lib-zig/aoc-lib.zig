const std = @import("std");
const Args = std.process.args;
const Md5 = std.crypto.hash.Md5;

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
pub fn assertStrEqTrimmed(exp: []const u8, act: []const u8) anyerror!void {
    var k = act.len - 1;
    while (act[k] == ' ') {
        k -= 1;
    }
    return assertStrEq(exp, act[0 .. k + 1]);
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
    std.debug.assert(i.* < inp.len and (('0' <= inp[i.*] and inp[i.*] <= '9') or (inp[i.*] == '-') or (inp[i.*] == '+')));
    while (i.* < inp.len) : (i.* += 1) {
        if ('0' <= inp[i.*] and inp[i.*] <= '9') {
            n = n * 10 + @as(T, inp[i.*] - '0');
            continue;
        }
        if (inp[i.*] == '-') {
            neg = true;
            continue;
        }
        if (inp[i.*] == '+') {
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

inline fn wordChars(w: []const u8) [127]u8 {
    var c: [127]u8 = .{0} ** 127;
    var n: u8 = 1;
    for (w) |ch| {
        c[@as(usize, @intCast(ch))] = n;
        n += 1;
    }
    return c;
}

const WordDef = struct {
    chars: [127]u8,
    mul: usize,
};

pub const AlphaLowerWord = WordDef{
    .chars = wordChars("abcdefghijklmnopqrstuvwxyz"),
    .mul = 27,
};

pub const AlphaUpperWord = WordDef{
    .chars = wordChars("ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
    .mul = 27,
};

pub const AlphaWord = WordDef{
    .chars = wordChars("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"),
    .mul = 53,
};

pub const AlphaNumLowerWord = WordDef{
    .chars = wordChars("0123456789abcdefghijklmnopqrstuvwxyz"),
    .mul = 37,
};

pub const AlphaNumUpperWord = WordDef{
    .chars = wordChars("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
    .mul = 37,
};

pub const AlphaNumWord = WordDef{
    .chars = wordChars("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"),
    .mul = 63,
};

pub fn unchompWord(comptime T: type, comptime wordDef: WordDef, id: T, res: []u8) void {
    var kk = id;
    var l: usize = 0;
    while (kk != 0) : (kk /= wordDef.mul) {
        res[l] = @as(u8, @intCast((kk % wordDef.mul) + 'a' - 1));
        l += 1;
    }
    std.mem.reverse(u8, res[0..l]);
}

pub fn chompWord(comptime T: type, comptime worddef: WordDef, inp: []const u8, i: *usize) anyerror!T {
    var id: T = 0;
    std.debug.assert(i.* < inp.len and worddef.chars[inp[i.*]] != 0);
    while (i.* < inp.len) : (i.* += 1) {
        const n = worddef.chars[inp[i.*]];
        if (n == 0) {
            break;
        }
        id = (id * worddef.mul) + n;
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

pub fn lcm(a: anytype, b: anytype) @TypeOf(a, b) {
    return a * b / std.math.gcd(a, b);
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
        const p = try call(inp);
        switch (T) {
            isize, i64, i32, i16, i8 => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p1 = try chompInt(T, p1s, &i);
                try assertEq(p1, p[0]);
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                i = 0;
                const p2 = try chompInt(T, p2s, &i);
                try assertEq(p2, p[1]);
            },
            usize, u64, u32, u16, u8 => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p1 = try chompUint(T, p1s, &i);
                try assertEq(p1, p[0]);
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                i = 0;
                const p2 = try chompUint(T, p2s, &i);
                try assertEq(p2, p[1]);
            },
            else => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                try assertStrEqTrimmed(p1s, &p[0]);
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                try assertStrEqTrimmed(p2s, &p[1]);
            },
        }
        if (try is.readUntilDelimiterOrEof(&buf, '\n')) |_| {
            continue;
        }
        break;
    }
}

pub fn TestCasesRes(comptime T: type, comptime call: fn (in: []const u8) anyerror!T) anyerror!void {
    var file = try std.fs.cwd().openFile("TC.txt", .{});
    defer file.close();
    var br = std.io.bufferedReader(file.reader());
    var is = br.reader();
    var buf: [1024]u8 = undefined;
    while (true) {
        const filename = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
        const inp = try std.fs.cwd().readFileAlloc(talloc, filename, std.math.maxInt(usize));
        defer talloc.free(inp);
        const p = try call(inp);
        const P1T = @TypeOf(@field(p, "p1"));
        switch (P1T) {
            isize, i64, i32, i16, i8 => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p1 = try chompInt(P1T, p1s, &i);
                try assertEq(p1, p.p1);
            },
            usize, u64, u32, u16, u8 => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p1 = try chompUint(P1T, p1s, &i);
                try assertEq(p1, p.p1);
            },
            else => {
                const p1s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                try assertStrEqTrimmed(p1s, &p.p1);
            },
        }
        const P2T = @TypeOf(@field(p, "p2"));
        switch (P2T) {
            isize, i64, i32, i16, i8 => {
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p2 = try chompInt(P2T, p2s, &i);
                try assertEq(p2, p.p2);
            },
            usize, u64, u32, u16, u8 => {
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                var i: usize = 0;
                const p2 = try chompUint(P2T, p2s, &i);
                try assertEq(p2, p.p2);
            },
            else => {
                const p2s = (try is.readUntilDelimiterOrEof(&buf, '\n')).?;
                try assertStrEqTrimmed(p2s, &p.p2);
            },
        }
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
        pub fn shift(self: *Self) ?T {
            if (self.length == 0) {
                return null;
            }
            if (self.tail == 0) {
                self.tail = self.buf.len - 1;
            } else {
                self.tail -= 1;
            }
            self.length -= 1;
            return self.buf[self.tail];
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

pub fn chompUints(comptime T: type, inp: anytype, b: anytype) anyerror!void {
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
    return;
}

pub fn chompInts(comptime T: type, b: anytype, inp: anytype) anyerror!void {
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
    return;
}

pub const NumStr = struct {
    b: *[40]u8,
    l: usize,
    pl: usize,
    c: usize,

    pub fn init(alloc: std.mem.Allocator, b: *[40]u8, pl: usize) anyerror!*NumStr {
        var n = try alloc.create(NumStr);
        n.b = b;
        n.l = pl + 1;
        n.pl = pl;
        n.c = 0;
        n.b[pl] = '0';
        return n;
    }
    pub fn count(self: *NumStr) usize {
        return self.c;
    }
    pub fn inc(self: *NumStr) void {
        self.c += 1;
        var i = self.l - 1;
        while (i >= self.pl) : (i -= 1) {
            self.b[i] += 1;
            if (self.b[i] <= '9') {
                return;
            }
            self.b[i] = '0';
        }
        self.b[self.pl] = '1';
        self.b[self.l] = '0';
        self.l += 1;
    }
    pub fn bytes(self: *NumStr) []u8 {
        return self.b[0..self.l];
    }
};

pub fn inv_mod(comptime T: type, a: T, m: T) T {
    const y: T = @mod(a, m);
    var x: T = @as(T, 1);

    while (x < m) {
        defer x += 1;
        if (@rem((y * x), m) == 1)
            return x;
    }
    return 0;
}

pub fn crt(comptime T: type, a: []T, m: []T) T {
    const n = a.len;
    var M: T = 1;
    var x: T = 0;
    var i: usize = undefined;
    {
        i = 0;
        while (i < n) : (i += 1) {
            M *= m[i];
        }
    }
    {
        i = 0;
        while (i < n) : (i += 1) {
            const Mi = @divTrunc(M, m[i]);
            const z = inv_mod(T, Mi, m[i]);
            x = @mod((x + a[i] * Mi * z), M);
        }
    }
    return x;
}

pub fn ListOfLists(comptime T: type) type {
    return struct {
        buf: []T,
        l: usize,
        sl: usize,

        const Self = @This();

        pub fn init(buf: []T, l: usize) Self {
            return Self{ .buf = buf, .l = l, .sl = buf.len / l };
        }
        pub fn sublen(self: Self, i: usize) usize {
            return @as(usize, @intCast(self.buf[i * self.sl]));
        }
        pub fn get(self: Self, i: usize, j: usize) anyerror!T {
            const o = i * self.sl;
            const ll = self.buf[o];
            if (j < @as(usize, @intCast(ll))) {
                return self.buf[@as(usize, @intCast(o + j + 1))];
            }
            return error.OverFlow;
        }
        pub fn put(self: Self, i: usize, e: T) anyerror!void {
            const j = self.buf[i * self.sl] + 1;
            const ju = @as(usize, @intCast(j));
            if (j >= self.sl) {
                return error.OverFlow;
            }
            self.buf[i * self.sl] = j;
            self.buf[i * self.sl + ju] = e;
        }
        pub fn items(self: Self, i: usize) []const T {
            const j = self.buf[i * self.sl] + 1;
            const ju = @as(usize, @intCast(j));
            const ii = i * self.sl;
            return self.buf[ii + 1 .. ii + ju];
        }
        pub fn clear(self: Self, i: usize) void {
            self.buf[i * self.sl] = 0;
        }
    };
}

pub fn ocr(n: u64) u8 {
    return switch (n) {
        0b011001001010010111101001010010 => 'A',
        0b111001001011100100101001011100 => 'B',
        0b011001001010000100001001001100 => 'C',
        0b111001001010010100101001011100 => 'D',
        0b111101000011100100001000011110 => 'E',
        0b111101000011100100001000010000 => 'F',
        0b011001001010000101101001001110 => 'G',
        0b100101001011110100101001010010 => 'H',
        0b011100010000100001000010001110 => 'I',
        0b001100001000010000101001001100 => 'J',
        0b100101010011000101001010010010 => 'K',
        0b100001000010000100001000011110 => 'L',
        0b011001001010010100101001001100 => 'O',
        0b111001001010010111001000010000 => 'P',
        0b111001001010010111001010010010 => 'R',
        0b011101000010000011000001011100 => 'S',
        0b011100010000100001000010000100 => 'T',
        0b100101001010010100101001001100 => 'U',
        0b100011000101010001000010000100 => 'Y',
        0b111100001000100010001000011110 => 'Z',

        0b0011000100101000011000011000011111111000011000011000011000010 => 'A',
        0b0111101000011000001000001000001000001000001000001000010111100 => 'C',
        0b1111111000001000001000001111101000001000001000001000001111110 => 'E',
        0b0111101000011000001000001000001001111000011000011000110111010 => 'G',
        0b1000011000011000011000011111111000011000011000011000011000010 => 'H',
        0b1000011000101001001010001100001100001010001001001000101000010 => 'K',
        0b1000001000001000001000001000001000001000001000001000001111110 => 'L',
        0b1000011100011100011010011010011001011001011000111000111000010 => 'N',
        0b1111101000011000011000011111101001001000101000101000011000010 => 'R',
        0b1111110000010000010000100001000010000100001000001000001111110 => 'Z',
        else => '?',
    };
}

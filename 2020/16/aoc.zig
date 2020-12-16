const std = @import("std");
const Args = std.process.args;
const warn = std.debug.warn;
const math = std.math;
const bufPrint = std.fmt.bufPrint;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

const Mess = struct {
    const Field = struct {
        min1: i64,
        max1: i64,
        min2: i64,
        max2: i64,
        pub fn inRange(self: *Field, v: i64) bool {
            return (v >= self.min1 and v <= self.max1) or
                (v >= self.min2 and v <= self.max2);
        }
    };
    const Ticket = []const i64;
    fields: std.StringHashMap(*Field),
    our: Ticket,
    tickets: std.ArrayList(Ticket),
    err: i64,
    onlyDepart: bool,
    debug: bool,

    fn bit(v: i64) i64 {
        var b: i64 = 1;
        var bc: usize = 0;
        while (bc < v) {
            b <<= 1;
            bc += 1;
        }
        return b;
    }

    fn find1bit(v: i64) i64 {
        var count: i64 = 0;
        var n: i64 = 1;
        while ((v & n) == 0) {
            count += 1;
            n <<= 1;
        }
        return count;
    }

    pub fn count1s(v: i64) i64 {
        var count: i64 = 0;
        var n: i64 = 1 << 32;
        while (n > 0) {
            if ((n & v) != 0) {
                count += 1;
            }
            n >>= 1;
        }
        return count;
    }

    pub fn fromInput(inp: std.ArrayListAligned([]const u8, null), allocator: *std.mem.Allocator) !*Mess {
        var m = try alloc.create(Mess);
        m.fields = std.StringHashMap(*Field).init(alloc);
        m.err = 0;
        m.onlyDepart = true;
        m.debug = false;
        var i: usize = 0;
        var lit = std.mem.split(inp.items[0], "\n");
        while (lit.next()) |line| {
            var f = try alloc.create(Field);
            var sit = std.mem.split(line, ": ");
            const name = sit.next().?;
            var sit2 = std.mem.split(sit.next().?, " or ");
            var range1it = std.mem.split(sit2.next().?, "-");
            f.min1 = try std.fmt.parseInt(i64, range1it.next().?, 10);
            f.max1 = try std.fmt.parseInt(i64, range1it.next().?, 10);
            var range2it = std.mem.split(sit2.next().?, "-");
            f.min2 = try std.fmt.parseInt(i64, range2it.next().?, 10);
            f.max2 = try std.fmt.parseInt(i64, range2it.next().?, 10);
            try m.fields.put(name, f);
        }
        var our: Ticket = try aoc.readInts(inp.items[1]);
        lit = std.mem.split(inp.items[2], "\n");
        _ = lit.next().?;
        var tickets = std.ArrayList(Ticket).init(alloc);
        while (lit.next()) |line| {
            var ticket = try aoc.readInts(line);
            var validTicket = true;
            for (ticket) |v| {
                var validField = false;
                var fit = m.fields.iterator();
                while (fit.next()) |entry| {
                    if (entry.value.inRange(v)) {
                        validField = true;
                        break;
                    }
                }
                if (!validField) {
                    validTicket = false;
                    m.err += v;
                }
            }
            if (validTicket) {
                try tickets.append(ticket);
            }
        }
        m.tickets = tickets;
        m.our = our;
        return m;
    }

    pub fn Solve(self: *Mess) !i64 {
        var possible = std.StringHashMap(i64).init(alloc);
        var cfit = self.fields.iterator();
        while (cfit.next()) |entry| {
            try possible.put(entry.key, 0);
        }
        const target = self.tickets.items.len;
        var col: usize = 0;
        while (col < self.our.len) {
            var fit = self.fields.iterator();
            while (fit.next()) |entry| {
                var valid: usize = 0;
                const name = entry.key;
                const field = entry.value;
                for (self.tickets.items) |ticket| {
                    if (field.inRange(ticket[col])) {
                        valid += 1;
                    }
                }
                if (valid == target) {
                    if (self.debug) {
                        warn("found {} at {} ({})\n", .{ name, col, col });
                    }
                    var bm = possible.get(name).?;
                    bm |= bit(@intCast(i64, col));
                    try possible.put(name, bm);
                }
            }
            col += 1;
        }

        var p: i64 = 1;
        while (true) {
            var progress = false;
            var possIt = possible.iterator();
            while (possIt.next()) |possRec| {
                var name = possRec.key;
                var cols = possRec.value;
                if (cols != 0 and count1s(cols) == 1) {
                    progress = true;
                    var c: i64 = find1bit(cols);
                    var ourVal = self.our[math.absCast(c)];
                    if (self.debug) {
                        warn("definite {} is {} ({})\n", .{ name, c, ourVal });
                    }
                    if (name[0] == 'd' and name[1] == 'e' or !self.onlyDepart) {
                        p *= ourVal;
                    }
                    _ = possible.remove(name);
                    var possIt2 = possible.iterator();
                    while (possIt2.next()) |possRec2| {
                        possRec2.value &= (bit(c) ^ 0xffffffff);
                        try possible.put(possRec2.key, possRec2.value);
                    }
                    if (possible.count() == 0) {
                        return p;
                    }
                }
            }
            if (!progress) {
                warn("no progress made\n", .{});
                std.os.exit(0);
            }
        }
    }
};

test "count1s" {
    assertEq(@as(i64, 1), Mess.count1s(@as(i64, 1)));
    assertEq(@as(i64, 2), Mess.count1s(@as(i64, 3)));
    assertEq(@as(i64, 2), Mess.count1s(@as(i64, 6)));
}

test "examples" {
    const test1 = try aoc.readChunks(test1file);
    const test2 = try aoc.readChunks(test2file);
    const inp = try aoc.readChunks(input);

    var r: i64 = 71;
    var t1m = Mess.fromInput(test1, alloc) catch unreachable;
    assertEq(r, t1m.err);
    r = 21980;
    var inpm = Mess.fromInput(inp, alloc) catch unreachable;
    assertEq(r, inpm.err);

    var t2m = Mess.fromInput(test2, alloc) catch unreachable;
    t2m.onlyDepart = false;
    r = 1716;
    const t2a = t2m.Solve() catch unreachable;
    assertEq(r, t2a);
    r = 1439429522627;
    const impa = inpm.Solve() catch unreachable;
    assertEq(r, impa);
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var chunks: std.ArrayListAligned([]const u8, null) = undefined;
    var onlyDepart = true;
    if (args.next(alloc)) |_| {
        chunks = try aoc.readChunks(test2file);
        onlyDepart = false;
    } else {
        chunks = try aoc.readChunks(input);
    }
    var m = try Mess.fromInput(chunks, alloc);
    m.onlyDepart = onlyDepart;
    try stdout.print("Part1: {}\n", .{m.err});
    try stdout.print("Part2: {}\n", .{m.Solve()});
}

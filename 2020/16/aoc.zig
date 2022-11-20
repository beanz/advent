const std = @import("std");
const aoc = @import("aoc-lib.zig");

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
    alloc: std.mem.Allocator,
    debug: bool,

    fn bit(v: i64) i64 {
        var b: i64 = 1;
        var bc: usize = 0;
        while (bc < v) : (bc += 1) {
            b <<= 1;
        }
        return b;
    }

    fn find1bit(v: i64) i64 {
        var count: i64 = 0;
        var n: i64 = 1;
        while ((v & n) == 0) : (n <<= 1) {
            count += 1;
        }
        return count;
    }

    pub fn count1s(v: i64) i64 {
        var count: i64 = 0;
        var n: i64 = 1 << 32;
        while (n > 0) : (n >>= 1) {
            if ((n & v) != 0) {
                count += 1;
            }
        }
        return count;
    }

    pub fn fromInput(alloc: std.mem.Allocator, inp: [][]const u8) !*Mess {
        var m = try alloc.create(Mess);
        m.fields = std.StringHashMap(*Field).init(alloc);
        m.err = 0;
        m.onlyDepart = true;
        m.debug = false;
        var lit = std.mem.split(u8, inp[0], "\n");
        while (lit.next()) |line| {
            var f = try alloc.create(Field);
            var sit = std.mem.split(u8, line, ": ");
            const name = sit.next().?;
            var sit2 = std.mem.split(u8, sit.next().?, " or ");
            var range1it = std.mem.split(u8, sit2.next().?, "-");
            f.min1 = try std.fmt.parseInt(i64, range1it.next().?, 10);
            f.max1 = try std.fmt.parseInt(i64, range1it.next().?, 10);
            var range2it = std.mem.split(u8, sit2.next().?, "-");
            f.min2 = try std.fmt.parseInt(i64, range2it.next().?, 10);
            f.max2 = try std.fmt.parseInt(i64, range2it.next().?, 10);
            try m.fields.put(name, f);
        }
        var our: Ticket = try aoc.Ints(alloc, i64, inp[1]);
        lit = std.mem.split(u8, inp[2], "\n");
        _ = lit.next().?;
        var tickets = std.ArrayList(Ticket).init(alloc);
        while (lit.next()) |line| {
            var ticket = try aoc.Ints(alloc, i64, line);
            var validTicket = true;
            for (ticket) |v| {
                var validField = false;
                var fit = m.fields.iterator();
                while (fit.next()) |entry| {
                    if (entry.value_ptr.*.inRange(v)) {
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
            } else {
                alloc.free(ticket);
            }
        }
        m.tickets = tickets;
        m.our = our;
        m.alloc = alloc;
        return m;
    }

    pub fn deinit(self: *Mess) void {
        self.alloc.free(self.our);
        for (self.tickets.items) |t| {
            self.alloc.free(t);
        }
        self.tickets.deinit();
        var it = self.fields.iterator();
        while (it.next()) |f| {
            self.alloc.destroy(f.value_ptr.*);
        }
        self.fields.deinit();
        self.alloc.destroy(self);
    }

    pub fn Solve(self: *Mess) !i64 {
        var possible = std.StringHashMap(i64).init(self.alloc);
        defer possible.deinit();
        var cfit = self.fields.iterator();
        while (cfit.next()) |entry| {
            try possible.put(entry.key_ptr.*, 0);
        }
        const target = self.tickets.items.len;
        var col: usize = 0;
        while (col < self.our.len) {
            var fit = self.fields.iterator();
            while (fit.next()) |entry| {
                var valid: usize = 0;
                const name = entry.key_ptr.*;
                const field = entry.value_ptr.*;
                for (self.tickets.items) |ticket| {
                    if (field.inRange(ticket[col])) {
                        valid += 1;
                    }
                }
                if (valid == target) {
                    if (self.debug) {
                        std.debug.print("found {s} at {!} ({!})\n", .{ name, col, col });
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
                var name = possRec.key_ptr.*;
                var cols = possRec.value_ptr.*;
                if (cols != 0 and count1s(cols) == 1) {
                    progress = true;
                    var c: i64 = find1bit(cols);
                    var ourVal = self.our[std.math.absCast(c)];
                    if (self.debug) {
                        std.debug.print("definite {s} is {!} ({!})\n", .{ name, c, ourVal });
                    }
                    if (name[0] == 'd' and name[1] == 'e' or !self.onlyDepart) {
                        p *= ourVal;
                    }
                    _ = possible.remove(name);
                    var possIt2 = possible.iterator();
                    while (possIt2.next()) |possRec2| {
                        possRec2.value_ptr.* &= (bit(c) ^ 0xffffffff);
                        try possible.put(possRec2.key_ptr.*, possRec2.value_ptr.*);
                    }
                    if (possible.count() == 0) {
                        return p;
                    }
                }
            }
            if (!progress) {
                std.debug.print("no progress made\n", .{});
                std.os.exit(0);
            }
        }
    }
};

test "count1s" {
    try aoc.assertEq(@as(i64, 1), Mess.count1s(@as(i64, 1)));
    try aoc.assertEq(@as(i64, 2), Mess.count1s(@as(i64, 3)));
    try aoc.assertEq(@as(i64, 2), Mess.count1s(@as(i64, 6)));
}

test "examples" {
    const test1 = aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = aoc.readChunks(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var t1m = Mess.fromInput(aoc.talloc, test1) catch unreachable;
    defer t1m.deinit();
    try aoc.assertEq(@as(i64, 71), t1m.err);
    var inpm = Mess.fromInput(aoc.talloc, inp) catch unreachable;
    defer inpm.deinit();
    try aoc.assertEq(@as(i64, 21980), inpm.err);

    var t2m = Mess.fromInput(aoc.talloc, test2) catch unreachable;
    defer t2m.deinit();
    t2m.onlyDepart = false;
    const t2a = t2m.Solve() catch unreachable;
    try aoc.assertEq(@as(i64, 1716), t2a);
    const impa = inpm.Solve() catch unreachable;
    try aoc.assertEq(@as(i64, 1439429522627), impa);
}

fn day16(_: []const u8, bench: bool) anyerror!void {
    var args = std.process.args();
    _ = args.next();
    var chunks: [][]const u8 = undefined;
    var onlyDepart = true;
    if (args.next()) |_| {
        chunks = aoc.readChunks(aoc.halloc, aoc.test2file);
        onlyDepart = false;
    } else {
        chunks = aoc.readChunks(aoc.halloc, aoc.inputfile);
    }
    defer aoc.halloc.free(chunks);
    var m = try Mess.fromInput(aoc.halloc, chunks);
    defer m.deinit();
    m.onlyDepart = onlyDepart;
    var p1 = m.err;
    var p2 = m.Solve();
    if (!bench) {
        aoc.print("Part 1: {!}\nPart 2: {!}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day16);
}

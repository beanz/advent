usingnamespace @import("aoc-lib.zig");

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
    fields: StringHashMap(*Field),
    our: Ticket,
    tickets: ArrayList(Ticket),
    err: i64,
    onlyDepart: bool,
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

    pub fn fromInput(inp: [][]const u8, allocator: *Allocator) !*Mess {
        var m = try alloc.create(Mess);
        m.fields = StringHashMap(*Field).init(alloc);
        m.err = 0;
        m.onlyDepart = true;
        m.debug = false;
        var i: usize = 0;
        var lit = split(inp[0], "\n");
        while (lit.next()) |line| {
            var f = try alloc.create(Field);
            var sit = split(line, ": ");
            const name = sit.next().?;
            var sit2 = split(sit.next().?, " or ");
            var range1it = split(sit2.next().?, "-");
            f.min1 = try parseInt(i64, range1it.next().?, 10);
            f.max1 = try parseInt(i64, range1it.next().?, 10);
            var range2it = split(sit2.next().?, "-");
            f.min2 = try parseInt(i64, range2it.next().?, 10);
            f.max2 = try parseInt(i64, range2it.next().?, 10);
            try m.fields.put(name, f);
        }
        var our: Ticket = readInts(inp[1], i64);
        lit = split(inp[2], "\n");
        _ = lit.next().?;
        var tickets = ArrayList(Ticket).init(alloc);
        while (lit.next()) |line| {
            var ticket = readInts(line, i64);
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
            }
        }
        m.tickets = tickets;
        m.our = our;
        return m;
    }

    pub fn Solve(self: *Mess) !i64 {
        var possible = StringHashMap(i64).init(alloc);
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
                        warn("found {s} at {} ({})\n", .{ name, col, col });
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
                    var ourVal = self.our[absCast(c)];
                    if (self.debug) {
                        warn("definite {s} is {} ({})\n", .{ name, c, ourVal });
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
                warn("no progress made\n", .{});
                std.os.exit(0);
            }
        }
    }
};

test "count1s" {
    try assertEq(@as(i64, 1), Mess.count1s(@as(i64, 1)));
    try assertEq(@as(i64, 2), Mess.count1s(@as(i64, 3)));
    try assertEq(@as(i64, 2), Mess.count1s(@as(i64, 6)));
}

test "examples" {
    const test1 = readChunks(test1file);
    const test2 = readChunks(test2file);
    const inp = readChunks(inputfile);

    var t1m = Mess.fromInput(test1, alloc) catch unreachable;
    try assertEq(@as(i64, 71), t1m.err);
    var inpm = Mess.fromInput(inp, alloc) catch unreachable;
    try assertEq(@as(i64, 21980), inpm.err);

    var t2m = Mess.fromInput(test2, alloc) catch unreachable;
    t2m.onlyDepart = false;
    const t2a = t2m.Solve() catch unreachable;
    try assertEq(@as(i64, 1716), t2a);
    const impa = inpm.Solve() catch unreachable;
    try assertEq(@as(i64, 1439429522627), impa);
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var chunks: [][]const u8 = undefined;
    var onlyDepart = true;
    if (args.next(alloc)) |_| {
        chunks = readChunks(test2file);
        onlyDepart = false;
    } else {
        chunks = readChunks(inputfile);
    }
    var m = try Mess.fromInput(chunks, alloc);
    m.onlyDepart = onlyDepart;
    try print("Part1: {}\n", .{m.err});
    try print("Part2: {}\n", .{m.Solve()});
}

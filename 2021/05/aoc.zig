usingnamespace @import("aoc-lib.zig");

const Diag = struct {
    lines: [][]const isize,
    p1: ?usize,
    p2: ?usize,

    const X1: usize = 0;
    const Y1: usize = 1;
    const X2: usize = 2;
    const Y2: usize = 3;

    fn parseLine(line: anytype, allocator: *Allocator) []const isize {
        var nums = ArrayList(isize).init(allocator);
        var it = tokenize(line, ", ->");
        while (it.next()) |is| {
            if (is.len == 0) {
                break;
            }
            const n = std.fmt.parseInt(isize, is, 10) catch {
                continue;
            };
            nums.append(n) catch unreachable;
        }
        return nums.toOwnedSlice();
    }

    pub fn fromInput(inp: anytype, allocator: *Allocator) !*Diag {
        var lines = try allocator.alloc([]const isize, inp.len);
        var diag = try alloc.create(Diag);
        for (inp) |line, i| {
            lines[i] = parseLine(line, allocator);
        }
        diag.lines = lines;
        return diag;
    }

    fn lineLength(line: []const isize) isize {
        const dx = line[X2] - line[X1];
        const dy = line[Y2] - line[Y1];
        const a = if (dx < 0) -dx else dx;
        const b = if (dy < 0) -dy else dy;
        return if (a > b) a else b;
    }

    fn inc(a: isize, b: isize) isize {
        if (a == b) {
            return 0;
        } else if (a < b) {
            return 1;
        } else {
            return -1;
        }
    }

    pub fn calc(self: *Diag) void {
        var m1 = AutoHashMap(isize, usize).init(alloc);
        var c1: usize = 0;
        var m2 = AutoHashMap(isize, usize).init(alloc);
        var c2: usize = 0;
        for (self.lines) |line| {
            var x = line[X1];
            var y = line[Y1];
            var dx: isize = inc(line[X1], line[X2]);
            var dy: isize = inc(line[Y1], line[Y2]);
            var len = lineLength(line);
            var i: usize = 0;
            while (true) {
                const k = x + y * (1 << 16);
                m2.put(k, (m2.get(k) orelse 0) + 1) catch unreachable;
                if (m2.get(k).? == 2) {
                    c2 += 1;
                }
                if (line[X1] == line[X2] or line[Y1] == line[Y2]) {
                    m1.put(k, (m1.get(k) orelse 0) + 1) catch unreachable;
                    if (m1.get(k).? == 2) {
                        c1 += 1;
                    }
                }
                x += dx;
                y += dy;
                i += 1;
                if (i > len) {
                    break;
                }
            }
        }
        self.p1 = c1;
        self.p2 = c2;
    }

    pub fn part1(self: *Diag) usize {
        if (self.p1) |p1| {
            return p1;
        }
        self.calc();
        return self.p1.?;
    }

    pub fn part2(self: *Diag) usize {
        if (self.p2) |p2| {
            return p2;
        }
        self.calc();
        return self.p2.?;
    }
};

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var t = Diag.fromInput(test1, alloc) catch unreachable;
    try assertEq(@as(usize, 5), t.part1());
    try assertEq(@as(usize, 12), t.part2());
    var ti = Diag.fromInput(inp, alloc) catch unreachable;
    try assertEq(@as(usize, 6005), ti.part1());
    try assertEq(@as(usize, 23864), ti.part2());
}

pub fn main() anyerror!void {
    var inp = readLines(input());
    var diag = try Diag.fromInput(inp, alloc);
    try print("Part1: {}\n", .{diag.part1()});
    try print("Part2: {}\n", .{diag.part2()});
}

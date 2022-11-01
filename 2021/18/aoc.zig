const std = @import("std");
const aoc = @import("aoc-lib.zig");

const SFDigit = struct {
    n: u16,
    depth: u8,
};

const SFNum = struct {
    const TQ = std.TailQueue(*SFDigit);
    nums: std.TailQueue(*SFDigit),
    alloc: std.mem.Allocator,

    pub fn fromInput(alloc: std.mem.Allocator, inp: []const u8) !*SFNum {
        var sf = try alloc.create(SFNum);
        sf.alloc = alloc;
        var nums = TQ{};
        var depth: u8 = 0;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            var ch = inp[i];
            switch (ch) {
                '[' => {
                    depth += 1;
                },
                ']' => {
                    depth -= 1;
                },
                ',' => {},
                else => {
                    var digit = try alloc.create(SFDigit);
                    digit.n = ch - '0';
                    if ('0' <= inp[i + 1] and inp[i + 1] <= '9') {
                        digit.n = 10 * digit.n + (inp[i + 1] - '0');
                        i += 1;
                    }
                    digit.depth = depth;
                    var node = try alloc.create(TQ.Node);
                    node.data = digit;
                    nums.append(node);
                },
            }
        }
        sf.nums = nums;
        return sf;
    }
    pub fn deinit(self: *SFNum) void {
        var it = self.nums.first;
        while (it) |node| {
            var next = node.next;
            self.alloc.destroy(node.data);
            self.alloc.destroy(node);
            it = next;
        }
        self.alloc.destroy(self);
    }
    pub fn clone(self: *SFNum) !*SFNum {
        var alloc = self.alloc;
        var sf = try alloc.create(SFNum);
        sf.alloc = alloc;
        var nums = TQ{};
        var it = self.nums.first;
        while (it) |node| : (it = node.next) {
            var digit = try alloc.create(SFDigit);
            digit.n = node.data.n;
            digit.depth = node.data.depth;
            var newNode = try alloc.create(TQ.Node);
            newNode.data = digit;
            nums.append(newNode);
        }
        sf.nums = nums;
        return sf;
    }
    pub fn split(self: *SFNum) !bool {
        var it = self.nums.first;
        while (it) |node| : (it = node.next) {
            if (node.data.n <= 9) {
                continue;
            }
            //aoc.print("spliting [{}@{}]\n", .{ node.data.n, node.data.depth });
            var down = node.data.n / 2;
            var up = node.data.n - down;
            node.data.n = down;
            node.data.depth += 1;
            var digit = try self.alloc.create(SFDigit);
            digit.n = up;
            digit.depth = node.data.depth;
            var newNode = try self.alloc.create(TQ.Node);
            newNode.data = digit;
            self.nums.insertAfter(node, newNode);
            return true;
        }
        return false;
    }
    pub fn explode(sf: *SFNum) !bool {
        var it = sf.nums.first;
        while (it) |node| : (it = node.next) {
            if (node.data.depth < 5) {
                continue;
            }
            var second = node.next orelse continue;
            if (second.data.depth != node.data.depth) {
                continue;
            }
            //aoc.print("exploding [{}@{}] and [{}@{}]\n", .{ node.data.n, node.data.depth, second.data.n, second.data.depth });
            if (node.prev) |prev| {
                prev.data.n += node.data.n;
            }
            if (second.next) |next| {
                next.data.n += second.data.n;
            }
            node.data.n = 0;
            node.data.depth -= 1;
            sf.nums.remove(second);
            sf.alloc.destroy(second.data);
            sf.alloc.destroy(second);
            return true;
        }
        return false;
    }
    pub fn reduce(sf: *SFNum) !void {
        while (true) {
            if (try sf.explode()) {
                continue;
            }
            if (try sf.split()) {
                continue;
            }
            return;
        }
    }
    pub fn add(sf: *SFNum, osf: *SFNum) !void {
        sf.nums.concatByMoving(&osf.nums);
        var it = sf.nums.first;
        while (it) |node| : (it = node.next) {
            node.data.depth += 1;
        }
        try sf.reduce();
    }
    pub fn dump(sf: *SFNum) void {
        var it = sf.nums.first;
        while (it) |node| : (it = node.next) {
            aoc.print("[{} @ {}] ", .{ node.data.n, node.data.depth });
        }
        aoc.print("\n", .{});
    }
    pub fn magnitude(sf: *SFNum) usize {
        while (sf.nums.first.? != sf.nums.last.?) {
            var first = sf.nums.first.?;
            var second = first.next.?;
            while (first.data.depth != second.data.depth) {
                //aoc.print("checking [{},{}] and [{},{}]\n", .{ first.data.depth, first.data.n, second.data.depth, second.data.n });
                first = second;
                second = second.next.?;
            }
            var mag = 3 * first.data.n + 2 * second.data.n;
            //aoc.print("found {} and {} => {}\n", .{ first.data.n, second.data.n, mag });
            first.data.n = mag;
            first.data.depth -= 1;
            sf.nums.remove(second);
            sf.alloc.destroy(second.data);
            sf.alloc.destroy(second);
        }
        return sf.nums.first.?.data.n;
    }
};

test "magnitude" {
    const TestCase = struct {
        data: []const u8,
        mag: usize,
    };
    var tests = [_]TestCase{
        TestCase{ .data = "[9,1]", .mag = 29 },
        TestCase{ .data = "[1,9]", .mag = 21 },
        TestCase{ .data = "[[9,1],[1,9]]", .mag = 129 },
        TestCase{ .data = "[[1,2],[[3,4],5]]", .mag = 143 },
        TestCase{ .data = "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", .mag = 1384 },
        TestCase{ .data = "[[[[1,1],[2,2]],[3,3]],[4,4]]", .mag = 445 },
        TestCase{ .data = "[[[[3,0],[5,3]],[4,4]],[5,5]]", .mag = 791 },
        TestCase{ .data = "[[[[5,0],[7,4]],[5,5]],[6,6]]", .mag = 1137 },
        TestCase{ .data = "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", .mag = 3488 },
        TestCase{ .data = "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]", .mag = 4140 },
    };
    for (tests) |tc| {
        var mt = try SFNum.fromInput(aoc.talloc, tc.data);
        defer mt.deinit();
        aoc.print("testing {s}\n", .{tc.data});
        try aoc.assertEq(tc.mag, mt.magnitude());
    }
}

test "explode" {
    const TestCase = struct {
        data: []const u8,
        mag: usize,
    };
    var tests = [_]TestCase{
        TestCase{ .data = "[[[[[9,8],1],2],3],4]", .mag = 548 },
        TestCase{ .data = "[7,[6,[5,[4,[3,2]]]]]", .mag = 285 },
        TestCase{ .data = "[[6,[5,[4,[3,2]]]],1]", .mag = 402 },
        TestCase{ .data = "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", .mag = 769 },
        TestCase{ .data = "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", .mag = 633 },
    };
    for (tests) |tc| {
        var mt = try SFNum.fromInput(aoc.talloc, tc.data);
        defer mt.deinit();
        mt.dump();
        try aoc.assertEq(true, try mt.explode());
        mt.dump();
        try aoc.assertEq(tc.mag, mt.magnitude());
    }
}

test "split" {
    const TestCase = struct {
        data: []const u8,
        mag: usize,
    };
    var tests = [_]TestCase{
        TestCase{ .data = "[[[[0,7],4],[15,[0,13]]],[1,1]]", .mag = 1438 },
        TestCase{ .data = "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", .mag = 1894 },
    };
    for (tests) |tc| {
        var mt = try SFNum.fromInput(aoc.talloc, tc.data);
        defer mt.deinit();
        try aoc.assertEq(true, try mt.split());
        try aoc.assertEq(tc.mag, mt.magnitude());
    }
}

test "add" {
    const TestCase = struct {
        sf1: []const u8,
        sf2: []const u8,
        mag: usize,
    };
    var tests = [_]TestCase{
        TestCase{
            .sf1 = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
            .sf2 = "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
            .mag = 2736,
        },
        TestCase{
            .sf1 = "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]",
            .sf2 = "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
            .mag = 4014,
        },
        TestCase{
            .sf1 = "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]",
            .sf2 = "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
            .mag = 4105,
        },
        TestCase{
            .sf1 = "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]",
            .sf2 = "[7,[5,[[3,8],[1,4]]]]",
            .mag = 4293,
        },
    };
    for (tests) |tc| {
        var sf1 = try SFNum.fromInput(aoc.talloc, tc.sf1);
        defer sf1.deinit();
        var sf2 = try SFNum.fromInput(aoc.talloc, tc.sf2);
        defer sf2.deinit();
        try sf1.add(sf2);
        try aoc.assertEq(tc.mag, sf1.magnitude());
    }
}

test "parts" {
    const TestCase = struct {
        file: []const u8,
        res: [2]usize,
    };
    var tests = [_]TestCase{
        TestCase{ .file = aoc.test0file, .res = [2]usize{ 3488, 3805 } },
        TestCase{ .file = aoc.test1file, .res = [2]usize{ 4140, 3993 } },
        TestCase{ .file = aoc.inputfile, .res = [2]usize{ 3987, 4500 } },
    };
    for (tests) |tc| {
        var res = try parts(aoc.talloc, tc.file);
        try aoc.assertEq(tc.res, res);
    }
}

fn parts(alloc: std.mem.Allocator, inp: []const u8) ![2]usize {
    var sfs = std.ArrayList(*SFNum).init(alloc);
    defer {
        for (sfs.items) |it| {
            it.deinit();
        }
        sfs.deinit();
    }
    var it = std.mem.tokenize(u8, inp, "\n");
    while (it.next()) |line| {
        if (line.len == 0) {
            break;
        }
        try sfs.append(try SFNum.fromInput(alloc, line));
    }
    var i: usize = 1;
    var sf = try sfs.items[0].clone();
    defer sf.deinit();
    while (i < sfs.items.len) : (i += 1) {
        var o = try sfs.items[i].clone();
        defer o.deinit();
        try sf.add(o);
    }
    var p1 = sf.magnitude();
    var p2: usize = 0;
    i = 0;
    while (i < sfs.items.len) : (i += 1) {
        var j = i + 1;
        while (j < sfs.items.len) : (j += 1) {
            var ab = try sfs.items[i].clone();
            defer ab.deinit();
            var b = try sfs.items[j].clone();
            defer b.deinit();
            try ab.add(b);
            var mag = ab.magnitude();
            if (mag > p2) {
                p2 = mag;
            }
            var ba = try sfs.items[j].clone();
            defer ba.deinit();
            var a = try sfs.items[i].clone();
            defer a.deinit();
            try ba.add(a);
            mag = ba.magnitude();
            if (mag > p2) {
                p2 = mag;
            }
        }
    }
    return [2]usize{ p1, p2 };
}
var buf: [20 * 1024 * 1024]u8 = undefined;
fn day(inp: []const u8, bench: bool) anyerror!void {
    var alloc = std.heap.FixedBufferAllocator.init(&buf);
    var p = try parts(alloc.allocator(), inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

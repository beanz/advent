const std = @import("std");
const aoc = @import("aoc-lib.zig");

const HH = struct {
    pub const Op = enum(u8) { acc, jmp, nop };
    const Inst = struct { op: Op, arg: i64 };
    code: []Inst,
    ip: isize = 0,
    acc: i64 = 0,
    alloc: std.mem.Allocator,

    pub fn fromInput(inp: anytype, alloc: std.mem.Allocator) !*HH {
        var code = try alloc.alloc(Inst, inp.len);
        var hh = try alloc.create(HH);
        for (inp, 0..) |line, ip| {
            var it = std.mem.split(u8, line, " ");
            const opstr = it.next().?;
            const arg = try aoc.parseInt(i64, it.next().?, 10);
            var op: Op = undefined;
            switch (opstr[0]) {
                'a' => {
                    op = .acc;
                },
                'n' => {
                    op = .nop;
                },
                'j' => {
                    op = .jmp;
                },
                else => {
                    unreachable;
                },
            }
            code[ip].op = op;
            code[ip].arg = arg;
        }
        hh.code = code;
        hh.ip = 0;
        hh.acc = 0;
        hh.alloc = alloc;
        return hh;
    }

    pub fn deinit(self: *HH) void {
        self.alloc.free(self.code);
        self.alloc.destroy(self);
    }

    pub fn clone(self: *HH) !*HH {
        var code = try self.alloc.alloc(Inst, self.code.len);
        var hh = try self.alloc.create(HH);
        for (self.code, 0..) |inst, ip| {
            code[ip].op = inst.op;
            code[ip].arg = inst.arg;
        }
        hh.code = code;
        hh.ip = 0;
        hh.acc = 0;
        hh.alloc = self.alloc;
        return hh;
    }

    pub fn reset(self: *HH) void {
        self.ip = 0;
        self.acc = 0;
    }

    pub fn run(self: *HH) void {
        var seen = std.AutoHashMap(isize, bool).init(self.alloc);
        defer seen.deinit();
        while (self.ip < self.code.len) : (self.ip += 1) {
            if (seen.contains(self.ip)) {
                break;
            }
            seen.put(self.ip, true) catch unreachable;
            const inst = self.code[std.math.absCast(self.ip)];
            switch (inst.op) {
                Op.acc => {
                    self.acc += inst.arg;
                },
                Op.jmp => {
                    self.ip += inst.arg - 1;
                },
                Op.nop => {},
            }
        }
    }

    pub fn fixOp(self: *HH, ip: usize) bool {
        if (self.code[ip].op == Op.jmp) {
            self.code[ip].op = Op.nop;
            return true;
        } else if (self.code[ip].op == Op.nop) {
            self.code[ip].op = Op.jmp;
            return true;
        }
        return false;
    }
};

test "examples" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(i64, 5), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(i64, 8), part2(aoc.talloc, test1));

    try aoc.assertEq(@as(i64, 1614), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(i64, 1260), part2(aoc.talloc, inp));
}

fn part1(alloc: std.mem.Allocator, inp: anytype) i64 {
    var hh = HH.fromInput(inp, alloc) catch unreachable;
    defer hh.deinit();
    hh.run();
    return hh.acc;
}

fn part2(alloc: std.mem.Allocator, inp: anytype) i64 {
    var hh = HH.fromInput(inp, alloc) catch unreachable;
    defer hh.deinit();
    for (hh.code, 0..) |_, ip| {
        var mhh = hh.clone() catch unreachable;
        defer mhh.deinit();
        if (!mhh.fixOp(ip)) {
            continue;
        }
        mhh.run();
        if (mhh.ip >= hh.code.len) {
            return mhh.acc;
        }
    }
    return 0;
}

fn day08(inp: []const u8, bench: bool) anyerror!void {
    var spec = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(spec);
    var p1 = part1(aoc.halloc, spec);
    var p2 = part2(aoc.halloc, spec);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day08);
}

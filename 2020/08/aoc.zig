const std = @import("std");
const math = std.math;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

const HH = struct {
    pub const Op = enum(u8) { acc, jmp, nop };
    const Inst = struct {
        op: Op, arg: i64
    };
    code: []Inst,
    ip: isize = 0,
    acc: i64 = 0,

    pub fn fromInput(inp: anytype, allocator: *std.mem.Allocator) !*HH {
        var code = try allocator.alloc(Inst, inp.items.len);
        var hh = try alloc.create(HH);
        for (inp.items) |line, ip| {
            var it = std.mem.split(line, " ");
            const opstr = it.next().?;
            const arg = try std.fmt.parseInt(i64, it.next().?, 10);
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
        return hh;
    }

    pub fn clone(self: *HH, allocator: *std.mem.Allocator) !*HH {
        var code = try allocator.alloc(Inst, self.code.len);
        var hh = try alloc.create(HH);
        for (self.code) |inst, ip| {
            code[ip].op = inst.op;
            code[ip].arg = inst.arg;
        }
        hh.code = code;
        hh.ip = 0;
        hh.acc = 0;
        return hh;
    }

    pub fn reset(self: *HH) void {
        hh.ip = 0;
        hh.acc = 0;
    }

    pub fn run(self: *HH) void {
        var seen = std.AutoHashMap(isize, bool).init(alloc);
        while (self.ip < self.code.len) {
            if (seen.contains(self.ip)) {
                break;
            }
            seen.put(self.ip, true) catch unreachable;
            const inst = self.code[math.absCast(self.ip)];
            switch (inst.op) {
                Op.acc => {
                    self.acc += inst.arg;
                },
                Op.jmp => {
                    self.ip += inst.arg - 1;
                },
                Op.nop => {},
            }
            self.ip += 1;
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
    const test1 = try aoc.readLines(test1file);
    const inp = try aoc.readLines(input);

    var r: i64 = 5;
    assertEq(r, part1(test1));
    r = 8;
    assertEq(r, part2(test1));

    r = 1614;
    assertEq(r, part1(inp));
    r = 1260;
    assertEq(r, part2(inp));
}

fn part1(inp: anytype) i64 {
    var hh = HH.fromInput(inp, alloc) catch unreachable;
    hh.run();
    return hh.acc;
}

fn part2(inp: anytype) i64 {
    var hh = HH.fromInput(inp, alloc) catch unreachable;
    for (hh.code) |inst, ip| {
        var mhh = hh.clone(alloc) catch unreachable;
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

pub fn main() anyerror!void {
    var spec = try aoc.readLines(input);
    try out.print("Part1: {}\n", .{part1(spec)});
    try out.print("Part2: {}\n", .{part2(spec)});
}
const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Signal = struct {
    patterns: [][]const u8,
    output: [][]const u8,
    map: [7]u8,
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, line: []const u8) !*Signal {
        var sig = try alloc.create(Signal);
        sig.alloc = alloc;
        var patternOutput = std.mem.split(u8, line, " | ");
        const patterns = patternOutput.next().?;
        const output = patternOutput.next().?;
        sig.patterns = try aoc.splitToOwnedSlice(alloc, patterns, " ");
        sig.output = try aoc.splitToOwnedSlice(alloc, output, " ");
        sig.initMap();
        return sig;
    }
    pub fn deinit(self: *Signal) void {
        self.alloc.free(self.patterns);
        self.alloc.free(self.output);
        self.alloc.destroy(self);
    }

    pub fn known(self: *Signal) usize {
        var c: usize = 0;
        for (self.output) |o| {
            switch (o.len) {
                2, 4, 3, 7 => {
                    c += 1;
                },
                else => {},
            }
        }
        return c;
    }

    pub fn initMap(self: *Signal) void {
        var occur = [7]u8{ 0, 0, 0, 0, 0, 0, 0 };
        var occur6 = [7]u8{ 0, 0, 0, 0, 0, 0, 0 };
        for (self.patterns) |p| {
            for (p) |ch| {
                occur[@as(usize, ch - 'a')] += 1;
                if (p.len == 6) {
                    occur6[@as(usize, ch - 'a')] += 1;
                }
            }
        }
        //aoc.print("{any} {any}\n", .{ occur, occur6 }) catch unreachable;
        for (occur, 0..) |o, i| {
            switch (o) {
                6 => {
                    self.map[i] = @as(u8, 'b');
                },
                4 => {
                    self.map[i] = @as(u8, 'e');
                },
                9 => {
                    self.map[i] = @as(u8, 'f');
                },
                7 => {
                    if (occur6[i] == 2) {
                        self.map[i] = @as(u8, 'd');
                    } else {
                        self.map[i] = @as(u8, 'g');
                    }
                },
                8 => {
                    if (occur6[i] == 2) {
                        self.map[i] = @as(u8, 'c');
                    } else {
                        self.map[i] = @as(u8, 'a');
                    }
                },
                else => unreachable,
            }
        }
        //aoc.print("{any}\n", .{self.map}) catch unreachable;
    }

    pub fn value(self: *Signal) usize {
        return 1000 * self.digitValue(0) +
            100 * self.digitValue(1) +
            10 * self.digitValue(2) +
            self.digitValue(3);
    }

    pub fn digitValue(self: *Signal, i: usize) usize {
        switch (self.output[i].len) {
            2 => {
                return 1;
            },
            4 => {
                return 4;
            },
            3 => {
                return 7;
            },
            7 => {
                return 8;
            },
            5 => {
                if (self.digitContains(i, 'e')) {
                    return 2;
                }
                if (self.digitContains(i, 'c')) {
                    return 3;
                }
                return 5;
            },
            6 => {
                if (!self.digitContains(i, 'c')) {
                    return 6;
                }
                if (self.digitContains(i, 'e')) {
                    return 0;
                }
                return 9;
            },
            else => unreachable,
        }
    }

    pub fn digitContains(self: *Signal, i: usize, tch: u8) bool {
        for (self.output[i]) |ch| {
            if (self.map[ch - 'a'] == tch) {
                return true;
            }
        }
        return false;
    }
};

test "signal" {
    var sig = try Signal.init(aoc.talloc, "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb");
    defer sig.deinit();
    try aoc.assertEq(@as(usize, 4), sig.known());
    try aoc.assertEq(@as(usize, 8418), sig.value());
    try aoc.assertEq(true, sig.digitContains(0, 'a'));
    try aoc.assertEq(true, sig.digitContains(0, 'f'));
    try aoc.assertEq(false, sig.digitContains(2, 'a'));
    try aoc.assertEq(true, sig.digitContains(2, 'c'));
    try aoc.assertEq(true, sig.digitContains(2, 'f'));

    var ex = try Signal.init(aoc.talloc, "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf");
    defer ex.deinit();
    try aoc.assertEq(@as(usize, 0), ex.known());
    try aoc.assertEq(@as(usize, 5353), ex.value());
}

const Signals = struct {
    signals: []*Signal,
    map: [7]u8,
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, inp: []const u8) !*Signals {
        var self = try alloc.create(Signals);
        self.alloc = alloc;
        var sigs = std.ArrayList(*Signal).init(alloc);
        const lines = try aoc.splitToOwnedSlice(alloc, inp, "\n");
        defer alloc.free(lines);
        for (lines) |l| {
            const sig = try Signal.init(alloc, l);
            try sigs.append(sig);
        }
        self.signals = try sigs.toOwnedSlice();
        return self;
    }

    pub fn deinit(self: *Signals) void {
        for (self.signals) |sig| {
            sig.deinit();
        }
        self.alloc.free(self.signals);
        self.alloc.destroy(self);
    }

    pub fn parts(self: *Signals) ![2]usize {
        var r = [2]usize{ 0, 0 };
        for (self.signals) |sig| {
            r[0] += sig.known();
            r[1] += sig.value();
        }
        return r;
    }
};

test "examples" {
    var t = try Signals.init(aoc.talloc, aoc.test1file);
    defer t.deinit();
    const p = try t.parts();
    try aoc.assertEq(@as(u64, 26), p[0]);
    try aoc.assertEq(@as(u64, 61229), p[1]);

    var ti = try Signals.init(aoc.talloc, aoc.inputfile);
    defer ti.deinit();
    const pi = try ti.parts();
    try aoc.assertEq(@as(u64, 504), pi[0]);
    try aoc.assertEq(@as(u64, 1073431), pi[1]);
}

fn day08(inp: []const u8, bench: bool) anyerror!void {
    var s = try Signals.init(aoc.halloc, inp);
    const p = try s.parts();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day08);
}

const std = @import("std");
const aoc = @import("aoc-lib.zig");
fn readBits(comptime T: type, bits: []const u1, i: *usize) T {
    const bit_count = @typeInfo(T).Int.bits;
    var j: usize = 0;
    var v: T = 0;
    if (bit_count == 1) {
        v = @as(T, bits[i.*]);
        i.* += 1;
        return v;
    }
    while (j < bit_count) : (j += 1) {
        v = (v << 1) | @as(T, bits[i.*]);
        i.* += 1;
    }
    return v;
}

pub fn readPacket(alloc: std.mem.Allocator, bits: []const u1, i: *usize) anyerror![2]usize {
    var ver: u3 = readBits(u3, bits, i);
    var kind: u3 = readBits(u3, bits, i);
    if (kind == 4) {
        var n: usize = 0;
        while (true) {
            var a = readBits(u5, bits, i);
            n = (n << 4) + @as(usize, a & 0xf);
            if (a <= 0xf) {
                break;
            }
        }
        return [2]usize{ ver, n };
    }
    var vs = @as(usize, ver);
    var argsL = std.ArrayList(usize).init(alloc);
    defer argsL.deinit();
    var lti = readBits(u1, bits, i);
    if (lti == 0) { // 15-bit
        var l = readBits(u15, bits, i);
        var end = i.* + l;
        while (i.* < end) {
            var sub = try readPacket(alloc, bits, i);
            vs += sub[0];
            try argsL.append(sub[1]);
        }
    } else {
        var l = readBits(u11, bits, i);
        var j: usize = 0;
        while (j < l) : (j += 1) {
            var sub = try readPacket(alloc, bits, i);
            vs += sub[0];
            try argsL.append(sub[1]);
        }
    }
    var args = argsL.items;
    var res: usize = 0;
    switch (kind) {
        0 => {
            var k: usize = 0;
            while (k < args.len) : (k += 1) {
                res += args[k];
            }
        },
        1 => {
            res = 1;
            var k: usize = 0;
            while (k < args.len) : (k += 1) {
                res *= args[k];
            }
        },
        2 => {
            res = args[0];
            var k: usize = 1;
            while (k < args.len) : (k += 1) {
                if (res > args[k]) {
                    res = args[k];
                }
            }
        },
        3 => {
            res = args[0];
            var k: usize = 1;
            while (k < args.len) : (k += 1) {
                if (res < args[k]) {
                    res = args[k];
                }
            }
        },
        5 => {
            if (args[0] > args[1]) {
                res = 1;
            } else {
                res = 0;
            }
        },
        6 => {
            if (args[0] < args[1]) {
                res = 1;
            } else {
                res = 0;
            }
        },
        7 => {
            if (args[0] == args[1]) {
                res = 1;
            } else {
                res = 0;
            }
        },
        else => {
            unreachable;
        },
    }
    return [2]usize{ vs, res };
}

pub fn parts(alloc: std.mem.Allocator, inp: []const u8) ![2]usize {
    var bits = try alloc.alloc(u1, inp.len * 4);
    @memset(bits[0..], 0);
    defer alloc.free(bits);
    var i: usize = 0;
    while (i < (inp.len - 1)) : (i += 1) {
        var v = inp[i] - '0';
        if (v > 9) {
            v -= 7;
        }
        if ((v & 0b0001) != 0) bits[i * 4 + 3] = 1;
        if ((v & 0b0010) != 0) bits[i * 4 + 2] = 1;
        if ((v & 0b0100) != 0) bits[i * 4 + 1] = 1;
        if ((v & 0b1000) != 0) bits[i * 4 + 0] = 1;
    }
    i = 0;
    return readPacket(alloc, bits, &i);
}

test "part1" {
    var t1a = try parts(aoc.talloc, test1afile);
    try aoc.assertEq(@as(usize, 6), t1a[0]);
    var t1b = try parts(aoc.talloc, test1bfile);
    try aoc.assertEq(@as(usize, 9), t1b[0]);
    var t1c = try parts(aoc.talloc, test1cfile);
    try aoc.assertEq(@as(usize, 14), t1c[0]);
    var t1d = try parts(aoc.talloc, test1dfile);
    try aoc.assertEq(@as(usize, 16), t1d[0]);
    var t1e = try parts(aoc.talloc, test1efile);
    try aoc.assertEq(@as(usize, 12), t1e[0]);
    var t1f = try parts(aoc.talloc, test1ffile);
    try aoc.assertEq(@as(usize, 23), t1f[0]);
    var t1g = try parts(aoc.talloc, test1gfile);
    try aoc.assertEq(@as(usize, 31), t1g[0]);
    var t2a = try parts(aoc.talloc, test2afile);
    try aoc.assertEq(@as(usize, 14), t2a[0]);
    var t2b = try parts(aoc.talloc, test2bfile);
    try aoc.assertEq(@as(usize, 8), t2b[0]);
    var t2c = try parts(aoc.talloc, test2cfile);
    try aoc.assertEq(@as(usize, 15), t2c[0]);
    var t2d = try parts(aoc.talloc, test2dfile);
    try aoc.assertEq(@as(usize, 11), t2d[0]);
    var t2e = try parts(aoc.talloc, test2efile);
    try aoc.assertEq(@as(usize, 13), t2e[0]);
    var t2f = try parts(aoc.talloc, test2ffile);
    try aoc.assertEq(@as(usize, 19), t2f[0]);
    var t2g = try parts(aoc.talloc, test2gfile);
    try aoc.assertEq(@as(usize, 16), t2g[0]);
    var t2h = try parts(aoc.talloc, test2hfile);
    try aoc.assertEq(@as(usize, 20), t2h[0]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 951), r[0]);
}

test "part2" {
    var t1a = try parts(aoc.talloc, "D2FE28\n");
    try aoc.assertEq(@as(usize, 2021), t1a[1]);
    var t1b = try parts(aoc.talloc, "38006F45291200\n");
    try aoc.assertEq(@as(usize, 1), t1b[1]);
    var t1c = try parts(aoc.talloc, "EE00D40C823060\n");
    try aoc.assertEq(@as(usize, 3), t1c[1]);
    var t1d = try parts(aoc.talloc, "8A004A801A8002F478\n");
    try aoc.assertEq(@as(usize, 15), t1d[1]);
    var t1e = try parts(aoc.talloc, "620080001611562C8802118E34\n");
    try aoc.assertEq(@as(usize, 46), t1e[1]);
    var t1f = try parts(aoc.talloc, "C0015000016115A2E0802F182340\n");
    try aoc.assertEq(@as(usize, 46), t1f[1]);
    var t1g = try parts(aoc.talloc, "A0016C880162017C3686B18A3D4780\n");
    try aoc.assertEq(@as(usize, 54), t1g[1]);
    var t2a = try parts(aoc.talloc, "C200B40A82\n");
    try aoc.assertEq(@as(usize, 3), t2a[1]);
    var t2b = try parts(aoc.talloc, "04005AC33890\n");
    try aoc.assertEq(@as(usize, 54), t2b[1]);
    var t2c = try parts(aoc.talloc, "880086C3E88112\n");
    try aoc.assertEq(@as(usize, 7), t2c[1]);
    var t2d = try parts(aoc.talloc, "CE00C43D881120\n");
    try aoc.assertEq(@as(usize, 9), t2d[1]);
    var t2e = try parts(aoc.talloc, "D8005AC2A8F0\n");
    try aoc.assertEq(@as(usize, 1), t2e[1]);
    var t2f = try parts(aoc.talloc, "F600BC2D8F\n");
    try aoc.assertEq(@as(usize, 0), t2f[1]);
    var t2g = try parts(aoc.talloc, "9C005AC2F8F0\n");
    try aoc.assertEq(@as(usize, 0), t2g[1]);
    var t2h = try parts(aoc.talloc, "9C0141080250320F1802104A08\n");
    try aoc.assertEq(@as(usize, 1), t2h[1]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 902198718880), r[1]);
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(aoc.halloc, inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

pub const test1afile = @embedFile("test1a.txt");
pub const test1bfile = @embedFile("test1b.txt");
pub const test1cfile = @embedFile("test1c.txt");
pub const test1dfile = @embedFile("test1d.txt");
pub const test1efile = @embedFile("test1e.txt");
pub const test1ffile = @embedFile("test1f.txt");
pub const test1gfile = @embedFile("test1g.txt");
pub const test2afile = @embedFile("test2a.txt");
pub const test2bfile = @embedFile("test2b.txt");
pub const test2cfile = @embedFile("test2c.txt");
pub const test2dfile = @embedFile("test2d.txt");
pub const test2efile = @embedFile("test2e.txt");
pub const test2ffile = @embedFile("test2f.txt");
pub const test2gfile = @embedFile("test2g.txt");
pub const test2hfile = @embedFile("test2h.txt");

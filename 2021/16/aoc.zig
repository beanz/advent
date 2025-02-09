const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const bits = parse: {
        var bits: [1024]u8 = undefined;
        var l: usize = 0;
        var i: usize = 0;
        while (i + 1 < inp.len) : (i += 2) {
            var v: u8 = switch (inp[i]) {
                '0'...'9' => |ch| ch & 0xf,
                'A'...'F' => |ch| ch - 'A' + 10,
                else => unreachable,
            };
            v <<= 4;
            v += switch (inp[i + 1]) {
                '0'...'9' => |ch| ch & 0xf,
                'A'...'F' => |ch| ch - 'A' + 10,
                else => unreachable,
            };
            bits[l] = v;
            l += 1;
        }
        break :parse bits[0..l];
    };
    var stream = Stream{ .b = bits, .iBit = 0 };
    return try stream.eval();
}

const Stream = struct {
    b: []const u8,
    iBit: usize,
    fn num(self: *Stream, n: u4) u16 {
        var v: u16 = 0;
        var r = n;
        while (r > 0) {
            const rb: u4 = @intCast(8 - (self.iBit & 0x7));
            const i = self.iBit >> 3;
            const bits: u16 = @intCast(self.b[i]);
            if (r <= rb) {
                const s = @as(u4, @intCast(rb - @as(u4, @intCast(r))));
                v <<= r;
                v += (bits >> s) & ((@as(u16, @intCast(1)) << r) - 1);
                self.iBit += r;
                r = 0;
            } else {
                const s = @as(u4, @intCast(rb));
                v <<= s;
                v += bits & ((@as(u16, 1) << s) - 1);
                r -= s;
                self.iBit += rb;
            }
        }
        return v;
    }
    fn eval(self: *Stream) ![2]usize {
        var ver: usize = @intCast(self.num(3));
        const kind = self.num(3);
        if (kind == 4) {
            var n: usize = 0;
            while (true) {
                const a = self.num(5);
                n = (n << 4) + (a & 0xf);
                if (a <= 0xf) {
                    break;
                }
            }
            return [2]usize{ ver, n };
        }
        var s = try std.BoundedArray(usize, 64).init(0);
        if (self.num(1) == 0) {
            // 15-bit
            const l = self.num(15);
            const end = self.iBit + @as(usize, @intCast(l));
            while (self.iBit < end) {
                const sub = try self.eval();
                ver += sub[0];
                try s.append(sub[1]);
            }
        } else {
            const l = self.num(11);
            for (0..l) |_| {
                const sub = try self.eval();
                ver += sub[0];
                try s.append(sub[1]);
            }
        }
        const args = s.slice();
        const v = switch (kind) {
            0 => aoc.sliceSum(usize, args),
            1 => aoc.sliceProduct(usize, args),
            2 => std.mem.min(usize, args),
            3 => std.mem.max(usize, args),
            5 => @as(usize, @intFromBool(args[0] > args[1])),
            6 => @as(usize, @intFromBool(args[0] < args[1])),
            7 => @as(usize, @intFromBool(args[0] == args[1])),
            else => unreachable,
        };
        return [2]usize{ ver, v };
    }
};

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

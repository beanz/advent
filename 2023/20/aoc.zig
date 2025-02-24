const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const BCAST: u6 = 0;
    var flipflop: u64 = 0;
    var children: [64]u64 = .{0} ** 64;
    {
        var n: u6 = 1;
        var ids: [676]?u6 = .{null} ** 676;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const id = switch (inp[i]) {
                'b' => bc: {
                    i += 13;
                    break :bc BCAST;
                },
                else => el: {
                    const isFlipFlop = inp[i] == '%';
                    i += 1; // kind?
                    const k = @as(usize, @intCast(inp[i] - 'a')) * 26 + @as(usize, @intCast(inp[i + 1] - 'a'));
                    if (ids[k] == null) {
                        ids[k] = n;
                        n += 1;
                    }
                    const id = ids[k].?;
                    if (isFlipFlop) {
                        flipflop |= @as(u64, 1) << id;
                    }
                    i += 4;
                    break :el id;
                },
            };
            while (inp[i] != '\n') {
                i += 2;
                const k = @as(usize, @intCast(inp[i] - 'a')) * 26 + @as(usize, @intCast(inp[i + 1] - 'a'));
                if (ids[k] == null) {
                    ids[k] = n;
                    n += 1;
                }
                i += 2;
                const cid = ids[k].?;
                children[id] |= @as(u64, 1) << cid;
            }
        }
    }
    var nums: [4]usize = undefined;
    {
        var i: usize = 0;
        var it = aoc.biterator(u64, children[BCAST]);
        while (it.next()) |child| {
            var num: usize = 0;
            var bit: usize = 1;
            var cur = child;
            while (true) {
                var cit = aoc.biterator(u64, children[cur]);
                if (@popCount(children[cur]) == 2) {
                    const a = cit.next().?;
                    const ba = @as(usize, 1) << @as(u6, @intCast(a));
                    const b = cit.next().?;
                    if (flipflop & ba != 0) {
                        cur = a;
                    } else {
                        cur = b;
                    }
                    num |= bit;
                } else {
                    const next = cit.next().?;
                    const bc = @as(usize, 1) << @as(u6, @intCast(next));
                    if (flipflop & bc != 0) {
                        cur = next;
                    } else {
                        num |= bit;
                        break;
                    }
                }
                bit <<= 1;
            }
            nums[i] = num;
            i += 1;
        }
    }
    var low: usize = 5000;
    var high: usize = 0;
    {
        const chains = cinit: {
            var c: [4]usize = undefined;
            for (0..4) |i| {
                c[i] = 13 - @popCount(nums[i]);
            }
            break :cinit c;
        };
        for (0..1000) |n| {
            const rising = (~n) & (n + 1);
            high += 4 * @popCount(rising);
            const falling = n & ~(n + 1);
            low += 4 * @popCount(falling);
            for (nums, chains) |num, count| {
                const r = @popCount(rising & num);
                high += r * (count + 3);
                low += r;
                const f = @popCount(falling & num);
                high += f * (count + 2);
                low += 2 * f;
            }
        }
    }
    return [2]usize{ low * high, nums[0] * nums[1] * nums[2] * nums[3] };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}

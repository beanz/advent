const std = @import("std");
const Args = std.process.args;
const warn = std.debug.warn;
const aoc = @import("aoc-lib.zig");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;

const input = @embedFile("input.txt");
const test1file = @embedFile("test1.txt");
const test2file = @embedFile("test2.txt");
const stdout = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

fn part1(in: std.ArrayListAligned([]const u8, null)) usize {
    var mem = std.AutoHashMap(usize, usize).init(alloc);
    var mask0: usize = undefined;
    var mask1: usize = undefined;
    for (in.items) |line| {
        if (line[1] == 'a') { // mask line
            mask0 = 0;
            mask1 = 0;
            for (line[7..]) |ch| {
                mask0 <<= 1;
                mask1 <<= 1;
                if (ch == '0') {
                    mask0 += 1;
                } else if (ch == '1') {
                    mask1 += 1;
                }
            }
            mask0 ^= 0xfffffffff;
            //warn("1s mask = {}\n0s mask = {}\n", .{ mask1, mask0 });
        } else { // mem line
            var vit = std.mem.split(line, " = ");
            const astr = vit.next().?;
            var val = std.fmt.parseUnsigned(usize, vit.next().?, 10) catch unreachable;
            const addr = std.fmt.parseUnsigned(usize, astr[4 .. astr.len - 1], 10) catch unreachable;
            //warn("addr={} value={}\n", .{ addr, val });
            val &= mask0;
            val |= mask1;
            mem.put(addr, val) catch unreachable;
        }
    }
    var sum: usize = 0;
    var it = mem.iterator();
    while (it.next()) |entry| {
        sum += entry.value;
    }
    return sum;
}

fn part2(in: std.ArrayListAligned([]const u8, null)) usize {
    var mem = std.AutoHashMap(usize, usize).init(alloc);
    var mask1: usize = undefined;
    var maskx: usize = undefined;
    for (in.items) |line| {
        if (line[1] == 'a') { // mask line
            mask1 = 0;
            maskx = 0;
            for (line[7..]) |ch| {
                mask1 <<= 1;
                maskx <<= 1;
                if (ch == '1') {
                    mask1 += 1;
                } else if (ch == 'X') {
                    maskx += 1;
                }
            }
            //warn("1s mask = {}\nXs mask = {}\n", .{ mask1, maskx });
        } else { // mem line
            var vit = std.mem.split(line, " = ");
            const astr = vit.next().?;
            const val = std.fmt.parseUnsigned(usize, vit.next().?, 10) catch unreachable;
            var addr = std.fmt.parseUnsigned(usize, astr[4 .. astr.len - 1], 10) catch unreachable;
            //warn("addr={} value={}\n", .{ addr, val });
            addr |= mask1;
            var addrs = std.ArrayList(usize).init(alloc);
            addrs.append(addr) catch unreachable;
            var m: usize = (1 << 35);
            while (m >= 1) {
                if ((m & maskx) != 0) {
                    for (addrs.items) |a| {
                        if ((a & m) != 0) { // existing entry has 1
                            addrs.append(a & (0xfffffffff ^ m)) catch unreachable;
                        } else { // existing entry has 0
                            addrs.append(a | m) catch unreachable;
                        }
                    }
                }
                m >>= 1;
            }
            for (addrs.items) |a| {
                mem.put(a, val) catch unreachable;
            }
        }
    }
    var sum: usize = 0;
    var it = mem.iterator();
    while (it.next()) |entry| {
        sum += entry.value;
    }
    return sum;
}

test "examples" {
    const test1 = try aoc.readLines(test1file);
    const test2 = try aoc.readLines(test2file);
    const inp = try aoc.readLines(input);

    var r: usize = 165;
    assertEq(r, part1(test1));
    r = 51;
    assertEq(r, part1(test2));
    r = 4297467072083;
    assertEq(r, part1(inp));

    r = 208;
    assertEq(r, part2(test2));
    r = 5030603328768;
    assertEq(r, part2(inp));
}

pub fn main() anyerror!void {
    var args = Args();
    const arg0 = args.next(alloc).?;
    var lines: std.ArrayListAligned([]const u8, null) = undefined;
    if (args.next(alloc)) |_| {
        lines = try aoc.readLines(test1file);
    } else {
        lines = try aoc.readLines(input);
    }
    try stdout.print("Part1: {}\n", .{part1(lines)});
    try stdout.print("Part2: {}\n", .{part2(lines)});
}

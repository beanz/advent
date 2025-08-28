const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn part1(alloc: std.mem.Allocator, in: [][]u8) usize {
    var mem = std.AutoHashMap(usize, usize).init(alloc);
    defer mem.deinit();
    var mask0: usize = undefined;
    var mask1: usize = undefined;
    for (in) |line| {
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
            var vit = std.mem.splitSequence(u8, line, " = ");
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
        sum += entry.value_ptr.*;
    }
    return sum;
}

fn part2(alloc: std.mem.Allocator, in: [][]u8) usize {
    var mem = std.AutoHashMap(usize, usize).init(alloc);
    defer mem.deinit();
    var mask1: usize = undefined;
    var maskx: usize = undefined;
    for (in) |line| {
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
            var vit = std.mem.splitSequence(u8, line, " = ");
            const astr = vit.next().?;
            const val = std.fmt.parseUnsigned(usize, vit.next().?, 10) catch unreachable;
            var addr = std.fmt.parseUnsigned(usize, astr[4 .. astr.len - 1], 10) catch unreachable;
            //warn("addr={} value={}\n", .{ addr, val });
            addr |= mask1;
            var addrs = std.ArrayList(usize).init(alloc);
            defer addrs.deinit();
            addrs.append(addr) catch unreachable;
            var m: usize = (1 << 35);
            while (m >= 1) : (m >>= 1) {
                if ((m & maskx) != 0) {
                    addrs.ensureUnusedCapacity(addrs.items.len) catch unreachable;
                    for (addrs.items) |a| {
                        if ((a & m) != 0) { // existing entry has 1
                            addrs.append(a & (0xfffffffff ^ m)) catch unreachable;
                        } else { // existing entry has 0
                            addrs.append(a | m) catch unreachable;
                        }
                    }
                }
            }
            for (addrs.items) |a| {
                mem.put(a, val) catch unreachable;
            }
        }
    }
    var sum: usize = 0;
    var it = mem.iterator();
    while (it.next()) |entry| {
        sum += entry.value_ptr.*;
    }
    return sum;
}

test "examples" {
    const test1 = try aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = try aoc.readLines(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = try aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(usize, 165), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 51), part1(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 4297467072083), part1(aoc.talloc, inp));

    try aoc.assertEq(@as(usize, 208), part2(aoc.talloc, test2));
    try aoc.assertEq(@as(usize, 5030603328768), part2(aoc.talloc, inp));
}

fn day14(inp: []const u8, bench: bool) anyerror!void {
    const lines = try aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    const p1 = part1(aoc.halloc, lines);
    const p2 = part2(aoc.halloc, lines);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day14);
}

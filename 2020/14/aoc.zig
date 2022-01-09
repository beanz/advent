usingnamespace @import("aoc-lib.zig");

fn part1(in: [][]const u8, alloc: *Allocator) usize {
    var mem = AutoHashMap(usize, usize).init(alloc);
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
            var vit = split(line, " = ");
            const astr = vit.next().?;
            var val = parseUnsigned(usize, vit.next().?, 10) catch unreachable;
            const addr = parseUnsigned(usize, astr[4 .. astr.len - 1], 10) catch unreachable;
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

fn part2(in: [][]const u8, alloc: *Allocator) usize {
    var mem = AutoHashMap(usize, usize).init(alloc);
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
            var vit = split(line, " = ");
            const astr = vit.next().?;
            const val = parseUnsigned(usize, vit.next().?, 10) catch unreachable;
            var addr = parseUnsigned(usize, astr[4 .. astr.len - 1], 10) catch unreachable;
            //warn("addr={} value={}\n", .{ addr, val });
            addr |= mask1;
            var addrs = ArrayList(usize).init(alloc);
            defer addrs.deinit();
            addrs.append(addr) catch unreachable;
            var m: usize = (1 << 35);
            while (m >= 1) : (m >>= 1) {
                if ((m & maskx) != 0) {
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
    const test1 = readLines(test1file, talloc);
    defer talloc.free(test1);
    const test2 = readLines(test2file, talloc);
    defer talloc.free(test2);
    const inp = readLines(inputfile, talloc);
    defer talloc.free(inp);

    try assertEq(@as(usize, 165), part1(test1, talloc));
    try assertEq(@as(usize, 51), part1(test2, talloc));
    try assertEq(@as(usize, 4297467072083), part1(inp, talloc));

    try assertEq(@as(usize, 208), part2(test2, talloc));
    try assertEq(@as(usize, 5030603328768), part2(inp, talloc));
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const lines = readLines(inp, halloc);
    defer halloc.free(lines);
    var p1 = part1(lines, halloc);
    var p2 = part2(lines, halloc);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

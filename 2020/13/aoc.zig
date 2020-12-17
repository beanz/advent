usingnamespace @import("aoc-lib.zig");

fn part1(in: [][]const u8) u64 {
    const dt = parseUnsigned(u64, in[0], 10) catch unreachable;
    var min: u64 = maxInt(u64);
    var mbus: u64 = undefined;
    var bit = split(in[1], ",");
    while (bit.next()) |ts| {
        if (ts[0] == 'x') {
            continue;
        }
        const t = parseUnsigned(u64, ts, 10) catch unreachable;
        const m = t - (dt % t);
        if (m < min) {
            min = m;
            mbus = t;
        }
    }
    return min * mbus;
}

fn egcd(a: i64, b: i64, x: *i64, y: *i64) i64 {
    if (a == 0) {
        x.* = 0;
        y.* = 1;
        return b;
    } else {
        const g = egcd(@mod(b, a), a, x, y);
        const t = x.*;
        x.* = y.* - @divFloor(b, a) * t;
        y.* = t;
        return g;
    }
}

fn chinese(la: ArrayList(i64), ln: ArrayList(i64)) i64 {
    var p: i64 = 1;
    for (ln.items) |n| {
        p *= n;
    }
    var x: i64 = 0;
    var j: i64 = undefined; // place holder for egcd result we don't need
    for (ln.items) |n, i| {
        const a = la.items[i];
        const q = @divExact(p, n);
        var y: i64 = undefined;
        const z = egcd(n, q, &j, &y);
        //warn("q={} x={} y={} z={}\n", .{ q, j, y, z });
        if (z != 1) {
            warn("{} is not coprime\n", .{n});
            return 0;
        }
        x += a * y * q;
        x = @mod(x, p);
        //warn("x={}\n", .{x});
    }
    return x;
}

fn part2(in: [][]const u8) i64 {
    var bit = split(in[1], ",");
    var a = ArrayList(i64).init(alloc);
    var n = ArrayList(i64).init(alloc);
    var i: i64 = 0;
    while (bit.next()) |ts| {
        defer {
            i += 1;
        }
        if (ts[0] == 'x') {
            continue;
        }
        const t = parseUnsigned(i64, ts, 10) catch unreachable;
        //warn("Adding pair {} and {}\n", .{ t - i, t });
        a.append(t - i) catch unreachable;
        n.append(t) catch unreachable;
    }
    return chinese(a, n);
}

test "examples" {
    const test1 = readLines(test1file);
    const test2 = readLines(test2file);
    const test3 = readLines(test3file);
    const test4 = readLines(test4file);
    const test5 = readLines(test5file);
    const test6 = readLines(test6file);
    const inp = readLines(inputfile);

    assertEq(@as(u64, 295), part1(test1));
    assertEq(@as(u64, 130), part1(test2));
    assertEq(@as(u64, 295), part1(test3));
    assertEq(@as(u64, 295), part1(test4));
    assertEq(@as(u64, 295), part1(test5));
    assertEq(@as(u64, 47), part1(test6));
    assertEq(@as(u64, 3035), part1(inp));

    assertEq(@as(i64, 1068781), part2(test1));
    assertEq(@as(i64, 3417), part2(test2));
    assertEq(@as(i64, 754018), part2(test3));
    assertEq(@as(i64, 779210), part2(test4));
    assertEq(@as(i64, 1261476), part2(test5));
    assertEq(@as(i64, 1202161486), part2(test6));
    assertEq(@as(i64, 725169163285238), part2(inp));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    try print("Part1: {}\n", .{part1(lines)});
    try print("Part2: {}\n", .{part2(lines)});
}

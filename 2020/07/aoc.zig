usingnamespace @import("aoc-lib.zig");

test "examples" {
    const test1 = readLines(test1file);
    const test2 = readLines(test2file);
    const inp = readLines(inputfile);

    try assertEq(@as(usize, 4), part1(test1));
    try assertEq(@as(usize, 0), part1(test2));
    try assertEq(@as(usize, 112), part1(inp));

    try assertEq(@as(usize, 32), part2(test1));
    try assertEq(@as(usize, 126), part2(test2));
    try assertEq(@as(usize, 6260), part2(inp));
}

fn traverse1(m: StringHashMap(ArrayList([]const u8)), bag: []const u8, seen: *StringHashMap(bool)) void {
    if (!m.contains(bag)) {
        return;
    }
    for (m.get(bag).?.items) |outer| {
        _ = seen.getOrPutValue(outer, true) catch unreachable;
        traverse1(m, outer, seen);
    }
}

fn part1(inp: anytype) usize {
    var c: usize = 0;
    var map = StringHashMap(ArrayList([]const u8)).init(alloc);
    for (inp) |line| {
        var lit = split(line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = split(spec, ", ");
        while (sit.next()) |bags| {
            var bit = split(bags, " ");
            const ns = bit.next().?;
            const n = parseUnsigned(usize, ns, 10);
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = alloc.alloc(u8, b1.len + b2.len + 1) catch unreachable;
            copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = map.getOrPutValue(innerBag, ArrayList([]const u8).init(alloc)) catch unreachable;
            kv.value_ptr.append(bag) catch unreachable;
        }
    }
    var seen = StringHashMap(bool).init(alloc);
    traverse1(map, "shiny gold", &seen);
    return seen.count();
}

const BS = struct {
    bag: []const u8, n: usize
};

fn traverse2(m: StringHashMap(ArrayList(BS)), bag: []const u8) usize {
    var c: usize = 1;
    if (!m.contains(bag)) {
        return 1;
    }
    for (m.get(bag).?.items) |bc| {
        c += bc.n * traverse2(m, bc.bag);
    }
    return c;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    var map = StringHashMap(ArrayList(BS)).init(alloc);
    for (inp) |line| {
        var lit = split(line, " bags contain ");
        const bag = lit.next().?;
        const spec = lit.next().?;
        if (spec[0] == 'n' and spec[1] == 'o' and spec[2] == ' ') {
            continue;
        }
        var sit = split(spec, ", ");
        while (sit.next()) |bags| {
            var bit = split(bags, " ");
            const ns = bit.next().?;
            const n = parseUnsigned(usize, ns, 10) catch unreachable;
            const b1 = bit.next().?;
            const b2 = bit.next().?;
            var innerBag = alloc.alloc(u8, b1.len + b2.len + 1) catch unreachable;
            copy(u8, innerBag[0..], b1);
            innerBag[b1.len] = ' ';
            copy(u8, innerBag[b1.len + 1 ..], b2);
            const kv = map.getOrPutValue(bag, ArrayList(BS).init(alloc)) catch unreachable;
            var b = BS{ .bag = innerBag, .n = n };
            kv.value_ptr.append(b) catch unreachable;
        }
    }
    return traverse2(map, "shiny gold") - 1;
}

pub fn main() anyerror!void {
    var spec = readLines(input());
    try print("Part1: {}\n", .{part1(spec)});
    try print("Part2: {}\n", .{part2(spec)});
}

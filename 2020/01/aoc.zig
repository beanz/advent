usingnamespace @import("aoc-lib.zig");

test "examples" {
    var report = try Ints(test1file, u16, talloc);
    defer talloc.free(report);
    var p = try parts(report, talloc);
    try assertEq(@as(u64, 514579), p[0]);
    try assertEq(@as(u64, 241861950), p[1]);
    var report2 = try Ints(inputfile, u16, talloc);
    defer talloc.free(report2);
    var pi = try parts(report2, talloc);
    try assertEq(@as(usize, 41979), pi[0]);
    try assertEq(@as(usize, 193416912), pi[1]);
}


fn parts(exp: []const u16, allocator: *Allocator) anyerror![2]u64 {
    var products = std.AutoHashMap(u16, u64).init(allocator);
    defer products.deinit();
    var seen = std.AutoHashMap(u16, bool).init(allocator);
    defer seen.deinit();
    var p1 : u64 = 0;
    for (exp) |n| {
        var rem = 2020-n;
        if (seen.contains(rem)) {
            p1 = @as(u64, n) * rem;
        }
        var it = seen.iterator();
        while (it.next()) |e| {
            try products.put(n + e.key_ptr.*, n * @as(u64, e.key_ptr.*));
        }
        try seen.put(n, true);
    }
    for (exp) |n| {
        if (n > 2020) {
            continue;
        }
        var rem = 2020-n;
        if (products.get(rem)) |p| {
            return [2]u64{p1, n * p};
        }
    }
    unreachable;
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    var report = try Ints(inp, u16, halloc);
    defer hfree(report);
    var p = try parts(report, halloc);
    if (!bench) {
        try print("Part 1: {}\nPart 2: {}\n", .{p[0], p[1]});
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

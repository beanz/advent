usingnamespace @import("aoc-lib.zig");

test "examples" {
    var report = readInts(test1file, i64);
    defer free(report);
    assertEq(@as(i64, 514579), part1(report));
    assertEq(@as(i64, 241861950), part2(report));
    var report2 = readInts(inputfile, i64);
    defer free(report2);
    assertEq(@as(i64, 41979), part1(report2));
    assertEq(@as(i64, 193416912), part2(report2));
}

fn part1(exp: []const i64) i64 {
    var i: usize = 0;
    while (i < exp.len) : (i += 1) {
        var j: usize = i;
        while (j < exp.len) : (j += 1) {
            if (exp[i] + exp[j] == 2020) {
                return exp[i] * exp[j];
            }
        }
    }
    return 0;
}

fn part2(exp: []const i64) i64 {
    var i: usize = 0;
    while (i < exp.len) : (i += 1) {
        var j: usize = i;
        while (j < exp.len) : (j += 1) {
            var k: usize = i;
            while (k < exp.len) : (k += 1) {
                if (exp[i] + exp[j] + exp[k] == 2020) {
                    return exp[i] * exp[j] * exp[k];
                }
            }
        }
    }
    return 0;
}

pub fn main() anyerror!void {
    var report = readInts(input(), i64);
    defer free(report);
    try print("Part1: {}\n", .{part1(report)});
    try print("Part2: {}\n", .{part2(report)});
}

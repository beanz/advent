const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const DX = [4]i32{ 0, 1, 0, -1 };
const DY = [4]i32{ -1, 0, 1, 0 };

fn parts(inp: []const u8) anyerror![2]usize {
    const w = width: {
        var w: usize = 0;
        while (inp[w] != '\n') : (w += 1) {}
        break :width w + 1;
    };
    const h = inp.len / w;
    const wi: i32 = @intCast(w);
    const hi: i32 = @intCast(h);
    var p1: usize = 0;
    var p2: usize = 0;
    var y: i32 = 0;
    while (y < hi) : (y += 1) {
        var x: i32 = 0;
        while (x < wi - 1) : (x += 1) {
            const tree = inp[@as(usize, @intCast(x + y * wi))];
            var p1Done = false;
            var score: usize = 1;
            for (0..4) |dir| {
                var nx = x + DX[dir];
                var ny = y + DY[dir];
                var view: usize = 0;
                var visible = true;
                while (0 <= nx and nx < wi - 1 and 0 <= ny and ny < hi) {
                    view += 1;
                    if (inp[@as(usize, @intCast(nx + ny * wi))] >= tree) {
                        visible = false;
                        break;
                    }
                    nx = nx + DX[dir];
                    ny = ny + DY[dir];
                }
                score *= view;
                if (visible and !p1Done) {
                    p1 += 1;
                    p1Done = true;
                }
                if (score == 0 and p1Done) {
                    break;
                }
            }
            if (score > p2) {
                p2 = score;
            }
        }
    }
    return [2]usize{ p1, p2 };
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

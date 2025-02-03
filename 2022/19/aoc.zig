const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u8;

const Rec = struct {
    ore: Int,
    clay: Int,
    obsidian: Int,
    geode: Int,

    const ORE = Rec{ .ore = 1, .clay = 0, .obsidian = 0, .geode = 0 };
    const CLAY = Rec{ .ore = 0, .clay = 1, .obsidian = 0, .geode = 0 };
    const OBSIDIAN = Rec{ .ore = 0, .clay = 0, .obsidian = 1, .geode = 0 };
    const GEODE = Rec{ .ore = 0, .clay = 0, .obsidian = 0, .geode = 1 };

    fn init(ore: Int, clay: Int, obsidian: Int, geode: Int) Rec {
        return Rec{ .ore = ore, .clay = clay, .obsidian = obsidian, .geode = geode };
    }

    fn enough(got: Rec, want: Rec) bool {
        return got.ore >= want.ore and got.clay >= want.clay and got.obsidian >= want.obsidian;
    }
    fn add(a: *Rec, b: Rec) void {
        a.ore += b.ore;
        a.clay +|= b.clay; // clay overflows but we don't really care
        a.obsidian += b.obsidian;
        a.geode += b.geode;
    }
    fn sub(a: *Rec, b: Rec) void {
        a.ore -= b.ore;
        a.clay -= b.clay;
        a.obsidian -= b.obsidian;
        a.geode -= b.geode;
    }
    fn addNew(a: *const Rec, b: Rec) Rec {
        return Rec{
            .ore = a.ore + b.ore,
            .clay = a.clay + b.clay,
            .obsidian = a.obsidian + b.obsidian,
            .geode = a.geode + b.geode,
        };
    }
    pub fn format(value: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("<{},{},{},{}>", .{ value.ore, value.clay, value.obsidian, value.geode });
    }
};

const Search = struct {
    t: u8,
    inv: Rec,
    robots: Rec,
};

fn solve(todo: *aoc.Deque(Search), maxTime: u8, oreRec: Rec, clayRec: Rec, obsRec: Rec, geoRec: Rec, maxOre: Int) !usize {
    try todo.push(Search{ .t = @intCast(maxTime), .inv = Rec.init(0, 0, 0, 0), .robots = Rec.init(1, 0, 0, 0) });
    var max: u8 = 0;
    var maxGuess: usize = 0;
    //var pruneLen = if (maxTime == 24) 200 else 8000;
    //var pruneTime: isize = @intCast(maxTime - 1);
    while (todo.shift()) |cur| {
        //aoc.print("{} rbt={any} inv={any}\n", .{ cur.t, cur.robots, cur.inv });
        if (cur.inv.geode > max) {
            max = cur.inv.geode;
            //aoc.print("max={}\n", .{max});
        }
        if (cur.t == 0) {
            continue;
        }
        const ct: usize = @intCast(cur.t);
        const minGeodes = @as(usize, @intCast(cur.inv.geode)) + ct * @as(usize, @intCast(cur.robots.geode));
        const maxGeodes = minGeodes + ((ct - 1) * (ct - 1) + ct - 1) / 2;
        if (maxGeodes < maxGuess) {
            continue;
        }
        if (minGeodes > maxGuess) {
            maxGuess = minGeodes;
        }
        var done = false;
        if (cur.robots.obsidian > 0) {
            var t = cur.t;
            var next = Rec.init(cur.inv.ore, cur.inv.clay, cur.inv.obsidian, cur.inv.geode);
            while (t > 0) {
                if (next.enough(geoRec)) {
                    done = true;
                    next.add(cur.robots);
                    next.sub(geoRec);
                    try todo.push(Search{
                        .t = t - 1,
                        .inv = next,
                        .robots = cur.robots.addNew(Rec.GEODE),
                    });
                    break;
                }
                next.add(cur.robots);
                t -= 1;
            }
        }
        if (cur.robots.obsidian < geoRec.obsidian and cur.robots.clay > 0) {
            var t = cur.t;
            var next = Rec.init(cur.inv.ore, cur.inv.clay, cur.inv.obsidian, cur.inv.geode);
            while (t > 0) {
                if (next.enough(obsRec)) {
                    done = true;
                    next.add(cur.robots);
                    next.sub(obsRec);
                    try todo.push(Search{
                        .t = t - 1,
                        .inv = next,
                        .robots = cur.robots.addNew(Rec.OBSIDIAN),
                    });
                    break;
                }
                next.add(cur.robots);
                t -= 1;
            }
        }
        if (cur.robots.clay < obsRec.clay) {
            var t = cur.t;
            var next = Rec.init(cur.inv.ore, cur.inv.clay, cur.inv.obsidian, cur.inv.geode);
            while (t > 0) {
                if (next.enough(clayRec)) {
                    done = true;
                    next.add(cur.robots);
                    next.sub(clayRec);
                    try todo.push(Search{
                        .t = t - 1,
                        .inv = next,
                        .robots = cur.robots.addNew(Rec.CLAY),
                    });
                    break;
                }
                next.add(cur.robots);
                t -= 1;
            }
        }
        if (cur.robots.ore < maxOre) {
            var t = cur.t;
            var next = Rec.init(cur.inv.ore, cur.inv.clay, cur.inv.obsidian, cur.inv.geode);
            while (t > 0) {
                if (next.enough(oreRec)) {
                    done = true;
                    next.add(cur.robots);
                    next.sub(oreRec);
                    try todo.push(Search{
                        .t = t - 1,
                        .inv = next,
                        .robots = cur.robots.addNew(Rec.ORE),
                    });
                    break;
                }
                next.add(cur.robots);
                t -= 1;
            }
        }
        if (!done) {
            var next = Rec.init(cur.inv.ore, cur.inv.clay, cur.inv.obsidian, cur.inv.geode);
            next.add(cur.robots);
            try todo.push(Search{
                .t = cur.t - 1,
                .inv = next,
                .robots = cur.robots,
            });
        }
    }
    return @as(usize, @intCast(max));
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 1;
    {
        var back: [64]Search = undefined;
        var todo = aoc.Deque(Search).init(back[0..]);
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            i += 10;
            const n = try aoc.chompUint(Int, inp, &i);
            i += 23;
            const oreOre = try aoc.chompUint(Int, inp, &i);
            i += 28;
            const clayOre = try aoc.chompUint(Int, inp, &i);
            i += 32;
            const obsOre = try aoc.chompUint(Int, inp, &i);
            i += 9;
            const obsClay = try aoc.chompUint(Int, inp, &i);
            i += 30;
            const geoOre = try aoc.chompUint(Int, inp, &i);
            i += 9;
            const geoObs = try aoc.chompUint(Int, inp, &i);
            i += 10;
            //aoc.print("{}: {}, {}, {}&{}, {}&{}\n", .{ n, oreOre, clayOre, obsOre, obsClay, geoOre, geoObs });
            const maxOre = @max(clayOre, @max(obsOre, geoOre));
            p1 += n * try solve(&todo, 24, Rec.init(oreOre, 0, 0, 0), Rec.init(clayOre, 0, 0, 0), Rec.init(obsOre, obsClay, 0, 0), Rec.init(geoOre, 0, geoObs, 0), maxOre);
            todo.clear();
            if (n <= 3) {
                p2 *= try solve(&todo, 32, Rec.init(oreOre, 0, 0, 0), Rec.init(clayOre, 0, 0, 0), Rec.init(obsOre, obsClay, 0, 0), Rec.init(geoOre, 0, geoObs, 0), maxOre);
                todo.clear();
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

const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const D100 = struct {
    count: usize,
    inline fn roll(self: *D100) usize {
        const r = 1 + @rem(self.count, 100);
        self.count += 1;
        return r;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 28;
    const pp1 = try aoc.chompUint(usize, inp, &i);
    i += 29;
    const pp2 = try aoc.chompUint(usize, inp, &i);
    const p1 = part1: {
        var s = [2]usize{ 0, 0 };
        var p = [2]usize{ pp1 - 1, pp2 - 1 };
        var d = D100{ .count = 0 };
        while (true) {
            inline for (0..2) |j| {
                const r = d.roll() + d.roll() + d.roll();
                p[j] += r;
                p[j] %= 10;
                s[j] += p[j] + 1;
                if (s[j] >= 1000) {
                    break :part1 s[1 - j] * d.count;
                }
            }
        }
    };
    const t = P2; //part2();
    //aoc.print("{any}\n", .{t});
    const ri = (pp1 - 1) * 10 + pp2 - 1;
    return [2]usize{ p1, t[ri] };
}

const P2 = [_]usize{ 32491093007709, 27674034218179, 48868319769358, 97774467368562, 138508043837521, 157253621231420, 141740702114011, 115864149937553, 85048040806299, 57328067654557, 27464148626406, 24411161361207, 45771240990345, 93049942628388, 131888061854776, 149195946847792, 133029050096658, 106768284484217, 76262326668116, 49975322685009, 51863007694527, 45198749672670, 93013662727308, 193753136998081, 275067741811212, 309991007938181, 273042027784929, 214368059463212, 147573255754448, 92399285032143, 110271560863819, 91559198282731, 193170338541590, 404904579900696, 575111835924670, 647608359455719, 568867175661958, 444356092776315, 303121579983974, 187451244607486, 156667189442502, 129742452789556, 274195599086465, 575025114466224, 816800855030343, 919758187195363, 807873766901514, 630947104784464, 430229563871565, 265845890886828, 175731756652760, 146854918035875, 309196008717909, 647920021341197, 920342039518611, 1036584236547450, 911090395997650, 712381680443927, 486638407378784, 301304993766094, 152587196649184, 131180774190079, 272847859601291, 570239341223618, 809953813657517, 912857726749764, 803934725594806, 630797200227453, 433315766324816, 270005289024391, 116741133558209, 105619718613031, 214924284932572, 446968027750017, 634769613696613, 716241959649754, 632979211251440, 499714329362294, 346642902541848, 218433063958910, 83778196139157, 75823864479001, 148747830493442, 306621346123766, 435288918824107, 492043106122795, 437256456198320, 348577682881276, 245605000281051, 157595953724471, 56852759190649, 49982165861983, 93726416205179, 190897246590017, 270803396243039, 306719685234774, 274291038026362, 221109915584112, 158631174219251, 104001566545663 };

const SIZE = 21 * 21 * 11 * 11;
const rollWays = [_]usize{ 1, 3, 6, 7, 6, 3, 1 };
fn part2() [100]usize {
    @setEvalBranchQuota(10000000);
    var games: [SIZE]usize = .{0} ** SIZE;
    var wins: [SIZE]usize = .{0} ** SIZE;
    var ts: usize = 40;
    while (true) : (ts -= 1) {
        var s1: usize = 20;
        while (true) : (s1 -= 1) {
            if (s1 > ts) {
                if (s1 == 0) {
                    break;
                }
                continue;
            }
            const s2 = ts - s1;
            if (s2 > 20) {
                if (s1 == 0) {
                    break;
                }
                continue;
            }
            var p1: usize = 1;
            while (p1 <= 10) : (p1 += 1) {
                var p2: usize = 1;
                while (p2 <= 10) : (p2 += 1) {
                    const i = (((s1 * 21) + s2) * 11 + p1) * 11 + p2;
                    var r: usize = 3;
                    while (r <= 9) : (r += 1) {
                        const w = rollWays[r - 3];
                        var np1 = p1 + r;
                        if (np1 > 10) {
                            np1 -= 10;
                        }
                        const ns1 = s1 + np1;
                        if (ns1 >= 21) {
                            games[i] += w;
                            wins[i] += w;
                        } else {
                            const ii = ((((s2 * 21) + ns1) * 11 + p2) * 11) + np1;
                            games[i] += w * games[ii];
                            wins[i] += w * (games[ii] - wins[ii]);
                        }
                    }
                }
            }
            if (s1 == 0) {
                break;
            }
        }
        if (ts == 0) {
            break;
        }
    }

    var t: [100]usize = undefined;
    for (0..10) |i| {
        for (0..10) |j| {
            const ri = (1 + i) * 11 + (1 + j);
            t[i * 10 + j] = @max(wins[ri], games[ri] - wins[ri]);
        }
    }
    return t;
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

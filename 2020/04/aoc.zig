const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "validate year" {
    try aoc.assert(validYear("2002", 1920, 2002));
    try aoc.assert(!validYear("2003", 1920, 2002));
}

test "validate height" {
    try aoc.assert(validHeight("60in"));
    try aoc.assert(validHeight("190cm"));
    try aoc.assert(!validHeight("190in"));
    try aoc.assert(!validHeight("190"));
}

test "validate hair color" {
    try aoc.assert(validHairColor("#123abc"));
    try aoc.assert(!validHairColor("#123abz"));
    try aoc.assert(!validHairColor("123abc"));
}

test "validate eye color" {
    try aoc.assert(validEyeColor("brn"));
    try aoc.assert(!validEyeColor("wat"));
}

test "examples" {
    const test1 = try aoc.readChunkyObjects(aoc.talloc, aoc.test1file, "\n\n", "\n ", ":");
    defer {
        for (test1) |*e| {
            e.deinit();
        }
        aoc.talloc.free(test1);
    }
    try aoc.assertEq(@as(usize, 2), part1(test1));
    try aoc.assertEq(@as(usize, 2), part2(test1));

    const test2 = try aoc.readChunkyObjects(aoc.talloc, aoc.test2file, "\n\n", "\n ", ":");
    defer {
        for (test2) |*e| {
            e.deinit();
        }
        aoc.talloc.free(test2);
    }
    try aoc.assertEq(@as(usize, 4), part1(test2));
    try aoc.assertEq(@as(usize, 0), part2(test2));

    const test3 = try aoc.readChunkyObjects(aoc.talloc, aoc.test3file, "\n\n", "\n ", ":");
    defer {
        for (test3) |*e| {
            e.deinit();
        }
        aoc.talloc.free(test3);
    }
    try aoc.assertEq(@as(usize, 4), part1(test3));
    try aoc.assertEq(@as(usize, 4), part2(test3));

    const inp = try aoc.readChunkyObjects(aoc.talloc, aoc.inputfile, "\n\n", "\n ", ":");
    defer {
        for (inp) |*e| {
            e.deinit();
        }
        aoc.talloc.free(inp);
    }
    try aoc.assertEq(@as(usize, 213), part1(inp));
    try aoc.assertEq(@as(usize, 147), part2(inp));
}

const fields = [_][]const u8{
    "byr", "iyr", "eyr",
    "hgt", "hcl", "ecl",
    "pid",
};

fn part1(inp: anytype) usize {
    var c: usize = 0;
    for (inp) |pp| {
        var fc: usize = 0;
        for (fields) |f| {
            if (pp.get(f)) |_| {
                fc += 1;
            }
        }
        if (fc == fields.len) {
            c += 1;
        }
    }
    return c;
}

fn validYear(ys: []const u8, min: i16, max: i16) bool {
    const y = std.fmt.parseInt(i16, ys, 10) catch return false;
    return y >= min and y <= max;
}

fn validHeight(hs: []const u8) bool {
    const l = hs.len;
    if (l < 3) {
        return false;
    }
    const units = hs[l - 2 ..];
    const n = std.fmt.parseInt(i16, hs[0 .. l - 2], 10) catch return false;
    if (units[0] == 'c' and units[1] == 'm') {
        if (n < 150 or n > 193) {
            return false;
        }
    } else if (units[0] == 'i' and units[1] == 'n') {
        if (n < 59 or n > 76) {
            return false;
        }
    } else {
        return false;
    }
    return true;
}

fn validHairColor(hs: []const u8) bool {
    if (hs.len != 7) {
        return false;
    }
    for (hs[1..]) |ch| {
        if (!(ch >= 'a' and ch <= 'f') and !(ch >= '0' and ch <= '9')) {
            return false;
        }
    }
    return true;
}

fn eyeColorEq(ec: []const u8, str: []const u8) bool {
    if (ec.len != str.len) {
        return false;
    }
    var i: usize = 0;
    while (i < ec.len) : (i += 1) {
        if (ec[i] != str[i]) {
            return false;
        }
    }
    return true;
}

fn validEyeColor(ec: []const u8) bool {
    return eyeColorEq(ec, "amb") or eyeColorEq(ec, "blu") or
        eyeColorEq(ec, "brn") or eyeColorEq(ec, "gry") or
        eyeColorEq(ec, "grn") or eyeColorEq(ec, "hzl") or
        eyeColorEq(ec, "oth");
}

fn validPID(pid: []const u8) bool {
    if (pid.len != 9) {
        return false;
    }
    _ = std.fmt.parseInt(i64, pid, 10) catch return false;
    return true;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    for (inp) |pp| {
        if (!validYear(pp.get("byr") orelse "", 1920, 2002)) {
            continue;
        }
        if (!validYear(pp.get("iyr") orelse "", 2010, 2020)) {
            continue;
        }
        if (!validYear(pp.get("eyr") orelse "", 2020, 2030)) {
            continue;
        }
        if (!validHeight(pp.get("hgt") orelse "")) {
            continue;
        }
        if (!validHairColor(pp.get("hcl") orelse "")) {
            continue;
        }
        if (!validEyeColor(pp.get("ecl") orelse "")) {
            continue;
        }
        if (!validPID(pp.get("pid") orelse "")) {
            continue;
        }
        c += 1;
    }
    return c;
}

fn day04(inp: []const u8, bench: bool) anyerror!void {
    const scan = try aoc.readChunkyObjects(aoc.halloc, inp, "\n\n", "\n ", ":");
    defer {
        for (scan) |*e| {
            e.deinit();
        }
        aoc.halloc.free(scan);
    }
    const p1 = part1(scan);
    const p2 = part2(scan);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day04);
}

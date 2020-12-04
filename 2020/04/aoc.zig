const std = @import("std");
const assert = std.testing.expect;
const assertEq = std.testing.expectEqual;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;

const input = @embedFile("input.txt");
const out = &std.io.getStdOut().outStream();
const alloc = std.heap.page_allocator;

test "validate year" {
    assert(validYear("2002", 1920, 2002));
    assert(!validYear("2003", 1920, 2002));
}

test "validate height" {
    assert(validHeight("60in"));
    assert(validHeight("190cm"));
    assert(!validHeight("190in"));
    assert(!validHeight("190"));
}

test "validate hair color" {
    assert(validHairColor("#123abc"));
    assert(!validHairColor("#123abz"));
    assert(!validHairColor("123abc"));
}

test "validate eye color" {
    assert(validEyeColor("brn"));
    assert(!validEyeColor("wat"));
}

test "examples" {
    const test1 = try readChunks(@embedFile("test1.txt"));
    var r: usize = 2;
    assertEq(r, part1(test1));
    assertEq(r, part2(test1));

    const test2 = try readChunks(@embedFile("test2.txt"));
    r = 4;
    assertEq(r, part1(test2));
    r = 0;
    assertEq(r, part2(test2));

    const test3 = try readChunks(@embedFile("test3.txt"));
    r = 4;
    assertEq(r, part1(test3));
    assertEq(r, part2(test3));

    const inp = try readChunks(input);
    r = 213;
    assertEq(r, part1(inp));
    r = 147;
    assertEq(r, part2(inp));
}

const fields = [_][]const u8{
    "byr", "iyr", "eyr",
    "hgt", "hcl", "ecl",
    "pid",
};

fn part1(inp: anytype) usize {
    var c: usize = 0;
    for (inp.items) |pp| {
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
    while (i < ec.len) {
        if (ec[i] != str[i]) {
            return false;
        }
        i += 1;
    }
    return true;
}

fn validEyeColor(ec: []const u8) bool {
    return eyeColorEq(ec, "amb") or eyeColorEq(ec, "blu") or eyeColorEq(ec, "brn") or eyeColorEq(ec, "gry") or
        eyeColorEq(ec, "grn") or eyeColorEq(ec, "hzl") or eyeColorEq(ec, "oth");
}

fn validPID(pid: []const u8) bool {
    if (pid.len != 9) {
        return false;
    }
    const n = std.fmt.parseInt(i64, pid, 10) catch return false;
    return true;
}

fn part2(inp: anytype) usize {
    var c: usize = 0;
    for (inp.items) |pp, i| {
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

fn readChunks(inp: anytype) anyerror!ArrayList(std.StringHashMap([]const u8)) {
    var report = ArrayList(std.StringHashMap([]const u8)).init(alloc);
    var cit = std.mem.split(inp, "\n\n");
    while (cit.next()) |chunk| {
        if (chunk.len == 0) {
            break;
        }
        var map = std.StringHashMap([]const u8).init(alloc);
        var fit = std.mem.tokenize(chunk, "\n ");
        while (fit.next()) |field| {
            if (field.len == 0) {
                break;
            }
            var kvit = std.mem.split(field, ":");
            const k = kvit.next().?;
            const v = kvit.next().?;
            try map.put(k, v);
        }
        try report.append(map);
    }
    return report;
}

pub fn main() anyerror!void {
    var scan = try readChunks(input);
    //try out.print("{}\n", .{report.items.len});
    try out.print("Part1: {}\n", .{part1(scan)});
    try out.print("Part2: {}\n", .{part2(scan)});
}

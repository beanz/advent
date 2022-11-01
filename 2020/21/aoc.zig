const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Menu = struct {
    const Result = struct { all: []const u8, ing: []const u8 };

    allergens: std.StringHashMap(std.AutoHashMap(usize, bool)),
    ingredients: std.StringHashMap(std.AutoHashMap(usize, bool)),
    possible: std.StringHashMap(std.StringHashMap(bool)),
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator, in: [][]const u8) !*Menu {
        var self = try alloc.create(Menu);
        self.alloc = alloc;
        self.allergens = std.StringHashMap(std.AutoHashMap(usize, bool)).init(alloc);
        self.ingredients = std.StringHashMap(std.AutoHashMap(usize, bool)).init(alloc);
        self.possible = std.StringHashMap(std.StringHashMap(bool)).init(alloc);

        for (in) |line, i| {
            var ls = std.mem.split(u8, line, " (contains ");
            const ingstr = ls.next().?;
            var ings = std.mem.split(u8, ingstr, " ");
            while (ings.next()) |ing| {
                var e = try self.ingredients.getOrPutValue(ing, std.AutoHashMap(usize, bool).init(alloc));
                try e.value_ptr.put(i, true);
            }
            var allstr = ls.next().?;
            var alls = std.mem.split(u8, allstr[0 .. allstr.len - 1], ", ");
            while (alls.next()) |all| {
                var e = try self.allergens.getOrPutValue(all, std.AutoHashMap(usize, bool).init(alloc));
                try e.value_ptr.put(i, true);
            }
        }
        var it = self.ingredients.iterator();
        while (it.next()) |ingentry| {
            var allit = self.allergens.iterator();
            while (allit.next()) |allentry| {
                var maybeThisAllergen = true;
                var lineit = allentry.value_ptr.iterator();
                while (lineit.next()) |lineentry| {
                    if (!ingentry.value_ptr.contains(lineentry.key_ptr.*)) {
                        maybeThisAllergen = false;
                    }
                }
                if (maybeThisAllergen) {
                    var e = try self.possible.getOrPutValue(ingentry.key_ptr.*, std.StringHashMap(bool).init(alloc));
                    try e.value_ptr.put(allentry.key_ptr.*, true);
                }
            }
        }
        return self;
    }

    pub fn deinit(m: *Menu) void {
        var ita = m.allergens.iterator();
        while (ita.next()) |e| {
            e.value_ptr.*.deinit();
        }
        m.allergens.deinit();
        var iti = m.ingredients.iterator();
        while (iti.next()) |e| {
            e.value_ptr.*.deinit();
        }
        m.ingredients.deinit();
        var itp = m.possible.iterator();
        while (itp.next()) |e| {
            e.value_ptr.*.deinit();
        }
        m.possible.deinit();
        m.alloc.destroy(m);
    }

    pub fn Part1(m: *Menu) usize {
        var c: usize = 0;
        var it = m.ingredients.iterator();
        while (it.next()) |ingentry| {
            const ing = ingentry.key_ptr.*;
            if (!m.possible.contains(ing)) {
                c += ingentry.value_ptr.count();
            }
        }
        return c;
    }

    fn resultLessThan(c: void, a: Result, b: Result) bool {
        return aoc.stringLessThan(c, a.all, b.all);
    }

    pub fn Part2(m: *Menu) []const u8 {
        var resList = std.ArrayList(Result).init(m.alloc);
        defer resList.deinit();
        var resLength: usize = 0;
        while (m.possible.count() > 0) {
            var it = m.possible.iterator();
            while (it.next()) |possentry| {
                var ing = possentry.key_ptr.*;
                var allergens = possentry.value_ptr.*;
                if (allergens.count() == 1) {
                    var allit = allergens.iterator();
                    const all = allit.next().?.key_ptr.*;
                    //std.debug.print("{} is {}\n", .{ ing, all });
                    resList.append(Result{ .all = all, .ing = ing }) catch unreachable;
                    resLength += ing.len + 1;
                    _ = m.possible.remove(ing);
                    var pit = m.possible.iterator();
                    while (pit.next()) |pe| {
                        _ = pe.value_ptr.remove(all);
                    }
                    allergens.deinit();
                }
            }
        }
        var res = resList.items;
        std.sort.sort(Result, res, {}, resultLessThan);
        if (resLength == 0) {
            return "";
        }
        var rs = m.alloc.alloc(u8, resLength) catch unreachable;
        var i: usize = 0;
        for (res) |r| {
            std.mem.copy(u8, rs[i..], r.ing);
            i += r.ing.len;
            rs[i] = ',';
            i += 1;
        }
        return rs[0 .. rs.len - 1];
    }
};

test "examples" {
    const test1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var mt = Menu.init(aoc.talloc, test1) catch unreachable;
    defer mt.deinit();
    try aoc.assertEq(@as(usize, 5), mt.Part1());
    var rt = "mxmxvkd,sqjhc,fvjkl";
    var resTest = mt.Part2();
    defer aoc.talloc.free(resTest);
    try aoc.assert(std.mem.eql(u8, rt, resTest));

    var m = Menu.init(aoc.talloc, inp) catch unreachable;
    defer m.deinit();
    try aoc.assertEq(@as(usize, 2874), m.Part1());
    var r = "gfvrr,ndkkq,jxcxh,bthjz,sgzr,mbkbn,pkkg,mjbtz";
    var res = m.Part2();
    defer aoc.talloc.free(res);
    try aoc.assert(std.mem.eql(u8, r, res));
}

fn day21(inp: []const u8, bench: bool) anyerror!void {
    const lines = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var m = try Menu.init(aoc.halloc, lines);
    defer m.deinit();
    var p1 = m.Part1();
    var p2 = m.Part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {s}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day21);
}

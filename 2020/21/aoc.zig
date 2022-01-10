usingnamespace @import("aoc-lib.zig");

const Menu = struct {
    const Result = struct {
        all: []const u8, ing: []const u8
    };

    allergens: StringHashMap(AutoHashMap(usize, bool)),
    ingredients: StringHashMap(AutoHashMap(usize, bool)),
    possible: StringHashMap(StringHashMap(bool)),
    alloc: *Allocator,

    pub fn init(in: [][]const u8, alloc: *Allocator) !*Menu {
        var self = try alloc.create(Menu);
        self.alloc = alloc;
        self.allergens = StringHashMap(AutoHashMap(usize, bool)).init(alloc);
        self.ingredients = StringHashMap(AutoHashMap(usize, bool)).init(alloc);
        self.possible = StringHashMap(StringHashMap(bool)).init(alloc);

        for (in) |line, i| {
            var ls = split(line, " (contains ");
            const ingstr = ls.next().?;
            var ings = split(ingstr, " ");
            while (ings.next()) |ing| {
                var e = try self.ingredients.getOrPutValue(ing, AutoHashMap(usize, bool).init(alloc));
                try e.value_ptr.put(i, true);
            }
            var allstr = ls.next().?;
            var alls = split(allstr[0 .. allstr.len - 1], ", ");
            while (alls.next()) |all| {
                var e = try self.allergens.getOrPutValue(all, AutoHashMap(usize, bool).init(alloc));
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
                    var e = try self.possible.getOrPutValue(ingentry.key_ptr.*, StringHashMap(bool).init(alloc));
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
        return stringLessThan(c, a.all, b.all);
    }

    pub fn Part2(m: *Menu) []const u8 {
        var resList = ArrayList(Result).init(m.alloc);
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
                    //warn("{} is {}\n", .{ ing, all });
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
        sort.sort(Result, res, {}, resultLessThan);
        if (resLength == 0) {
            return "";
        }
        var rs = m.alloc.alloc(u8, resLength) catch unreachable;
        var i: usize = 0;
        for (res) |r| {
            copy(u8, rs[i..], r.ing);
            i += r.ing.len;
            rs[i] = ',';
            i += 1;
        }
        return rs[0 .. rs.len - 1];
    }
};

test "examples" {
    const test1 = readLines(test1file, talloc);
    defer talloc.free(test1);
    const inp = readLines(inputfile, talloc);
    defer talloc.free(inp);

    var mt = Menu.init(test1, talloc) catch unreachable;
    defer mt.deinit();
    try assertEq(@as(usize, 5), mt.Part1());
    var rt = "mxmxvkd,sqjhc,fvjkl";
    var resTest = mt.Part2();
    defer talloc.free(resTest);
    try assert(std.mem.eql(u8, rt, resTest));

    var m = Menu.init(inp, talloc) catch unreachable;
    defer m.deinit();
    try assertEq(@as(usize, 2874), m.Part1());
    var r = "gfvrr,ndkkq,jxcxh,bthjz,sgzr,mbkbn,pkkg,mjbtz";
    var res = m.Part2();
    defer talloc.free(res);
    try assert(std.mem.eql(u8, r, res));
}

fn aoc(inp: []const u8, bench: bool) anyerror!void {
    const lines = readLines(inp, halloc);
    defer halloc.free(lines);
    var m = try Menu.init(lines, halloc);
    defer m.deinit();
    var p1 = m.Part1();
    var p2 = m.Part2();
    if (!bench) {
        try print("Part 1: {}\nPart 2: {s}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try benchme(input(), aoc);
}

usingnamespace @import("aoc-lib.zig");

const Menu = struct {
    const Result = struct {
        all: []const u8, ing: []const u8
    };

    allergens: StringHashMap(AutoHashMap(usize, bool)),
    ingredients: StringHashMap(AutoHashMap(usize, bool)),
    possible: StringHashMap(StringHashMap(bool)),

    pub fn init(in: [][]const u8) !*Menu {
        var self = try alloc.create(Menu);
        self.allergens = StringHashMap(AutoHashMap(usize, bool)).init(alloc);
        self.ingredients = StringHashMap(AutoHashMap(usize, bool)).init(alloc);
        self.possible = StringHashMap(StringHashMap(bool)).init(alloc);

        for (in) |line, i| {
            var ls = split(line, " (contains ");
            const ingstr = ls.next().?;
            var ings = split(ingstr, " ");
            while (ings.next()) |ing| {
                var e = try self.ingredients.getOrPutValue(ing, AutoHashMap(usize, bool).init(alloc));
                try e.value.put(i, true);
            }
            var allstr = ls.next().?;
            var alls = split(allstr[0 .. allstr.len - 1], ", ");
            while (alls.next()) |all| {
                var e = try self.allergens.getOrPutValue(all, AutoHashMap(usize, bool).init(alloc));
                try e.value.put(i, true);
            }
        }
        var it = self.ingredients.iterator();
        while (it.next()) |ingentry| {
            var allit = self.allergens.iterator();
            while (allit.next()) |allentry| {
                var maybeThisAllergen = true;
                var lineit = allentry.value.iterator();
                while (lineit.next()) |lineentry| {
                    if (!ingentry.value.contains(lineentry.key)) {
                        maybeThisAllergen = false;
                    }
                }
                if (maybeThisAllergen) {
                    var e = try self.possible.getOrPutValue(ingentry.key, StringHashMap(bool).init(alloc));
                    try e.value.put(allentry.key, true);
                }
            }
        }
        return self;
    }

    pub fn Part1(m: *Menu) usize {
        var c: usize = 0;
        var it = m.ingredients.iterator();
        while (it.next()) |ingentry| {
            const ing = ingentry.key;
            if (!m.possible.contains(ing)) {
                c += ingentry.value.count();
            }
        }
        return c;
    }

    fn resultLessThan(c: void, a: Result, b: Result) bool {
        return stringLessThan(c, a.all, b.all);
    }

    pub fn Part2(m: *Menu) []const u8 {
        var resList = ArrayList(Result).init(alloc);
        var resLength: usize = 0;
        while (m.possible.count() > 0) {
            var it = m.possible.iterator();
            while (it.next()) |possentry| {
                var ing = possentry.key;
                var allergens = possentry.value;
                if (allergens.count() == 1) {
                    var allit = allergens.iterator();
                    const all = allit.next().?.key;
                    //warn("{} is {}\n", .{ ing, all });
                    resList.append(Result{ .all = all, .ing = ing }) catch unreachable;
                    resLength += ing.len + 1;
                    _ = m.possible.remove(ing);
                    var pit = m.possible.iterator();
                    while (pit.next()) |pe| {
                        _ = pe.value.remove(all);
                    }
                }
            }
        }
        var res = resList.items;
        sort.sort(Result, res, {}, resultLessThan);
        if (resLength == 0) {
            return "";
        }
        var rs = alloc.alloc(u8, resLength) catch unreachable;
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
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var mt = Menu.init(test1) catch unreachable;
    assertEq(@as(usize, 5), mt.Part1());
    var rt = "mxmxvkd,sqjhc,fvjkl";
    assert(std.mem.eql(u8, rt, mt.Part2()));

    var m = Menu.init(inp) catch unreachable;
    assertEq(@as(usize, 2874), m.Part1());
    var r = "gfvrr,ndkkq,jxcxh,bthjz,sgzr,mbkbn,pkkg,mjbtz";
    assert(std.mem.eql(u8, r, m.Part2()));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    var m = try Menu.init(lines);
    try print("Part1: {}\n", .{m.Part1()});
    try print("Part2: {}\n", .{m.Part2()});
}
const std = @import("std");
const aoc = @import("aoc-lib.zig");
const seglist = @import("segmented_list.zig");

const Matcher = struct {
    const Rule = union(enum) {
        str: []const u8,
        opt: []const []const usize,
    };

    rules: std.AutoHashMap(usize, Rule),
    values: [][]const u8,
    alloc: std.mem.Allocator,
    debug: bool,

    pub fn init(alloc: std.mem.Allocator, in: [][]const u8) !*Matcher {
        var rs = std.mem.split(u8, in[0], "\n");
        var r = std.AutoHashMap(usize, Rule).init(alloc);
        while (rs.next()) |l| {
            var ls = std.mem.split(u8, l, ": ");
            const n = try std.fmt.parseUnsigned(usize, ls.next().?, 10);
            const def = ls.next().?;
            if (def[0] == '"') {
                //std.debug.print("CH rule {}\n", .{def[1..2]});
                try r.put(n, Rule{ .str = def[1..2] });
            } else {
                //std.debug.print("OR rule {}\n", .{def});
                var os = std.mem.split(u8, def, " | ");
                var opt = std.ArrayList([]usize).init(aoc.halloc); // use alloc
                defer opt.deinit();
                while (os.next()) |o| {
                    var ovs = std.mem.split(u8, o, " ");
                    var ov = std.ArrayList(usize).init(aoc.halloc); // use alloc
                    defer ov.deinit();
                    while (ovs.next()) |vs| {
                        const v = try std.fmt.parseUnsigned(usize, vs, 10);
                        try ov.append(v);
                    }
                    try opt.append(ov.toOwnedSlice());
                }
                try r.put(n, Rule{ .opt = opt.toOwnedSlice() });
            }
        }
        var vs = std.mem.split(u8, in[1], "\n");
        var vl = std.ArrayList([]const u8).init(alloc);
        defer vl.deinit();
        while (vs.next()) |v| {
            try vl.append(v);
        }
        var self = try alloc.create(Matcher);
        self.alloc = alloc;
        self.rules = r;
        self.values = vl.toOwnedSlice();
        return self;
    }

    pub fn deinit(self: *Matcher) void {
        //var it = self.rules.iterator();
        //while (it.next()) |r| {
        //    switch (r.value_ptr.*) {
        //        .opt => |*opt| {
        //            for (opt.*) |*e| {
        //                self.alloc.free(e.*);
        //            }
        //        },
        //        .str => {
        //        }
        //    }
        //}
        self.rules.deinit();
        self.alloc.free(self.values);
        self.alloc.destroy(self);
    }

    pub fn MatchAux(m: *Matcher, v: []const u8, i: usize, todo: *seglist.SegmentedList(usize, 32)) bool {
        const rem_len = v.len - i;
        if (todo.count() > rem_len) {
            //std.debug.print("more todo but nothing left to match", .{});
            return false;
        } else if (todo.count() == 0 and rem_len == 0) {
            //std.debug.print("nothing todo and nothing left to match!", .{});
            return true;
        } else if (todo.count() == 0 or rem_len == 0) {
            //std.debug.print("run out of something", .{});
            return false;
        }

        //std.debug.print("MA: {}[{}] = {c}\n", .{ v, i, v[i] });
        const rn: usize = todo.pop().?;
        const r = m.rules.get(rn) orelse unreachable;
        switch (r) {
            .str => |*str| {
                //std.debug.print("checking string match {} at {} with {s}\n", .{ v, i, str.* });
                if (v[i] != str.*[0]) {
                    //std.debug.print("  not matched\n", .{});
                    return false;
                } else {
                    //std.debug.print("  matched\n", .{});
                    return m.MatchAux(v, i + 1, todo);
                }
            },
            .opt => |*opt| {
                for (opt.*) |rs| {
                    var todo_n = &seglist.SegmentedList(usize, 32).init(&m.alloc);
                    defer todo_n.deinit();
                    var k: usize = 0;
                    while (k < todo.count()) : (k += 1) {
                        todo_n.push(todo.at(k).*) catch unreachable;
                    }

                    k = rs.len;
                    while (k > 0) : (k -= 1) {
                        todo_n.push(rs[k - 1]) catch unreachable;
                    }
                    if (m.MatchAux(v, i, todo_n)) {
                        return true;
                    }
                }
                return false;
            },
        }
    }

    pub fn Match(m: *Matcher, v: []const u8) bool {
        var todo = &seglist.SegmentedList(usize, 32).init(&m.alloc);
        todo.push(0) catch unreachable;
        const res = m.MatchAux(v, 0, todo);
        return res;
    }

    pub fn Part1(m: *Matcher) usize {
        var s: usize = 0;
        for (m.values) |v| {
            if (m.Match(v)) {
                s += 1;
            }
        }
        return s;
    }

    pub fn Part2(m: *Matcher) usize {
        var a = [_]usize{42};
        var b = [_]usize{ 42, 8 };
        var c = [_][]usize{ a[0..], b[0..] };
        m.rules.put(8, Rule{ .opt = c[0..] }) catch unreachable;
        var d = [_]usize{ 42, 31 };
        var e = [_]usize{ 42, 11, 31 };
        var f = [_][]usize{ d[0..], e[0..] };
        m.rules.put(11, Rule{ .opt = f[0..] }) catch unreachable;
        return m.Part1();
    }
};

test "examples" {
    const test0 = aoc.readChunks(aoc.talloc, aoc.test0file);
    defer aoc.talloc.free(test0);
    const test1 = aoc.readChunks(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const test2 = aoc.readChunks(aoc.talloc, aoc.test2file);
    defer aoc.talloc.free(test2);
    const inp = aoc.readChunks(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    var m = try Matcher.init(aoc.talloc, test0);
    try aoc.assertEq(@as(usize, 1), m.Part1());
    m.deinit();
    m = try Matcher.init(aoc.talloc, test1);
    try aoc.assertEq(@as(usize, 1), m.Part1());
    m.deinit();
    m = try Matcher.init(aoc.talloc, test2);
    try aoc.assertEq(@as(usize, 2), m.Part1());
    m.deinit();
    m = try Matcher.init(aoc.talloc, inp);
    try aoc.assertEq(@as(usize, 285), m.Part1());
    m.deinit();
    m = try Matcher.init(aoc.talloc, inp);
    defer m.deinit();
    try aoc.assertEq(@as(usize, 412), m.Part2());
}

fn day19(inp: []const u8, bench: bool) anyerror!void {
    const chunks = aoc.readChunks(aoc.halloc, inp);
    defer aoc.halloc.free(chunks);
    var m = try Matcher.init(aoc.halloc, chunks);
    var p1 = m.Part1();
    var p2 = m.Part2();
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day19);
}

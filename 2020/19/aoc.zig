usingnamespace @import("aoc-lib.zig");

const Matcher = struct {
    const Rule = union(enum) {
        str: []const u8,
        opt: []const []const usize,
    };

    rules: AutoHashMap(usize, Rule),
    values: [][]const u8,
    debug: bool,

    pub fn init(in: [][]const u8) !*Matcher {
        var rs = split(in[0], "\n");
        var r = AutoHashMap(usize, Rule).init(alloc);
        while (rs.next()) |l| {
            var ls = split(l, ": ");
            const n = try parseUnsigned(usize, ls.next().?, 10);
            const def = ls.next().?;
            if (def[0] == '"') {
                //warn("CH rule {}\n", .{def[1..2]});
                try r.put(n, Rule{ .str = def[1..2] });
            } else {
                //warn("OR rule {}\n", .{def});
                var os = split(def, " | ");
                var opt = ArrayList([]usize).init(alloc);
                while (os.next()) |o| {
                    var ovs = split(o, " ");
                    var ov = ArrayList(usize).init(alloc);
                    while (ovs.next()) |vs| {
                        const v = try parseUnsigned(usize, vs, 10);
                        try ov.append(v);
                    }
                    try opt.append(ov.toOwnedSlice());
                }
                try r.put(n, Rule{ .opt = opt.toOwnedSlice() });
            }
        }
        var vs = split(in[1], "\n");
        var vl = ArrayList([]const u8).init(alloc);
        defer vl.deinit();
        while (vs.next()) |v| {
            try vl.append(v);
        }
        var self = try alloc.create(Matcher);
        self.rules = r;
        self.values = vl.toOwnedSlice();
        return self;
    }

    pub fn MatchAux(m: *Matcher, v: []const u8, i: usize, todo: *SegmentedList(usize, 32)) bool {
        // var q: usize = 0;
        // while (q < todo.count()) {
        //     warn("TD: {}\n", .{todo.at(q).*});
        //     q += 1;
        // }
        const rem_len = v.len - i;
        if (todo.count() > rem_len) {
            //warn("more todo but nothing left to match", .{});
            return false;
        } else if (todo.count() == 0 and rem_len == 0) {
            //warn("nothing todo and nothing left to match!", .{});
            return true;
        } else if (todo.count() == 0 or rem_len == 0) {
            //warn("run out of something", .{});
            return false;
        }

        //warn("MA: {}[{}] = {c}\n", .{ v, i, v[i] });
        const rn: usize = todo.pop().?;
        const r = m.rules.get(rn) orelse unreachable;
        switch (r) {
            .str => |*str| {
                //warn("checking string match {} at {} with {s}\n", .{ v, i, str.* });
                if (v[i] != str.*[0]) {
                    //warn("  not matched\n", .{});
                    return false;
                } else {
                    //warn("  matched\n", .{});
                    return m.MatchAux(v, i + 1, todo);
                }
            },
            .opt => |*opt| {
                for (opt.*) |rs| {
                    var todo_n = &SegmentedList(usize, 32).init(alloc);
                    var k: usize = 0;
                    while (k < todo.count()) {
                        todo_n.push(todo.at(k).*) catch unreachable;
                        k += 1;
                    }

                    k = rs.len;
                    while (k > 0) {
                        todo_n.push(rs[k - 1]) catch unreachable;
                        k -= 1;
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
        var todo = &SegmentedList(usize, 32).init(alloc);
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
    const test0 = readChunks(test0file);
    const test1 = readChunks(test1file);
    const test2 = readChunks(test2file);
    const inp = readChunks(inputfile);

    var m = try Matcher.init(test0);
    assertEq(@as(usize, 1), m.Part1());
    m = try Matcher.init(test1);
    assertEq(@as(usize, 1), m.Part1());
    m = try Matcher.init(test2);
    assertEq(@as(usize, 2), m.Part1());
    m = try Matcher.init(inp);
    assertEq(@as(usize, 285), m.Part1());
    m = try Matcher.init(inp);
    assertEq(@as(usize, 412), m.Part2());
}

pub fn main() anyerror!void {
    const chunks = readChunks(input());
    var m = try Matcher.init(chunks);
    try print("Part1: {}\n", .{m.Part1()});
    try print("Part2: {}\n", .{m.Part2()});
}

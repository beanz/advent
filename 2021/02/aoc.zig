usingnamespace @import("aoc-lib.zig");

const Sub = struct {
    pub const Move = enum(u8) { forward, up, down };
    const Cmd = struct {
        move: Move, units: i64
    };
    cmds: []Cmd,

    pub fn fromInput(inp: anytype, allocator: *Allocator) !*Sub {
        var cmds = try allocator.alloc(Cmd, inp.len);
        var hh = try alloc.create(Sub);
        for (inp) |line, i| {
            var it = split(line, " ");
            const cmdstr = it.next().?;
            const units = try parseInt(i64, it.next().?, 10);
            var move: Move = undefined;
            switch (cmdstr[0]) {
                'f' => {
                    move = .forward;
                },
                'u' => {
                    move = .up;
                },
                'd' => {
                    move = .down;
                },
                else => {
                    unreachable;
                },
            }
            cmds[i].move = move;
            cmds[i].units = units;
        }
        hh.cmds = cmds;
        return hh;
    }

    pub fn part1(self: *Sub) i64 {
        var x: i64 = 0;
        var y: i64 = 0;
        for (self.cmds) |cmd, i| {
            switch (cmd.move) {
                Move.forward => {
                    x += cmd.units;
                },
                Move.up => {
                    y -= cmd.units;
                },
                Move.down => {
                    y += cmd.units;
                },
            }
        }
        return x * y;
    }

    pub fn part2(self: *Sub) i64 {
        var x: i64 = 0;
        var y: i64 = 0;
        var a: i64 = 0;
        for (self.cmds) |cmd, i| {
            switch (cmd.move) {
                Move.forward => {
                    x += cmd.units;
                    y += a * cmd.units;
                },
                Move.up => {
                    a -= cmd.units;
                },
                Move.down => {
                    a += cmd.units;
                },
            }
        }
        return x * y;
    }
};

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    var t = Sub.fromInput(test1, alloc) catch unreachable;
    try assertEq(@as(i64, 150), t.part1());
    try assertEq(@as(i64, 900), t.part2());

    var ti = Sub.fromInput(inp, alloc) catch unreachable;
    try assertEq(@as(i64, 1714950), ti.part1());
    try assertEq(@as(i64, 1281977850), ti.part2());
}

pub fn main() anyerror!void {
    var inp = readLines(input());
    var sub = try Sub.fromInput(inp, alloc);
    try print("Part1: {}\n", .{sub.part1()});
    try print("Part2: {}\n", .{sub.part2()});
}

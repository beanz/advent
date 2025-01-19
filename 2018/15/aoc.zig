const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;
const DX: [4]Int = [4]Int{ 0, -1, 1, 0 };
const DY: [4]Int = [4]Int{ -1, 0, 0, 1 };
const Kind = enum { Elf, Goblin };
const Player = struct {
    ix: Int,
    iy: Int,
    x: Int,
    y: Int,
    kind: Kind,
    hp: Int,
    power: Int,

    fn init(self: *Player, attack: Int) void {
        self.x = self.ix;
        self.y = self.iy;
        self.hp = 200;
        self.power = if (self.kind == Kind.Elf) attack else 3;
    }
    fn less(self: Player, other: Player) bool {
        if (self.y == other.y) {
            return self.x < other.x;
        }
        return self.y < other.y;
    }
};

const Attack = struct {
    x: Int,
    y: Int,
    enemy: usize,
};

const Search = struct {
    sx: Int,
    sy: Int,
    x: Int,
    y: Int,
};

const Game = struct {
    m: []const u8,
    w1: usize,
    players: []Player,
    w: Int,
    h: Int,
    nElf: usize,
    nGoblin: usize,

    fn play(self: *Game, power: Int) anyerror!?usize {
        var num: [2]usize = .{0} ** 2;
        for (0..self.players.len) |i| {
            self.players[i].init(power);
            num[@intFromBool(self.players[i].kind == Kind.Elf)] += 1;
        }
        const initElves = num[1];
        self.nGoblin = num[0];
        self.nElf = num[1];
        var round: usize = 1;
        while (true) {
            std.mem.sort(Player, self.players, {}, turn_cmp);
            for (0..self.players.len) |p| {
                if (self.players[p].hp <= 0) {
                    continue;
                }
                if (power != 3) {
                    if (self.nElf != initElves) {
                        return null;
                    }
                }
                if (self.nElf * self.nGoblin == 0) {
                    var hp: usize = 0;
                    for (self.players) |pp| {
                        if (pp.hp > 0) {
                            hp += @as(usize, @intCast(pp.hp));
                        }
                    }
                    return (round - 1) * hp;
                }
                try self.turnFor(p);
            }
            //aoc.print("round: {}\n", .{round});
            //ry self.pretty();
            round += 1;
        }
        return 0;
    }

    fn pretty(self: Game) anyerror!void {
        aoc.print("e={} g={}\n", .{ self.nElf, self.nGoblin });
        var hp = try std.BoundedArray(Int, 16).init(0);
        var y: Int = 0;
        while (y < self.h) : (y += 1) {
            var x: Int = 0;
            while (x < self.w) : (x += 1) {
                if (self.playerAt(x, y)) |p| {
                    aoc.print("{c}", .{@as(u8, if (self.players[p].kind == Kind.Elf) 'E' else 'G')});
                    try hp.append(self.players[p].hp);
                    continue;
                }
                aoc.print("{c}", .{@as(u8, if (self.emptyAt(x, y)) '.' else '#')});
            }
            aoc.print(" {any}\n", .{hp.slice()});
            try hp.resize(0);
        }
        aoc.print("\n", .{});
    }

    fn turnFor(self: *Game, pl: usize) anyerror!void {
        if (self.target(pl)) |e| {
            self.attack(pl, e);
            return;
        }
        _ = try self.move(pl);
        if (self.target(pl)) |e| {
            self.attack(pl, e);
        }
    }

    fn target(self: Game, pl: usize) ?usize {
        const x = self.players[pl].x;
        const y = self.players[pl].y;
        const enemyKind = if (self.players[pl].kind == Kind.Elf) Kind.Goblin else Kind.Elf;
        return self.targetAt(x, y, enemyKind);
    }

    fn targetAt(self: Game, x: Int, y: Int, enemyKind: Kind) ?usize {
        var enemy: ?usize = null;
        if (self.enemyAt(x, y - 1, enemyKind)) |e| {
            enemy = e;
        }
        if (self.enemyAt(x - 1, y, enemyKind)) |e| {
            if (enemy) |pe| {
                if (self.players[pe].hp > self.players[e].hp) {
                    enemy = e;
                }
            } else {
                enemy = e;
            }
        }
        if (self.enemyAt(x + 1, y, enemyKind)) |e| {
            if (enemy) |pe| {
                if (self.players[pe].hp > self.players[e].hp) {
                    enemy = e;
                }
            } else {
                enemy = e;
            }
        }
        if (self.enemyAt(x, y + 1, enemyKind)) |e| {
            if (enemy) |pe| {
                if (self.players[pe].hp > self.players[e].hp) {
                    enemy = e;
                }
            } else {
                enemy = e;
            }
        }
        return enemy;
    }

    fn enemyAt(self: Game, x: Int, y: Int, kind: Kind) ?usize {
        if (self.playerAt(x, y)) |p| {
            if (self.players[p].kind == kind) {
                return p;
            }
        }
        return null;
    }

    fn playerAt(self: Game, x: Int, y: Int) ?usize {
        for (0..self.players.len) |i| {
            if (self.players[i].x == x and self.players[i].y == y and self.players[i].hp > 0) {
                return i;
            }
        }
        return null;
    }

    fn emptyAt(self: Game, x: Int, y: Int) bool {
        if (self.m[@as(usize, @intCast(x)) + @as(usize, @intCast(y)) * self.w1] == '#') {
            return false;
        }
        return self.playerAt(x, y) == null;
    }

    fn attack(self: *Game, player: usize, enemy: usize) void {
        self.players[enemy].hp -= self.players[player].power;
        if (self.players[enemy].hp <= 0) {
            self.players[enemy].hp = 0;
            if (self.players[enemy].kind == Kind.Elf) {
                self.nElf -= 1;
            } else {
                self.nGoblin -= 1;
            }
        }
    }

    fn move(self: *Game, p: usize) anyerror!bool {
        var todo = try std.BoundedArray(Search, 64).init(0);
        var nextTodo = try std.BoundedArray(Search, 64).init(0);
        for (0..4) |d| {
            const x = self.players[p].x + DX[d];
            const y = self.players[p].y + DY[d];
            if (self.emptyAt(x, y)) {
                try todo.append(Search{ .sx = x, .sy = y, .x = x, .y = y });
            }
        }
        const enemyKind = if (self.players[p].kind == Kind.Elf) Kind.Goblin else Kind.Elf;
        var visited: [1024]bool = .{false} ** 1024;
        var action: ?Attack = null;
        while (todo.len != 0) {
            for (0..todo.len) |j| {
                const cur = todo.get(j);
                if (self.targetAt(cur.x, cur.y, enemyKind)) |enemy| {
                    if (action) |a| {
                        if (self.players[enemy].less(self.players[a.enemy])) {
                            action = Attack{
                                .x = cur.sx,
                                .y = cur.sy,
                                .enemy = enemy,
                            };
                        }
                    } else {
                        action = Attack{
                            .x = cur.sx,
                            .y = cur.sy,
                            .enemy = enemy,
                        };
                    }
                }
                for (0..4) |d| {
                    const x = cur.x + DX[d];
                    const y = cur.y + DY[d];
                    const i = @as(usize, @intCast(32 * y + x));
                    if (self.emptyAt(x, y) and !visited[i]) {
                        visited[i] = true;
                        try nextTodo.append(Search{ .sx = cur.sx, .sy = cur.sy, .x = x, .y = y });
                    }
                }
            }
            if (action) |a| {
                self.players[p].x = a.x;
                self.players[p].y = a.y;
                return true;
            }
            std.mem.swap(std.BoundedArray(Search, 64), &todo, &nextTodo);
            try nextTodo.resize(0);
        }
        return false;
    }
};

fn turn_cmp(_: void, a: Player, b: Player) bool {
    return a.less(b);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var pl = try std.BoundedArray(Player, 32).init(0);
    var u: usize = 0;
    var nElf: usize = 0;
    var nGoblin: usize = 0;
    {
        var x: Int = 0;
        var y: Int = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    u = @intCast(x);
                    y += 1;
                    x = 0;
                },
                '.', '#' => x += 1,
                'E' => {
                    try pl.append(Player{ .ix = x, .iy = y, .x = 0, .y = 0, .kind = Kind.Elf, .hp = 0, .power = 0 });
                    nElf += 1;
                    x += 1;
                },
                'G' => {
                    try pl.append(Player{ .ix = x, .iy = y, .x = 0, .y = 0, .kind = Kind.Goblin, .hp = 0, .power = 0 });
                    nGoblin += 1;
                    x += 1;
                },
                else => unreachable,
            }
        }
    }
    const w1 = u + 1;
    var g = Game{
        .m = inp,
        .w1 = w1,
        .players = pl.slice(),
        .w = @intCast(u),
        .h = @intCast(@divFloor(inp.len, w1)),
        .nElf = nElf,
        .nGoblin = nGoblin,
    };

    const p1 = (try g.play(3)).?;

    var power: Int = 4;
    while (true) : (power += 1) {
        const res = try g.play(power);
        if (res) |p2| {
            return [2]usize{ p1, p2 };
        }
    }
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

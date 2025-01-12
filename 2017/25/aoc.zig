const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const PARSER_TEMPLATE =
    \\In state `state:C`:
    \\  If the current value is 0:
    \\    - Write the value `v0:C`.
    \\    - Move one slot to the `m0:W`.
    \\    - Continue with state `n0:C`.
    \\  If the current value is 1:
    \\    - Write the value `v1:C`.
    \\    - Move one slot to the `m1:W`.
    \\    - Continue with state `n1:C`.
;

fn ParseStruct(comptime template: []const u8) type {
    var s = try std.BoundedArray(std.builtin.Type.StructField, 16).init(0);
    var o = try std.BoundedArray(usize, 16).init(0);
    var i: usize = 0;
    var j = i;
    while (i < template.len) : (i += 1) {
        if (template[i] != '`') {
            continue;
        }
        try o.append(i - j);
        i += 1;
        const ns = i;
        while (template[i] != ':') : (i += 1) {}
        const name = template[ns..i];
        i += 1;
        const t = template[i];
        i += 1;
        if (template[i] != '`') {
            @compileError("missing closing backtick in struct template");
        }
        i += 1;
        j = i;
        const U = switch (t) {
            'C' => u8,
            'W' => []u8,
            else => @compileError("invalid field type"),
        };
        try s.append(std.builtin.Type.StructField{
            .name = name ++ "",
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(U),
            .type = U,
        });
    }
    try o.append(i - j);
    return @Type(.{
        .Struct = .{
            .layout = std.builtin.Type.ContainerLayout.auto,
            .fields = s.slice(),
            .decls = &[_]std.builtin.Type.Declaration{},
            .is_tuple = false,
        },
    });
}

const Rec = ParseStruct(PARSER_TEMPLATE);

fn parts(inp: []const u8) anyerror![2]usize {
    const r = Rec{};
    aoc.print("{any}\n", r);
    return [2]usize{ inp.len, 0 };
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

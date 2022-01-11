const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Operator = enum { plus, times };
const Bracket = enum { open, close };
const TokenType = enum { operand, operator, bracket };
const Token = union(TokenType) {
    operand: usize,
    operator: Operator,
    bracket: Bracket,
};

pub fn RPN(alloc: std.mem.Allocator, exp: []Token) usize {
    var stack = std.ArrayList(usize).init(alloc);
    defer stack.deinit();
    for (exp) |t| {
        switch (t) {
            .operand => |*n| {
                stack.append(n.*) catch unreachable;
            },
            .operator => |*op| {
                const l: usize = stack.items.len;
                var first = stack.items[l - 1];
                var second = stack.items[l - 2];
                _ = stack.orderedRemove(l - 1);
                if (op.* == .plus) {
                    stack.items[l - 2] = first + second;
                } else {
                    stack.items[l - 2] = first * second;
                }
            },
            .bracket => {
                std.debug.panic("brackets not allowed here", .{});
            },
        }
    }
    aoc.assertEq(@as(usize, 1), stack.items.len) catch unreachable;
    return stack.items[stack.items.len - 1];
}

pub fn ShuntingYard(alloc: std.mem.Allocator, s: []const u8, isPart2: bool) []Token {
    var output = std.ArrayList(Token).init(alloc);
    defer output.deinit();
    var operator = std.ArrayList(Token).init(alloc);
    defer operator.deinit();
    var i: usize = 0;
    while (i < s.len) : (i += 1) {
        const term = s[i];
        switch (term) {
            ' ' => {
                continue;
            },
            '0'...'9' => {
                output.append(Token{ .operand = @as(usize, (term - '0')) }) catch unreachable;
            },
            '+', '*' => {
                while (operator.items.len > 0) {
                    const peek = operator.items[operator.items.len - 1];
                    switch (peek) {
                        .operator => {
                            if (isPart2 and peek.operator == Operator.times) {
                                break;
                            }
                            output.append(peek) catch unreachable;
                            _ = operator.orderedRemove(operator.items.len - 1);
                        },
                        else => {
                            break;
                        },
                    }
                }
                if (term == '+') {
                    operator.append(Token{ .operator = .plus }) catch unreachable;
                } else {
                    operator.append(Token{ .operator = .times }) catch unreachable;
                }
            },
            '(' => {
                operator.append(Token{ .bracket = .open }) catch unreachable;
            },
            ')' => {
                while (operator.items.len > 0) {
                    const peek = operator.items[operator.items.len - 1];
                    switch (peek) {
                        .operator => {
                            output.append(peek) catch unreachable;
                            _ = operator.orderedRemove(operator.items.len - 1);
                        },
                        else => {
                            break;
                        },
                    }
                }
                if (operator.items.len > 0 and
                    operator.items[operator.items.len - 1].bracket == Bracket.open)
                {
                    _ = operator.orderedRemove(operator.items.len - 1);
                }
            },
            else => {},
        }
    }
    while (operator.items.len > 0) {
        output.append(operator.items[operator.items.len - 1]) catch unreachable;
        _ = operator.orderedRemove(operator.items.len - 1);
    }
    return output.toOwnedSlice();
}

pub fn Calc(alloc: std.mem.Allocator, s: []const u8, isPart2: bool) usize {
    var sy = ShuntingYard(alloc, s, isPart2);
    defer alloc.free(sy);
    return RPN(alloc, sy);
}

pub fn part1(alloc: std.mem.Allocator, s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(alloc, l, false);
    }
    return t;
}

pub fn part2(alloc: std.mem.Allocator, s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(alloc, l, true);
    }
    return t;
}

test "RPN" {
    var exp = [1]Token{Token{ .operand = 2 }};
    try aoc.assertEq(@as(usize, 2), RPN(aoc.talloc, exp[0..]));
    var exp3 = [3]Token{
        Token{ .operand = 2 },
        Token{ .operand = 3 },
        Token{ .operator = .plus },
    };
    try aoc.assertEq(@as(usize, 5), RPN(aoc.talloc, exp3[0..]));
    var exp5 = [5]Token{
        Token{ .operand = 3 },
        Token{ .operand = 4 },
        Token{ .operand = 5 },
        Token{ .operator = .times },
        Token{ .operator = .plus },
    };
    try aoc.assertEq(@as(usize, 23), RPN(aoc.talloc, exp5[0..]));
}

test "ShuntingYard" {
    var sy = ShuntingYard(aoc.talloc, "2 + 3", false);
    defer aoc.talloc.free(sy);
    try aoc.assertEq(@as(usize, 3), sy.len);
    var sy2 = ShuntingYard(aoc.talloc, "2 + 3", false);
    defer aoc.talloc.free(sy2);
    try aoc.assertEq(@as(usize, 5), RPN(aoc.talloc, sy2));
}

test "Calc" {
    try aoc.assertEq(@as(usize, 9), Calc(aoc.talloc, "9", false));
    try aoc.assertEq(@as(usize, 5), Calc(aoc.talloc, "2 + 3", false));
    try aoc.assertEq(@as(usize, 6), Calc(aoc.talloc, "2 * 3", false));
    try aoc.assertEq(@as(usize, 9), Calc(aoc.talloc, "1 + 2 * 3", false));
    try aoc.assertEq(@as(usize, 6), Calc(aoc.talloc, "(2 * 3)", false));
    try aoc.assertEq(@as(usize, 9), Calc(aoc.talloc, "(1 + 2) * 3", false));
    try aoc.assertEq(@as(usize, 7), Calc(aoc.talloc, "1 + (2 * 3)", false));
    try aoc.assertEq(@as(usize, 71), Calc(aoc.talloc, "1 + 2 * 3 + 4 * 5 + 6", false));
    try aoc.assertEq(@as(usize, 51), Calc(aoc.talloc, "1 + (2 * 3) + (4 * (5 + 6))", false));
    try aoc.assertEq(@as(usize, 26), Calc(aoc.talloc, "2 * 3 + (4 * 5)", false));
    try aoc.assertEq(@as(usize, 437), Calc(aoc.talloc, "5 + (8 * 3 + 9 + 3 * 4 * 3)", false));
    try aoc.assertEq(@as(usize, 12240), Calc(aoc.talloc, "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", false));
    try aoc.assertEq(@as(usize, 13632), Calc(aoc.talloc, "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", false));
}

test "Calc2" {
    try aoc.assertEq(@as(usize, 231), Calc(aoc.talloc, "1 + 2 * 3 + 4 * 5 + 6", true));
    try aoc.assertEq(@as(usize, 51), Calc(aoc.talloc, "1 + (2 * 3) + (4 * (5 + 6))", true));
    try aoc.assertEq(@as(usize, 46), Calc(aoc.talloc, "2 * 3 + (4 * 5)", true));
    try aoc.assertEq(@as(usize, 1440), Calc(aoc.talloc, "8 * 3 + 9 + 3 * 4 * 3", true));
    try aoc.assertEq(@as(usize, 1445), Calc(aoc.talloc, "5 + (8 * 3 + 9 + 3 * 4 * 3)", true));
    try aoc.assertEq(@as(usize, 669060), Calc(aoc.talloc, "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", true));
    try aoc.assertEq(@as(usize, 23340), Calc(aoc.talloc, "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", true));
}

test "examples" {
    const test1 = aoc.readLines(aoc.talloc, aoc.test1file);
    defer aoc.talloc.free(test1);
    const inp = aoc.readLines(aoc.talloc, aoc.inputfile);
    defer aoc.talloc.free(inp);

    try aoc.assertEq(@as(usize, 26457), part1(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 694173), part2(aoc.talloc, test1));
    try aoc.assertEq(@as(usize, 510009915468), part1(aoc.talloc, inp));
    try aoc.assertEq(@as(usize, 321176691637769), part2(aoc.talloc, inp));
}

fn day18(inp: []const u8, bench: bool) anyerror!void {
    const lines = aoc.readLines(aoc.halloc, inp);
    defer aoc.halloc.free(lines);
    var p1 = part1(aoc.halloc, lines);
    var p2 = part2(aoc.halloc, lines);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day18);
}

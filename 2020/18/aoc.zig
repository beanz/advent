usingnamespace @import("aoc-lib.zig");

const Operator = enum { plus, times };
const Bracket = enum { open, close };
const TokenType = enum { operand, operator, bracket };
const Token = union(TokenType) {
    operand: usize,
    operator: Operator,
    bracket: Bracket,
};

pub fn RPN(exp: []Token) usize {
    var stack = ArrayList(usize).init(alloc);
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
                debug.panic("brackets not allowed here", .{});
            },
        }
    }
    assertEq(@as(usize, 1), stack.items.len) catch unreachable;
    return stack.items[stack.items.len - 1];
}

pub fn ShuntingYard(s: []const u8, part2: bool) []Token {
    var output = ArrayList(Token).init(alloc);
    defer output.deinit();
    var operator = ArrayList(Token).init(alloc);
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
                            if (part2 and peek.operator == Operator.times) {
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

pub fn Calc(s: []const u8, part2: bool) usize {
    return RPN(ShuntingYard(s, part2));
}

pub fn Part1(s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(l, false);
    }
    return t;
}

pub fn Part2(s: [][]const u8) usize {
    var t: usize = 0;
    for (s) |l| {
        t += Calc(l, true);
    }
    return t;
}

test "RPN" {
    var exp = [1]Token{Token{ .operand = 2 }};
    try assertEq(@as(usize, 2), RPN(exp[0..]));
    var exp3 = [3]Token{
        Token{ .operand = 2 },
        Token{ .operand = 3 },
        Token{ .operator = .plus },
    };
    try assertEq(@as(usize, 5), RPN(exp3[0..]));
    var exp5 = [5]Token{
        Token{ .operand = 3 },
        Token{ .operand = 4 },
        Token{ .operand = 5 },
        Token{ .operator = .times },
        Token{ .operator = .plus },
    };
    try assertEq(@as(usize, 23), RPN(exp5[0..]));
}

test "ShuntingYard" {
    var exp = [1]Token{Token{ .operand = 2 }};
    try assertEq(@as(usize, 3), ShuntingYard("2 + 3", false).len);
    try assertEq(@as(usize, 5), RPN(ShuntingYard("2 + 3", false)));
}

test "Calc" {
    try assertEq(@as(usize, 9), Calc("9", false));
    try assertEq(@as(usize, 5), Calc("2 + 3", false));
    try assertEq(@as(usize, 6), Calc("2 * 3", false));
    try assertEq(@as(usize, 9), Calc("1 + 2 * 3", false));
    try assertEq(@as(usize, 6), Calc("(2 * 3)", false));
    try assertEq(@as(usize, 9), Calc("(1 + 2) * 3", false));
    try assertEq(@as(usize, 7), Calc("1 + (2 * 3)", false));
    try assertEq(@as(usize, 71), Calc("1 + 2 * 3 + 4 * 5 + 6", false));
    try assertEq(@as(usize, 51), Calc("1 + (2 * 3) + (4 * (5 + 6))", false));
    try assertEq(@as(usize, 26), Calc("2 * 3 + (4 * 5)", false));
    try assertEq(@as(usize, 437), Calc("5 + (8 * 3 + 9 + 3 * 4 * 3)", false));
    try assertEq(@as(usize, 12240), Calc("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", false));
    try assertEq(@as(usize, 13632), Calc("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", false));
}

test "Calc2" {
    try assertEq(@as(usize, 231), Calc("1 + 2 * 3 + 4 * 5 + 6", true));
    try assertEq(@as(usize, 51), Calc("1 + (2 * 3) + (4 * (5 + 6))", true));
    try assertEq(@as(usize, 46), Calc("2 * 3 + (4 * 5)", true));
    try assertEq(@as(usize, 1440), Calc("8 * 3 + 9 + 3 * 4 * 3", true));
    try assertEq(@as(usize, 1445), Calc("5 + (8 * 3 + 9 + 3 * 4 * 3)", true));
    try assertEq(@as(usize, 669060), Calc("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", true));
    try assertEq(@as(usize, 23340), Calc("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", true));
}

test "examples" {
    const test1 = readLines(test1file);
    const inp = readLines(inputfile);

    try assertEq(@as(usize, 26457), Part1(test1));
    try assertEq(@as(usize, 694173), Part2(test1));
    try assertEq(@as(usize, 510009915468), Part1(inp));
    try assertEq(@as(usize, 321176691637769), Part2(inp));
}

pub fn main() anyerror!void {
    const lines = readLines(input());
    try print("Part1: {}\n", .{Part1(lines)});
    try print("Part2: {}\n", .{Part2(lines)});
}

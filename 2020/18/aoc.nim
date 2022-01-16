import aoclib

type
  Bracket = enum Open, Close
  Op      = enum Plus, Times

type
  RPNKind {.pure.} = enum rkOp, rkInt
  RPNToken {.final, shallow.} = object
    case kind: RPNKind
    of rkOp:
      op: Op
    of rkInt:
      val: int

type
  ShuntKind = enum skOp, skBracket, skInt
  ShuntToken {.final, shallow.} = object
    case kind: ShuntKind
    of skBracket:
      bracket: Bracket
    of skOp:
      op: Op
    of skInt:
      val: int

proc rpn(exp : seq[RPNToken]) : int =
  var stack = initDeque[int]()
  for term in exp:
    case term.kind
    of rkInt:
      stack.addLast(term.val)
    of rkOp:
      var first = stack.popLast
      var second = stack.popLast
      var v : int = if term.op == Plus: first + second else: first * second
      stack.addLast(v)
  return stack.popLast

proc shuntingYard(s : string, part2 : bool) : seq[RPNToken] =
  var output : seq[RPNToken] = @[]
  var op = initDeque[ShuntToken]()
  for ch in s:
    case ch
    of ' ':
      discard
    of '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
      output.add(RPNToken(kind: rkInt, val: ord(ch) - ord('0')))
    of '+', '*':
      while op.len > 0:
        var peek = op.peekLast
        case peek.kind
        of skOp:
          if part2 and peek.op == Times:
            break
          var rpn = RPNToken(kind: rkOp, op: peek.op)
          output.add(rpn)
          discard op.popLast
        else:
          break
      if ch == '+':
        op.addLast(ShuntToken(kind: skOp, op: Plus))
      else:
        op.addLast(ShuntToken(kind: skOp, op: Times))
    of '(':
      op.addLast(ShuntToken(kind: skBracket, bracket: Open))
    of ')':
      while op.len > 0:
        var peek = op.peekLast
        case peek.kind
        of skOp:
          var rpn = RPNToken(kind: rkOp, op: peek.op)
          output.add(rpn)
          discard op.popLast
        else:
          break
      if op.len > 0:
        var peek = op.peekLast
        if peek.kind == skBracket and peek.bracket == Open:
          discard op.popLast
    else:
      raise newException(ValueError, "invalid expression: " & s)
  while op.len > 0:
    var peek = op.peekLast
    case peek.kind
    of skOp:
      var rpn = RPNToken(kind: rkOp, op: peek.op)
      output.add(rpn)
    of skInt:
      var rpn = RPNToken(kind: rkInt, val: peek.val)
      output.add(rpn)
    else:
      raise newException(ValueError, "unexpected bracket")
    discard op.popLast
  return output

proc calc(inp : seq[string], part2 : bool) : int =
  var s = 0
  for l in inp:
    s += rpn(shuntingYard(l, part2))
  return s

proc part1(inp : seq[string]) : int =
  return calc(inp, false)

proc part2(inp : seq[string]) : int =
  return calc(inp, true)

const input = staticRead"input.txt"

benchme(input, proc (inp: string, bench: bool): void =
  var l = Lines(inp)
  let p1 = part1(l)
  let p2 = part2(l)
  if not bench:
    echo "Part 1: ", p1
    echo "Part 2: ", p2
)

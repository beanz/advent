require "aoc-lib.cr"

enum Operator
  Plus
  Times
end

enum Bracket
  Open
  Close
end

def rpn(exp : Array(Int64 | Operator))
  stack = Array(Int64).new
  exp.each do |term|
    case term
    when Int64
      stack << term
    when Operator
      first = stack.pop
      second = stack.pop
      if term == Operator::Plus
        stack << first + second
      else
        stack << first * second
      end
    end
  end
  return stack.pop
end

def shunting_yard(s : String, part2 : Bool)
  output = Array(Int64 | Operator).new
  operator = Array(Int64 | Operator | Bracket).new
  s.chars.each do |ch|
    case ch
    when ' '
      next
    when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
      output << ch.to_i64
    when '+', '*'
      while operator.size > 0
        peek = operator.last
        case peek
        when Operator
          if part2 && peek == Operator::Times
            break
          end
          output << peek
          operator.pop
        else
          break
        end
      end
      if ch == '+'
        operator << Operator::Plus
      else
        operator << Operator::Times
      end
    when '('
      operator << Bracket::Open
    when ')'
      while operator.size > 0
        peek = operator.last
        case peek
        when Operator
          output << peek
          operator.pop
        else
          break
        end
      end
      if operator.size > 0
        peek = operator.last
        case peek
        when Bracket::Open
          operator.pop
        end
      end
    end
  end
  while operator.size > 0
    peek = operator.last
    case peek
    when Operator, Int
      output << peek
      operator.pop
    else
      raise "Unexpected bracket?"
    end
  end
  return output
end

def calc(s : String, part2 : Bool)
  res = rpn(shunting_yard(s, part2))
  return res
end

def part1(inp)
  return inp.map { |l| calc(l, false) }.sum
end

def part2(inp)
  return inp.map { |l| calc(l, true) }.sum
end

inp = readinputlines()
print "Part 1: ", part1(inp), "\n"
print "Part 2: ", part2(inp), "\n"

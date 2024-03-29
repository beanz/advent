def benchme(embedded)
  start = Time.monotonic
  is_bench = ENV.has_key?("AoC_BENCH")
  bench_time = Time::Span.new(seconds: 1)
  iterations = 0.0_f64
  loop do
    yield input(embedded), is_bench
    iterations += 1
    if !is_bench
      break
    end
    elapsed = Time.monotonic - start
    if elapsed > bench_time
      print "bench ", iterations, " iterations in ", elapsed.total_nanoseconds, "ns: ", elapsed.total_nanoseconds/iterations ,"ns\n"
      break
    end
  end
end

def input(embedded)
  if ARGV.size > 0
    return File.read(ARGV[0])
  end
  return embedded
end

def inputlines(i)
  return i.rstrip("\n").split(/\n/)
end

def inputlists(i, sep = /[-,: ]+/)
  return inputlines(i).map &.split(sep)
end

def inputchunks(i)
  return i.rstrip("\n\n").split("\n\n")
end

def inputchunkyrecords(i)
  res = Array(Hash(String, String)).new
  i.rstrip("\n\n").split("\n\n").each do |c|
    m = Hash(String, String).new
    c.split(/\s+/).each do |r|
      rs = r.split(":")
      m[rs[0]] = rs[1]
    end
    res.push(m)
  end
  return res
end

def inputfile()
  if ARGV.size > 0
    return ARGV[0]
  end
  return "input.txt"
end

def istest?()
  return inputfile() != "input.txt"
end

def readlines(file)
  File.read(file).rstrip("\n").split("\n")
end

def readinputlines()
  readlines(inputfile())
end

def readints(file)
  File.read(file).rstrip("\n").split(/[\n, ]/).map &.to_i64
end

def readinputints()
  readints(inputfile())
end

def readlists(file, sep = /[-,: ]+/)
  File.read(file).rstrip("\n").split("\n")
end

def readinputlists(sep = /[-,: ]+/)
  readlists(inputfile(), sep)
end

def readchunks(file)
  File.read(file).rstrip("\n\n").split("\n\n")
end

def readinputchunks()
  readchunks(inputfile())
end

def readchunkyrecords(file)
  res = Array(Hash(String, String)).new
  File.read(file).rstrip("\n\n").split("\n\n").each do |c|
    m = Hash(String, String).new
    c.split(/\s+/).each do |r|
      rs = r.split(":")
      m[rs[0]] = rs[1]
    end
    res.push(m)
  end
  return res
end

def readinputchunkyrecords()
  readchunkyrecords(inputfile())
end

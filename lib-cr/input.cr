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
  File.read(file).rstrip("\n").split("\n").map &.split(sep)
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

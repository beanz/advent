def readlines(file)
  File.read(file).rstrip("\n").split("\n")
end

def readints(file)
  File.read(file).rstrip("\n").split(",").map &.to_i64
end


def debug()
  return ENV.has_key?("AoC_DEBUG")
end

def test()
  return ENV.has_key?("AoC_TEST")
end

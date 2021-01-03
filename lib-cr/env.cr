def DEBUG()
  return ENV.has_key?("AoC_DEBUG")
end

def TEST()
  return ENV.has_key?("AoC_TEST")
end

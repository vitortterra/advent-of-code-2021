curr = nil
count = 0
ARGF.each_line do |line|
  prev = curr
  curr = line.to_i
  if ARGF.lineno > 1 and curr > prev
    count += 1
  end
end

puts count
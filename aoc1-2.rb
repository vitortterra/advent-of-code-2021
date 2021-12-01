WIN_SIZE = 3 # previous exercise: size == 1
window = []
window_count = 0
increase_count = 0
prev_window_count = nil

ARGF.each_line do |line|
  if window.length() == WIN_SIZE
    prev_window_count = window_count
    window_count -= window.shift()
  end

  window.push(line.to_i)
  window_count += window.last()

  unless prev_window_count.nil?
    if window_count > prev_window_count
      increase_count += 1
    end
  end
end

puts increase_count
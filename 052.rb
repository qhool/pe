def srtdigits( n )
  n.to_s.split('').sort().join('')
end

mag = 10
best_max = 2
while true do
  (0..(mag-1)).each { |i|
    n = mag + i
    baseline = srtdigits( n * 2 )
    max_mult = 2
    (3..6).each { |m|
      break if srtdigits( n * m ) != baseline
      max_mult = m
    }
    if max_mult > best_max then
      print n.to_s + " works up to " + max_mult.to_s + "X\n"
      best_max = max_mult
    end
  }
  mag *= 10
end

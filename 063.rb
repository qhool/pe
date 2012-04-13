tot = 0

(1..9).each { |n|
  (1..25).each { |p|
    x = n**p
    #if x.to_s.length < p then
    #  break
    #els
    if x.to_s.length == p then
      tot += 1
    end
  }
}
print tot, "\n"

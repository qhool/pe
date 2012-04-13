non_bouncy = 0;
increasing = 0;
decreasing = 0;
bothing = 0;


(1..999999).each do |n|
  digits = n.to_s.split('').map { |d| d.to_i }
  ascends = false
  descends = false
  (1..digits.size - 1).each do |i|
    if digits[i-1] > digits[i] then
      descends = true
    elsif digits[i-1] < digits[i] then
      ascends = true
    end
  end
  if ascends and descends then
    #print n, "\n"
    true
  else
    #non bouncy
    non_bouncy += 1
    if not ascends then
      decreasing += 1
    end
    if not descends then
      increasing += 1
      if not ascends then
        print n, "\n"
        bothing += 1
      end
    end
  end
end

print "non_bouncy = ", non_bouncy, "\n"
print "increasing = ", increasing, "\n"
print "decreasing = ", decreasing,"\n" 
print "both = ", bothing, "\n"

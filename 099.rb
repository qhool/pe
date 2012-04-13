n = 0
max_n = 0
max_val = 0
IO.foreach("base_exp.txt") {
  |line|
  n+=1
  (b, e) = line.chomp().split(',').map { |s| s.to_i() } 
  #print b,"\n"
  val = e*Math.log(b)
  if( val > max_val )
      max_val = val
      max_n = n
  end
}

print "line: ", max_n, "\n";

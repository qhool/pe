$pile_nums = [1,1,2,3]
$pile_at_least = [[]]
$pile_nums2 = [1,1,2,3]
$no_ones = []

def pile_num_at_least( n, min_pile )
  num = 0
  while $pile_at_least.length < n+1 do
    $pile_at_least << []
  end
  if $pile_at_least[n].length > min_pile and $pile_at_least[n][min_pile] != nil then
    return $pile_at_least[n][min_pile]
  end
  (0..(n - min_pile)).each { |remainder|
    num += $pile_nums[remainder]
    if remainder > (n/2) then
      num -= pile_num_at_least( remainder, n - remainder + 1 )
    end
  }
  #print "pile_num_at_least( ", n, ", ", min_pile, ") = ", num, "\n"
  $pile_at_least[n][min_pile] = num
  return num
end

def no_onesies( n, biggest = nil ) #, preamble = "" )
  tot = 0

  #biggest ||= n - 2
  if n < 2 then
    #print "0\n"
    return 0
  elsif biggest == 2 then
    if 2*(n/2) == n then
      return 1
    else
    #print "0\n"
      return 0
    end
  elsif n < 4 then
    #print preamble, "*" * n, "\n"
    return 1
  end

  if biggest == nil or biggest >= n then
    if $no_ones.length > n and $no_ones[n] != nil then
      #print "x"
      return $no_ones[n]
    end
    #print "."
    biggest = n - 2
    #print preamble, "*" * n, " ]\n"
    tot += 1
  #else
  #  print "_"
  end
  # print "No onesies( ", n, ", ", biggest, " )\n"
  while biggest > 1 do
    tot += no_onesies( n - biggest, biggest ) #, preamble + "*" * biggest + " " )
    biggest -= 1
  end
  #print tot, "\n"
  $no_ones[n] = tot
  return tot
end
    
def pile_num( n )
  if $pile_nums.length < n+1
    ($pile_nums.length..n).each { |x|
      $pile_nums << pile_num_at_least( x, 1 )
    }
  end
  return $pile_nums[n]
end

def pile_num2( n )
  if $pile_nums2.length < n+1
    ($pile_nums2.length..n).each { |x|
      $pile_nums2 << $pile_nums2[x-1] + no_onesies(x)
    }
  end
  return $pile_nums2[n]  
end

(2..30).each { |n|
  p = pile_num(n)
  print n, " --> ", p, "\n" #"\t", p - pile_num(n-1), " ", no_onesies(n), "\n"
}




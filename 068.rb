numbers = [1,2,3,4,5,6,7,8,9]

num_combos = 0
num_solutions = 0
#to construct a magic 5-gon, take half of the numbers from 1 to nine
numbers.combination(4).each { |outer_nums|
  start = outer_nums.min
  inner_nums = numbers - outer_nums
  outer_nums.delete(start)
  outer_nums << 10 #since we want 10 digit strings, 10 is always on the outside
  #print "Start: ", start, "\n"
  #print "Outer: \t\t", outer_nums, "\n"
  #print "Inner: \t\t\t\t", inner_nums, "\n"
  outer_nums.permutation.each { |outer|
    outer.unshift( start )
    inner_nums.permutation.each { |inner|
      combo = outer + inner
      num_combos += 1
      prev_sum = nil
      valid = true
      disp = ""
      (0..4).each { |i|
        line = [combo[i], combo[5+i], combo[5+(i+1)%5]]
        sum = line.reduce(:+)
        disp += line.join("")
        if prev_sum != nil and sum != prev_sum then
          valid = false
          break
        end
        prev_sum = sum
      }
      if valid then
        print disp, "\n"
        num_solutions += 1
      end
      
    }
  }
}
print num_solutions, " solutions out of ", num_combos," combinations\n"

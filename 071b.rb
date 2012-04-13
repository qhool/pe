require 'rational'

tgt = Rational(3,7)

max_d = 1000000

guess_low = Rational((max_d/7)*3 - 1, (max_d/7)*7 )
guess_high = Rational((max_d/7)*3 + 1, (max_d/7)*7 )

mods_range_start = 2
mods_range = mods_range_start
def gen_mods(r)
  mods = []
  (-r..r).each { |i|
    (-r..r).each { |j| mods.push([i,j]) if i >0 and j > 0 }
  }
  return mods
end
mods = gen_mods(mods_range)

num_guesses = 0
static_cycles = 0
dyn_cycles = 0
while true do
  #print guess_low, " < ", tgt, " < ", guess_high, "\n"
  num_guesses += 1
  if num_guesses % 1000 == 1 then
    print tgt.to_f - guess_low.to_f, " --> <-- ", 
    guess_high.to_f - tgt.to_f , "\n" 
  end
  #break if (tgt.to_f - guess_low.to_f) < 1e-6
  candidates = [guess_low,guess_high] 
  mods.each do
    |mod|
    [guess_low,guess_high].each do
      |guess|
      denom = guess.denominator + mod[1]
      if denom <= max_d then
        candidates.push( Rational( guess.numerator + mod[0], 
                                   denom ) )
      end
    end
  end
  candidates.delete_if{ |c| c == tgt }
  candidates.sort!
  #candidates.each do
  #  |c|
  #  print c.to_f, "\n"
  #end
  best_low = nil
  best_high = nil
  candidates.each do
    |c|
    if c > tgt then
      best_high = c
      break
    else
      best_low = c
    end
  end
  if [best_low,best_high] == [guess_low,guess_high] then
    static_cycles += 1
    break if static_cycles > 50
    mods_range += 1
    #print "MR: ", mods_range, "\n"
    mods = gen_mods(mods_range)
  elsif mods_range > mods_range_start then
    static_cycles = 0
    dyn_cycles += 1
    if dyn_cycles > 50*(60 - mods_range) then
      mods_range -= 1
      #print "MR: ", mods_range, "\n"
      mods = gen_mods(mods_range)
    end
  end
  guess_low, guess_high = best_low, best_high
end

print "best guess: ", guess_low, "\n"

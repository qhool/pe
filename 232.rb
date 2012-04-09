require 'rational'


def go_over(current_score) 
  return go_under(current_score) + 2
end

def go_under(current_score)
  return [(Math.log(100-current_score)/Math.log(2)).to_i,1].max
end

def overunder(round,current_score)
  if round%2 == 0
    return go_over(current_score)
  else
    return go_under(current_score)
  end
end

def mixed(round,current_score)
  val = [(Math.log([((200-round)),2].max)/Math.log(2)).to_i,1].max
  if current_score == 0
    print "t: ", val, "\n"
  end
  return val
end

def probability_round!( score_probabilities )
  new_probs = Array.new(score_probabilities.size,0)
  old_win_chance = score_probabilities[100]
  score_probabilities.each_with_index do |prob,score|
    next if prob == nil or prob == 0
    if score >= 100
      new_probs[score] += prob
    elsif prob != nil and prob != 0
      t = yield score
      possible_score = [score + 2**(t-1),100].min
      new_probs[score] += prob * (1 - Rational(1,2**t))
      new_probs[possible_score] += prob * Rational(1,2**t) 
    end
  end
  new_probs.each_with_index do |x,i|
    score_probabilities[i] = x
  end
  win_delta = score_probabilities[100] - old_win_chance
  #what fraction of the non-winning probabilities moved to winning
  return win_delta / (1 - old_win_chance)
end

def fmt_bf( n )
  if n > 10**50 
    print "exceeded!"
    exit
  end
  return "0." + sprintf( "%050d", n ) [-50..-43]
end

p1_dist = [1] + Array.new(100,0)
p2_dist = [1] + Array.new(100,0)
scale = 10**50
p1_cum_win = 0
p2_cum_win = 0 
cum_tie = 0
cum_loss = scale
1000.times { |round|
  p1_win_chance = probability_round!( p1_dist ) { 1 }
  p2_win_chance = probability_round!( p2_dist ) { |score| go_under(score) }
  #the chance that a player wins this round is the prob that the player
  #goes over 100 this round, times the prob that no-one has one before now
  p1_win_chance = ( p1_win_chance * scale ).to_i
  p2_win_chance = ( p2_win_chance * scale ).to_i
  #print fmt_bf(p1_win_chance), " / ", fmt_bf(p2_win_chance), "\n"
  tie_chance = (p1_win_chance * p2_win_chance)/scale
  #print fmt_bf(cum_loss), "\n"
  p1_cum_win += (cum_loss * (p1_win_chance - tie_chance))/scale
  p2_cum_win += (cum_loss * (p2_win_chance - tie_chance))/scale
  print round,  ': ', fmt_bf(p2_cum_win) , "\n"
  cum_tie += (cum_loss * tie_chance)/scale
  cum_loss = (cum_loss*(scale - (p1_win_chance + p2_win_chance - 2 * tie_chance)))/scale
}

#score_dist.each_with_index do |prob,score|
#  if score == 100
#    print "---------------\n"
#    break
#  end
#  print prob.to_f, "\n"
#end


#print "\n\n\n", win_probability(score_dist).to_f, "\n"

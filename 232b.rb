require 'rational'
require 'bigfloat'

def go_over(current_score) 
  return go_under(current_score) + 2
end

def go_under(win_score, current_score)
  return [(Math.log(win_score-current_score)/Math.log(2)).to_i,1].max
end

def overunder(round,current_score)
  if round%2 == 0
    return go_over(current_score)
  else
    return go_under(current_score)
  end
end

class TheRace
  def initialize( win_score, num_class = Rational )
    @win_score = win_score
    @num_class = Rational
    if @num_class == Rational
      @new_num = Proc.new { |n,m| Rational(n,m==nil ? 1 : m) }
    elsif @num_class == Float
      @new_num = Proc.new { |n,m| n.to_f/(m==nil ? 1 : m).to_f }
    else 
      @new_num = Proc.new { |n,m|
        if( m == nil ) 
          @num_class.new(n)
        else
          @num_class.new( n.to_f/(m==nil ? 1 : m).to_f )
        end
      }
    end
    @p1_win_chances = []
    reset()
  end

  def reset 
    @scores_p1 = init_scores
    @scores_p2 = init_scores
  end

  def init_scores
    [@new_num.call(1)] + Array.new(@win_score) { @new_num.call(0) }
  end

  def probability_round!( score_probabilities )
    new_probs = Array.new(@win_score + 1) { @new_num.call(0) }
    old_win_chance = score_probabilities[@win_score]
    score_probabilities.each_with_index do |prob,score|
      next if prob == nil or prob == 0
      if score >= @win_score
        new_probs[@win_score] += prob
      else
        t = yield score
        possible_score = [score + 2**(t-1),@win_score].min
        new_probs[score] += prob * (1 - @new_num.call(1,2**t))
        new_probs[possible_score] += prob * @new_num.call(1,2**t) 
      end
    end
    new_probs.each_with_index do |x,i|
      score_probabilities[i] = x
    end
    win_delta = score_probabilities[@win_score] - old_win_chance
    #what fraction of the non-winning probabilities moved to winning
    return win_delta / (1 - old_win_chance)
  end

  def fmt_bf( n, ndigits = 8 )
    n.to_s[0..ndigits+1]
  end

  def run_match( max_rounds = 1000, convergence = 10**-12, &block )
    p1_cum_win = BigFloat.new(0)
    p2_cum_win = BigFloat.new(0)
    cum_tie = BigFloat.new(0)
    cum_loss = BigFloat.new(1)
    max_rounds.times { |round|
      if @p1_win_chances.size > round
        p1_win_chance = @p1_win_chances[round]
      else
        p1_win_chance = BigFloat.new(probability_round!( @scores_p1 ) { 1 })
        @p1_win_chances[round] = p1_win_chance
      end
      p2_win_chance = BigFloat.new(probability_round!( @scores_p2, &block ))
      #the chance that a player wins this round is the prob that the player
      #goes over 100 this round, times the prob that no-one has one before now
      tie_chance = p1_win_chance * p2_win_chance
      p1_cum_win += cum_loss * (p1_win_chance - tie_chance)
      p2_cum_win += cum_loss * (p2_win_chance - tie_chance)
      cum_tie += cum_loss * tie_chance
      cum_loss = cum_loss*(1 - (p1_win_chance + p2_win_chance - 2 * tie_chance))
      #print 'round: ', round, ' p1: ', p1_cum_win.inspect, ' p2: ', p2_cum_win.inspect, "\n"

      #print 'round: ', round, ' p1: ', fmt_bf(p1_cum_win), ' p2: ', fmt_bf(p2_cum_win), "\n"
      if round > 0
        print "\b"
      end
      print "/-\\|"[round%4].chr

      break if cum_loss < convergence
    }
    print "\b"
    return p2_cum_win
  end

end


def anneal_choices( choices, anneal_points )
  fruitless_rounds = 0
  best = choices.clone()
  best_chance = 0.0
  while true do
    chance = yield choices
    if chance > best_chance
      best_chance = chance
      best = choices.clone()
      anneal_points /= 2
      fruitless_rounds = 0
      print "\nchance: ", best_chance, "\n"
      print "---\n", choices, "\n---\n\n"
    else
      choices = best.clone()
      fruitless_rounds += 1
      if fruitless_rounds %10 == 0
        print "." #, fruitless_rounds
      end
    end
    if fruitless_rounds > 400
      anneal_points /= 2
      print "\n[a: ", anneal_points, "]"
      fruitless_rounds = 0
    end
    break if anneal_points == 0
    anneal_points.times do
      i = rand(choices.size)
      delta = rand() > 0.5 ? -1 : 1
      choices[i] = (choices[i] + delta)%8
    end
  end
end

def all_choices( to_win, max_t )
  choices = Array.new(to_win) { |i| 1 }
  best = choices.clone()
  best_chance = 0.0
  num_tried = 0
  while true do
    chance = yield choices
    if chance > best_chance
      best_chance = chance
      best = choices.clone()
      print "\nchance: ", best_chance, "\n"
      print "---\n", choices, "\n---\n\n"
    end
    carry = 1
    choices.each_index do |i|
      choices[i] += carry
      if choices[i] > max_t
        choices[i] = 1
        carry = 1
      else
        carry = 0
      end
    end
    num_tried += 1
    #if num_tried % 1000 == 0
    print "ch: ", choices, "\n"
    #end
    break if carry == 1
  end
end
  
to_win = 100

choices = Array.new(to_win) { |i| go_under(to_win,i) }
#choices = Array.new(100) { |i| 1 }
#choices = "4077672030577110043755030037320552164711754417147061633566442060126747222475221515063100323664525313".split("").map { |c| c.to_i }
#choices = "1111312311237702711172030002704120100202121000210132701220031200102371120771162611211142113212000011".split("").map { |c| c.to_i }

#choices = "4237761011".split("").map { |c| c.to_i }

STDOUT.sync = true
race = TheRace.new(to_win, Float)
#anneal_choices( choices, 2**6 ) do |ch|
all_choices( to_win, (Math.log(to_win)/Math.log(2)).to_i + 1 ) do |ch|
  race.reset()
  chance = race.run_match(500,0.1) { |score| ch[score] }
end


#3764777353564726447675736334161471474566527677453722565025641643507163124464055046653321532337115417

#4077672030577110043755030037320552164711754417147061633566442060126747222475221515063100323664525313

#5566650065550746466576647775566666556455556566573556743555342555464654353345546343424041344442332120

#5555650065550746476576641775566666556455556565473555743455342555353554353345546342425031344442332120

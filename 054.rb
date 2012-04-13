class Card
  include Comparable

  attr_reader :suit, :type, :value

  def <=>(other)
    value <=> other.value
  end

  def initialize( ident )
    @suit = ident[1].chr
    @type = ident[0].chr
    @value = "123456789TJQKA".index( @type )
  end
end

def cmp_sorted_arr( a, b ) 
  my = a.dup
  their = b.dup
  while my.length > 0 and their.length > 0 do
    c = my.shift <=> their.shift
    return c if c != 0
  end
  return my.length <=> their.length
end

class PokerRank
  include Comparable

  attr_reader :ranking, :cards
  
  def <=>(other)
    if ranking == other.ranking then
      return cmp_sorted_arr( @cards.sort.reverse, other.cards.sort.reverse )
    else
      return ranking <=> other.ranking
    end
  end

  def initialize( ranking, cards )
    @ranking = ranking
    @cards = cards
  end
end

class PokerHand
  include Comparable
  attr_reader :ranks, :cards
  
  def initialize( cards )
    if cards.class == String then
      cards = cards.split
    end
    @cards = (cards.map { |c| Card.new(c) }).sort
    @ungrouped = []
    @groups = []
    @ranks = []
    self.find_matching_groups
    max_group_len = ( (@groups.map { |g| g.length }).max ) || 0
    if straight? and flush? then
      @ranks << PokerRank.new( 8, @cards )
    elsif max_group_len >= 4 then
      @ranks << PokerRank.new( 7, @groups.shift )
    elsif max_group_len == 3 and @groups.length > 1 then
      @ranks << PokerRank.new( 6, @groups.shift )
    elsif flush?
      @ranks << PokerRank.new( 5, @cards )
    elsif straight?
      @ranks << PokerRank.new( 4, @cards )
    elsif max_group_len == 2 and @groups.length > 1 then
      @ranks << PokerRank.new( 2, @groups.shift )
    else
      @groups.each { |g| 
        case g.length
        when 2 
          val = 1
        else
          val = g.length
        end
        @ranks << PokerRank.new( val, g ) 
      }
    end
    if @ungrouped.length > 0 then
      @ranks << PokerRank.new( 0, @ungrouped )
    end
    print "ranks: ", (@ranks.map { |r| r.ranking }).join(","), "\n"
  end
  
  def <=>( other )
    cmp_sorted_arr( @ranks, other.ranks )
  end

  def find_matching_groups
    group = []
    tmp_cards = @cards.dup
    while tmp_cards.length > 0 or group.length > 0 do
      if tmp_cards.length > 0 and
          ( group.length == 0 or group[0] == tmp_cards[0]) then
        group << tmp_cards.shift
      else
        if group.length > 1 then
          @groups << group
        else
          @ungrouped += group
        end
        group = []
      end
    end
    #longest first
    @groups.sort! { |a,b| if a.length != b.length then
                            b.length <=> a.length
                          else
                            b[0] <=> a[0]
                          end
    }
  end

  def straight?
    ans = true
    prev_val = nil
    @cards.each do |c|
      if prev_val != nil and prev_val != c.value - 1 then
        ans = false
        break
      end
      prev_val = c.value
    end
    return ans
  end

  def flush?
    (@cards.map { |c| c.suit }).uniq().length == 1
  end

end
  #def <=>

def winner( p1_cards, p2_cards )
  case PokerHand.new( p1_cards ) <=> PokerHand.new( p2_cards )
  when 1
    print "Player 1 wins!\n"
  when -1
    print "Player 2 wins!\n"
  else
    print "Draw???\n"
  end
end


num_wins = 0
tot_hands = 0

IO.foreach( "poker.txt" ) {
  |line|
  cards = line.chomp.split
  p1 = cards[0..4]
  p2 = cards[5..9]
  p1d = p1.join(" ")
  p2d = p2.join(" ")
  if PokerHand.new( cards[0..4] ) >= PokerHand.new( cards[5..9] ) then
    num_wins += 1
    print p1d, " <--- ", p2d, "\n"
  else
    print p1d, " ---> ", p2d, "\n"
  end
  tot_hands += 1
}

print "Player 1 won ", num_wins, " times out of ", tot_hands, ".\n"


print "-----------------\n\n\n"

winner( "3H 5H 6H 7H 9H", "3C 3D 3H 4H 9H" )
winner( "3H 2C 6H 5D 4S", "3C 3D 3H 4H 9H" )
#winner( "5H 5C 6S 7S KD", "2C 3S 8S 8D TD" )
#winner( "5D 8C 9S JS AC", "2C 5C 7D 8S QH" )
#winner( "2D 9C AS AH AC", "3D 6D 7D TD QD" )
#winner( "4D 6S 9H QH QC", "3D 6D 7H QD QS" )
#winner( "2H 2D 4C 4D 4S", "3C 3D 3S 9S 9D" )

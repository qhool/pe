require 'rational'

def rats_for( d )
  (1..(d-1)).each { |n| yield Rational(n,d) }
end
    
def sorted_rats( max_d )
  min_d = max_d/2
  iterators = [nil] * (max_d - min_d + 1)
  while true do
    for da
  

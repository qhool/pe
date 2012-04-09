import Data.List
import PEFuncs
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet

p50m = primes (5*10^7)

apply :: [a -> b] -> a -> [b]
apply (f:fs) a = (f a):(apply fs a)
apply _ _ = []

trips top = [ (a,b,c) | 
              a <- takeWhile ((<=top).(^4)) $ p50m, 
              b <- takeWhile ((<=top).(+(a^4)).(^3)) $ p50m, 
              c <- takeWhile ((<=top).(+(a^4)).(+(b^3)).(^2)) $ p50m ]

sums234 top = map (\(a,b,c) -> a^4 + b^3 + c^2) $ trips top
              
set234 top = IntSet.fromList $ sums234 top
num234 top = IntSet.size $ set234 top
main = print $ num234 (5*10^7)

--main = print $ IntSet.findMax $ set234 (5*10^7)
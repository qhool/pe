import Data.Ratio
import PEFuncs

sq2exp n = 1 + ( 1 / (s2e (n-1)) ) where
  s2e n | n == 0 = 2%1
        | otherwise = 2 + ( 1 / (s2e (n-1)))
                      
sq2exps n = let sub = if n == 0 then 2 + 1%2 else 2 + 1/(
grt exp = (num_digits $ numerator exp) > (num_digits $ denominator exp)

grtr n = grt $ sq2exp n

main = print $ length $ filter grtr [990..1000]
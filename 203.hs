import Primes
import Data.List

pascal = [1]:[row n | n <- [1..]] where
  row n = let p_row = pascal!!(n-1) in
    [ case i of 0 -> 1
                i -> p_row!!(i-1) + p_row!!i
    | i <- [0..n-1] ] ++ [1]
                
    
unqpascal n = nub $ concat $ take n pascal

squareFree n = all ((/=0).(n `mod`)) $ takeWhile (<=n) $ map (^2) primes

main = print $ sum $ filter squareFree $ unqpascal 51
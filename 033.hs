import PEFuncs
import Data.Ratio
import Data.List

unorthodox :: (Integer,Integer) -> Bool
unorthodox (n,d) = (mc d n) > 0 && (mc n d) < 10 && (n%d) == ((mc n d) % (mc d n)) where
  mc :: Integer -> Integer -> Integer
  mc x y 
    | ((show x) \\ (show y)) == "" = 0
    | otherwise = read ((show x) \\ (show y))
  
nums = [10..99] \\ [10,20..99]

rt :: (Integer,Integer) -> Rational
rt (n,d) = n%d

main = print $ product $ map rt $ filter unorthodox [ (a,b) | a <- nums, b <- nums, a<b ]
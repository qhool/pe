import Debug.Trace
import Data.Char

digi = "01234567890"

numDecreasing :: String -> Int -> Int -> Integer
numDecreasing pfx 0 0 = trace (pfx ++ "  (0,0) -- B0 -----") 
                        1
numDecreasing pfx len 0 = trace (pfx ++ (replicate len '0') ++ "  " ++ (show (len,0)) ++ " -- B1 --") 
                          ((toInteger len) + 1)--run out of digits before end of number
numDecreasing pfx 0 digits = trace (pfx ++ "  " ++ (show (0,digits)) ++ " -- B2") 
                          0 -- create the whole number
numDecreasing pfx len digits = --trace (pfx ++ "    " (show (len,digits))) $
                           ( numDecreasing (pfx ++ [digi!!digits]) (len - 1) digits ) + 
                           ( numDecreasing (pfx) len (digits - 1) )
                           -- current digit repeats n times
                           
-- numDecreasing!!maxDigit!!numberOfDigits
numDecreasing' :: [[Int]]
numDecreasing' = ([0,0..]):[ 0:d:[ (numDecreasing'!!(d)!!(num-1)) + (numDecreasing'!!(d-1)!!num) + num | num <- [2..] ] |
                                  d <- ( [1..9] :: [Int] ) ]
                 
isDecreasing n = all ((>=0).(uncurry (-))) $ p $ d where
  p [x] = []
  p (x:y:xs) = (x,y):( p (y:xs) )
  d = map digitToInt $ show n
                                                     
numFlat len = 9*len
      
numNonBouncy len = let ndec = numDecreasing "" len 10 in
  (ndec - 11)*2 + 9
  
  
notDs ds n = and $ map ($(show n)) $ map notElem $ map (head.show) ds

numDec maxd numd = length $ filter isDecreasing $ filter (notDs [maxd+1..9]) [1..(10^numd)-1]
{-
22 
21
20
11
10
02
01
00

-}
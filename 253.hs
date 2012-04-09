import Data.Functor

0 `divisionsOf` _ = []
1 `divisionsOf` n = [[n]]
m `divisionsOf` n = concat $ map (\i -> (i:) <$> ((m-1) `divisionsOf` (n-i)) ) [1..n-m+1]

waysToFill n = 2^(n-1)

waysToTake [] = 0
waysToTake [n] = 1
waysToTake [n,m] = wtt!!n!!m where
  wtt = [ wttl i | i <- [0..] ]
  wttl 0 = [1,1..]
  wttl n = 1:[(wttl n)!!(m-1) + wtt!!(n-1)!!m | m <- [1..] ]
waysToTake (n:ns) = (waysToTake [n,sum ns])*(waysToTake ns)
  
waysToFillAll t = zipWith (*) (map (product.(map waysToFill)) t) (map waysToTake t)

atMost n m = waysToFillAll $ m `divisionsOf` n

{-

000

100     010     001
110 101 110 011 101 011
111 111 111 111 111 111

0000 
1000                          0100           
1100      1010      1001      1100      0110      0101 
1110 1101 1110 1011 1101 1011 1110 1101 1110 0111 1101 0111
1    2    2    2    2    2    1    2    1    1    2    2

0010                          0001
1010      0110      0011      1001      0101      0011
1110 1011 1110 0111 1011 0111 1101 1011 1101 0111 1011 0111
2    2    1    1    2    1    2    2    2    2    2    1

-}
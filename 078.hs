import Data.List
import Timer

splitWays :: Integral a => a -> [[a]]
splitWays n = np n n where
  np 0 _ = [[]]
  np 1 _ = [[1]]
  np n top = concat [ map (x:) (np (n-x) x) | x <- [1..(min top n)] ]
  
splitMult n x = map (map (*x)) $ splitWays n
  
splitWayCounts = zip [1..] $ map (length.splitWays) [1..]

newSplitWays :: Integral a => a -> [[a]]
newSplitWays n = filter ((/=1).last) $ splitWays n

splitWayCounts' = zip [1..] $ tail swc where
  shims n = [2..(n `div` 2)]
  swc = 0:1:2:3:[ sw n | n <- [4..] ]
  sw n = sum $ map (length.splitWays) $ (n-1):(shims n)

successiveRatios (x:y:xs) = (y/x):(successiveRatios (y:xs))

splitRats = successiveRatios $ map (fromIntegral.length.splitWays) [1..]

{-
[[2,2,2,2,2],
 [4,2,2,2],
 [4,4,2],
 [6,2,2],
 [6,4],
 [8,2],
 [10]] 
  
  
 
 [3,3,2,2],
 [4,3,3],
 [5,3,2],
 [5,5],
 [7,3],



[[3,2,2,2,2],[5,2,2,2],[5,4,2],[7,2,2],[7,4],[9,2],[11]]



[3,3,3,2],
[4,3,2,2],
[4,4,3],
[5,3,3],
[6,3,2],
[6,5],
[8,3],
]


p(6) = p(5) + p(3) + p(2) - p(1)
p(7) = p(6) + p(3) + p(2) - p(1)
p(8) = p(7) + p(4) + p(3) - p(1)
p(9) = p(8) + p(4) + 2*p(3) - p(2)



-}
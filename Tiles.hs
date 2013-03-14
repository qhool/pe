module Tiles (factorial, 
              waysToArrange, 
              tilesUnder, 
              waysToDivide ) where
       
       
       
factorial :: Integral a => a -> a
factorial n = product [1..n]

waysToArrange t = (factorial $ sum t) `div` (product $ map factorial t)

tilesUnder n s = takeWhile ((<=n).(*s)) [0..]

waysToDivide n s = map (\m -> [n-s*m,m]) $ tilesUnder n s
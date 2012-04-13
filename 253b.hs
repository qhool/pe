import Data.Function
import Data.Bits
import Data.Word
import System.Random

divisionsOf :: Integral a => a -> a -> [[a]]
divisionsOf _ 0 = []
divisionsOf 1 m = [[m]]
divisionsOf n m = concat $ map (\x -> map (x:) (divisionsOf (n-1) (m-x))) [1..m-n+1] 

partitionsOf :: Integral a => a -> a -> [([a],[a])]
partitionsOf n m = map (splitAt (fromIntegral n)) $
                   (2*n + 1) `divisionsOf` m

waysToSum = 1:[sum $ map ((waysToSum!!).(n-)) [1..n] | n <- [1..]]

factorial n = product [1..n]

nCk n k = (div `on` product) [ n - k + i | i <- [1..k] ] [1..k]

waysToTake :: Integral a => [a] -> a
waysToTake [] = 1
waysToTake [x] = 1
waysToTake (0:xs) = waysToTake xs
waysToTake (x:x':xs) | x > x' = waysToTake (x':x:xs)  
                     | otherwise = let tot = sum (x':xs) in
  (sum $ map (nCk (tot + 1)) [1..x])*(waysToTake (x':xs))
  
waysToComplete :: Integral a => [a] -> a
waysToComplete t = 2^(length $ filter (>1) $ drop 2 t)
  
waysToMax n m = sum $ map (\(a,b) -> ( product $ map (2^) a ) * (waysToTake a) *
                                     (waysToComplete b)) 
                $ n `partitionsOf` m
  


import Data.Char
import Data.List
import Text.Printf

sumdigits :: Integral a => a -> Int
sumdigits n = sum $ map digitToInt $ show n

isIntegral x = x == (fromIntegral $ floor $ x)

isA n = let sd = sumdigits n in
  ( sd > 1 ) && (isIntegral $ (log $ fromIntegral n)/(log $ fromIntegral sd))
  
  
powerLists = HeadLists 1 [ iterate (n*) (n^2) | n <- [2..] ] 
  
data HeadLists a = HeadLists { minHead :: Int, lists :: [[a]] }
             
chopHeads :: Ord a => HeadLists a -> ([a],HeadLists a)                            
chopHeads hL = ch (head $ head $ lists hL) (minHead hL) [] [] (lists hL) where
  ch maxi ix heads prefix allt@(t:ts) 
    | ix <= 0 && (head t) > maxi = (heads,HeadLists ((minHead hL)-ix) (prefix++allt))
    | otherwise = ch maxi (ix-1) (heads++(takeWhile (<=maxi) t)) (prefix++[dropWhile (<=maxi) t]) ts
unqSorted [] = []
unqSorted [x] = [x]
unqSorted (x:y:xs) | x == y = unqSorted (x:xs)
                   | otherwise = x:(unqSorted (y:xs))
                                                   
headSets hL = let ch = chopHeads hL in
    (fst ch):(headSets (snd ch))
    
inversions [] = []
inversions [x] = []
inversions (x:y:xs) | x > y = (x,y):(inversions (y:xs))
                    | otherwise = inversions (y:xs)
    
powers = unqSorted $ concat $ map sort $ headSets powerLists
    
main = sequence $ map print $ take 12 $ filter isA $ dropWhile (<10) powers
         
{-
    
fmtint :: Int -> String
fmtint n = printf "%9d" n

4,

        4        9       16       25       36       49       64
        8       27       64      125      216      343      512
       16       81      256      625     1296     2401     4096
       32      243     1024     3125     7776    16807    32768
       64      729     4096    15625    46656   117649   262144
      128     2187    16384    78125   279936   823543  2097152
      256     6561    65536   390625  1679616  5764801 16777216
-}
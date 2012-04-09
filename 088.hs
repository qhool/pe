import PEFuncs
import Data.List
import Data.Function
  
-- work with lists of non-increasing ints

{-
pairs (x:y:xs) = (x,y):(pairs xs)
pairs _ = []

distributePoints ::  Int -> Int -> Int -> [[Int]]
distributePoints points max n | points < 0 = []
                              | points == 0 = [replicate n 1]
                              | n == 1 && points > max = []
                              | n == 1 = [[points+1]]
                              | otherwise = [ (1+p):t
                                            | p <- [max,max-1..1], t <- (distributePoints (points - p) p (n-1))  ]
  -}                                          
--canProductSum n psum | psum == 2*n = True
--                     | otherwise = elem psum $ map product $ distributePoints (psum - n) (psum - n) n

canProductSum n psum | psum == 2*n = True
                     | otherwise = any (\fs -> sum(fs) + (n - (length fs)) == psum) $ factorSets psum
                       

minProductSum n = head $ filter (canProductSum n) [n+1..2*n]

minProductSums nums = nubBy ((==) `on` snd) $ zip nums (map minProductSum nums)
                             
main = sequence $ map print $ scanl (\(_,_,tot) (n,ps) -> (n,ps,tot+ps) ) (0,0,0) $ minProductSums [2..12000]

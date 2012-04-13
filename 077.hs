import Data.List
import Debug.Trace
import Timer

--trace a b = b

primes = 2:3:(sieve [5,7..] (tail primes)) where
  sieve (x:xs) allp@(p:ps) | x < p*p = x:(sieve xs allp )
                           | x == p*p = (sieve (xs `minus` [p*(p+1),p*(p+2)..]) ps) 
  minus t [] = t
  minus (x:xs) (y:ys) = case compare x y of LT -> x:(minus xs (y:ys))
                                            GT -> (minus (x:xs) ys)
                                            EQ -> minus xs ys
  
longerThan :: Int -> [a] -> Bool
longerThan n xs = null $ drop n xs

isLonger :: [a] -> [b] -> Bool
isLonger xs ys = longerThan (length ys) xs

waysToMakeWith known t n 
--  | (n < length known) && (not $ null t') && ((last t') >= n) = 
--    trace ((show (known!!n)) ++ " ways to make " ++ (show n) ) $ known!!n
  | n == 0 = (trace ( (show t') ++ " ::: 0 +1" ) ) 1
  | length t' == 0 = 0
  | length t' == 1 = if n `mod` (head t') == 0 then trace ((show t') ++ " ::: " ++ (show n) ++ "  +1") 1 else 0
  | otherwise = 
    trace( (show t') ++ " ::: " ++ (show n) )
    ( sum $ map ((waysToMakeWith known (init t')).(n-)) $
      takeWhile (<=n) [0,(last t')..]
    )          
      where
        t' = (takeWhile (<=n) t)
        
waysToMake n = waysToMakeWith [] (takeWhile (<= n) primes) n

waysToMakeL :: [Int] -> Int -> [Int]
waysToMakeL known n = let wtm = waysToMakeWith known primes n in
  (wtm) : (waysToMakeL (known++[wtm]) (n+1))

waysToMakeList = 0 : (waysToMakeL [1] 1)


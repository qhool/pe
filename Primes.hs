module Primes ( primes, isPrime, factorization, factorSets ) where
                                                
import Data.List
import Data.Ord

minus (x:xs) (y:ys) | x < y = x : minus xs (y:ys)
      	     	    | x > y = minus (x:xs) ys
		    | otherwise = minus xs ys
minus xs     _ 	    = xs



primes :: Integral a => [a]
primes = 2 : primes'
  where 
    primes' = sieve [3,5..] 9 primes'
    sieve (x:xs) q ps@ ~(p:t)
      | x < q     = x : sieve xs q ps
      | otherwise =     sieve (xs `minus` [q, q+2*p..]) (head t^2) t
 
isPrime :: Integral a => a -> Bool
isPrime 1 = False
isPrime 2 = True
isPrime 3 = True
isPrime n = let sqrtn = truncate $ sqrt (fromIntegral n) in
  not $ any ((>1).(gcd n)) $ takeWhile (<sqrtn) primes
                           
factorization :: Integral a => a -> [(a,a)]
factorization n = fz n primes 0 where
  fz 1 _ 0 = []
  fz 1 (p:_) mult = [(p,mult)]
  fz n allp@(p:ps) mult = let dm = divMod n p in
    if snd dm == 0 then fz (fst dm) allp (mult + 1)
    else (if mult == 0 then id else ((p,mult):)) (fz n ps 0)
nextPattern :: Integral a => [(a,a)] -> [a] -> [a]
nextPattern _ [] = []
nextPattern _ [n] = [n-1]
nextPattern ((p,m):fs) (n:ns) | n-1 < 0 = m:(nextPattern fs ns)
                              | otherwise = (n-1):(ns)

factorizationToNum :: Integral a => [(a,a)] -> a
factorizationToNum f = product $ map (uncurry (^)) $ f

factorizationSplits :: Integral a => a -> [(a,a)] -> [ [[(a,a)]] ]
factorizationSplits _ [] = [[]]
factorizationSplits start facts = ( concat $ map (\p -> map ((:)(toFact p)) $ 
                                                        factorizationSplits (toNum p) $ toFact $ oppo p) $
                                    takeWhile ((>=start).toNum) $ patterns facts ) where
  toFact p = filter ((>0).snd) $ zip (map fst facts) p
  toNum p = factorizationToNum $ toFact p 
  oppo p = zipWith (-) (map snd facts) p
  patterns [(p,1)] = [[1]]
  patterns f = sortBy (comparing (((-1)*).(toNum))) $
               init $ takeWhile ((>=0).last) $ iterate (nextPattern f) (map snd f)

factorSets :: Integral a => a -> [[a]]
factorSets n = map (map factorizationToNum) $ factorizationSplits 1 (factorization n)

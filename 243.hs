import PEFuncs
import Data.Ratio
import Data.List
import Data.Ord

propers :: Integral a => a -> [Ratio a]
propers n = map (%n) [1..n-1]

numResilient n = length $ filter ((==n).denominator) $ propers n

resilience n = (numResilient n) % (n-1)

resFactors n f = resf 0 (nub f) where
  resf tot (x:xs) = resf (tot + (n `div` x) - (tot `div` x)) xs
  resf tot _ = tot
  
numResilientBf n f = n - ( resFactors n f )

resilienceBf n f = (numResilientBf n f) % (n-1)

numResilientB n = n - ( resFactors n (map fst $ factorization n) )

resilienceB n = (numResilientB n) % (n-1)

res n = (n,resilience n)
resB n = (n,resilienceB n)

rAB n = (n,resilience n,resilienceB n)
  
f n = (n,factorization n)

x n = (n,numResilientB n,factorization n)


--main = print $ resilienceB 12

--main = sequence $ map print $ map rAB [2..50]

--main = sequence $ map print $ filter (\(x) -> (fst x) /= (snd x)) $ map rAB [2..1000]

--main = sequence $ map print $ takeWhile ((>=(15499%94744)).snd) $ map (resB.product) (drop 1 $ inits $ primes 50) 

--main = sequence $ map (print.f) [1..]

--main = sequence $ map print $ dropWhile ((>(15499%94744)).snd) $ map (\(t) -> (product t,resilienceBf (product t) t)) $ drop 2 $ inits $ primes 50

--main = print (resilienceBf 1115464350 [2, 3, 5, 5, 7, 11, 13, 17, 19, 23])

main = print $ head $ sortBy (comparing fst) $ filter ((<(15499%94744)).snd) $ map (\(t) -> (product t,resilienceBf (product t) t)) $ drop 1 $ subsequences $ concat [primes 23,primes 5,primes 5,primes 5]

--main = sequence $ map print $ map x [2..20]
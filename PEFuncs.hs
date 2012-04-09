module PEFuncs (half,
                digits,
                from_digits,
                is_pandigital,
                exp10,
                magnitude,
                truncateLeft,
                showBinary,
                factorial, 
                rotate_digits,
                reverse_digits,
                rotations, 
                permuteDigits,
                primes,
                is_prime,
                factorization,
                factorSets,
                minus, 
                intersectByComparing,
                multiplicity,
                num_digits, 
                is_square, 
                palindromes,
                isPalindrome,
                qsort, 
                perfect_squares,
                is_perfect,
                perfect_root,
                windows,
                pairs,
                fibonacci,
                is_triangle,
                is_pentagonal,
                pentagonalNums,
                hexNums
               ) where
                
import Numeric
import Data.List
import Data.Maybe
import Data.Ord
import Debug.Trace

half :: (Integral a) => a -> a
half n = truncate ((fromIntegral n)/2)

digits :: (Integral a, Integral b, Read b) => a -> [b]
digits n = [ read [c] | c <- show n ]

from_digits :: Integral a => [a] -> a
from_digits d = sum $ zipWith (*) (reverse d) [10^n | n <- [0..]]

is_pandigital :: Integral a => a -> Bool
is_pandigital n = ('0' `notElem` (show n)) &&
                  ("" == ((show n) \\ (nub $ show n))) && 
                  ((num_digits n ) == (maximum $ digits n))
                  
exp10 :: Integral a => a -> a
exp10 p = truncate $ ((fromIntegral 10)**(fromIntegral p))

offsetMagnitude :: Integral a => a -> a -> a
offsetMagnitude o n = exp10 ((num_digits n) + o - 1)

magnitude :: Integral a => a -> a
magnitude = offsetMagnitude 0

dropDigits :: (Integral a) => a -> a -> a
--dropDigits d n = n `mod` ( exp10 ((num_digits n) - d) )
dropDigits d n  = n `mod` (offsetMagnitude (1 - d) n)

truncateLeft :: Integral a => a -> a
truncateLeft = dropDigits 1

takeDigits :: (Integral a) => a -> a -> a
takeDigits d n = div n (offsetMagnitude (1 - d) n)

appendDigits :: Integral a => a -> a -> a
appendDigits n m = n * (offsetMagnitude 1 m) + m

showBinary :: (Integral a) => a -> String
showBinary = (flip $ showIntAtBase 2 bdig) "" where
  bdig 0 = '0'
  bdig 1 = '1'
           
--factorial :: (Integral a) => a -> a
--factorial 0 = 1
--factorial n = n * factorial (n-1)

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = product [1..n]

factorials :: [Integer]
factorials = [ factorial n | n <- [0..] ]

factorial_lookup :: Int -> Integer
factorial_lookup n = factorials !! n

rotate_digits :: (Integral a, Read a) => a -> a
rotate_digits n = read (last (show n) : init(show n))

reverse_digits :: (Integral a, Read a) => a -> a
reverse_digits n = read $ reverse $ show n

num_digits :: (Integral a, Integral b) => a -> b
num_digits n = ((truncate (logBase 10 (fromIntegral n)))+1)

rotations :: (Integral a, Read a) => a -> [a]
rotations n = take (num_digits n) (iterate rotate_digits n)

permuteDigits :: (Integral a,Read a) => a -> [a]
permuteDigits n = map read $ permutations $ show n

int_sqrt :: (Integral a) => a -> a
int_sqrt n = truncate (sqrt (fromIntegral n) :: Double)

qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) = low ++ [x] ++ high where
  low = qsort [ y | y <- xs, y <= x ]
  high = qsort [ y | y <- xs, y > x ]

multiplicity :: (Ord a) => [a] -> [(a,Int)]
multiplicity [] = []
multiplicity t = mpl base where
  base = [ (x,1) | x <- (qsort t) ]
  mpl ((a,n1):(b,n2):xs)
    | a == b = mpl ((a,n1+n2):xs)
    | otherwise = (a,n1) : mpl ((b,n2):xs)
  mpl x = x

--allprimes = 2 : [ p | p <- [3,5..], 1 == maximum (1:( map (gcd p) (takeWhile (<= (int_sqrt p)) primes) ))] 
allprimes :: Integral a => [a]
allprimes = 2 : primes'
  where 
    primes' = sieve [3,5..] 9 primes'
    sieve (x:xs) q ps@ ~(p:t)
      | x < q     = x : sieve xs q ps
      | otherwise =     sieve (xs `minus` [q, q+2*p..]) (head t^2) t
 
primes :: Integral a => a -> [a]
primes m = takeWhile (<=m) allprimes
  
{-
primes :: Integral a => a -> [a]
primes m = 2 : sieve [3,5..m] where
       sieve [] = []
       sieve (p:xs) = p : sieve (xs `minus` [p*p,p*p+2*p..m])
-}

is_prime :: Integral a => a -> Bool
is_prime 1 = False
is_prime 2 = True
is_prime 3 = True
is_prime n = not $ any ((>1).(gcd n)) $ primes (truncate $ sqrt (fromIntegral n))

factor_count n p = subtract 1 $ length $ takeWhile ((==0).snd) $ iterate ((`divMod` p).fst) (n,0)

{-
factorization :: Integral a => a -> [(a,Int)]
factorization n 
  | is_prime n = [(n,1)]
  | otherwise = filter ((>0).snd) $ map (\p -> (p,factor_count n p)) $ (primes (div n 2))
-}
                
factorization :: Integral a => a -> [(a,a)]
factorization n = fz n allprimes 0 where
  fz 1 _ 0 = []
  fz 1 (p:_) mult = [(p,mult)]
  fz n allp@(p:ps) mult = let dm = divMod n p in
    if snd dm == 0 then fz (fst dm) allp (mult + 1)
    else (if mult == 0 then id else ((p,mult):)) (fz n ps 0)

{-
prependers p mults = map (\t -> if (snd t) == 0 then (id) else (t:)) $ map ((,)p) mults


factorizationSplits :: Integral a => [(a,a)] -> [[(a,a)]]
factorizationSplits ((p,mult):fs) = map (\(f,nx) -> map f (factorizationSplits $ nx fs)) factNext where
  factNext = zip (prependers p [0..mult]) (prependers p [mult,mult-1..0])
-}

--factorizationSplits :: Integral a => [(a,a)] -> [([(a,a)],[(a,a)])]
--factorizationSplits fzation = where

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

factorSets n = map (map factorizationToNum) $ factorizationSplits 1 (factorization n)

--factors n = factors' $ factorization n where
--  factors' ((p,mult):fs) = [ map (*(p^m)) ( | m <- [0..mult] ]

minus (x:xs) (y:ys) | x < y = x : minus xs (y:ys)
      	     	    | x > y = minus (x:xs) ys
		    | otherwise = minus xs ys
minus xs     _ 	    = xs

intersectByComparing f (x:xs) (y:ys) | (f x) < (f y) = intersectByComparing f xs (y:ys)
                                     | (f x) > (f y) = intersectByComparing f (x:xs) ys
                                     | otherwise = x : intersectByComparing f xs ys
intersectByComparing f _ _ = []



--intersect :: Eq a => [a] -> [a] -> [a]
--intersect (x:xs) (y:ys) | x < y = intersect xs (y:ys) 
--                        | x > y = intersect (x:xs) (y:ys)
--                        | otherwise = x : intersect xs ys
--intersect _ _ = []

--windowMap :: Integral a => a -> ([b] -> c) -> [b] -> [c]
--windowMap 
windows :: Int -> [a] -> [[a]]
windows n t | ((length (take n t) < n)) = [] 
            | otherwise = wd (take n t) (drop n t) where
  --wd :: [c] -> [c] -> [[c]]
  wd (x:xs) (y:ys) = (x:xs) : (wd (xs++[y]) ys)  
  wd (x:xs) _ = [(x:xs)]
  wd _ _ = []

pairs :: Int -> [a] -> [(a,a)]
pairs n t = map (\x -> (head x,last x)) $ windows n t

is_square :: (Integral a) => a -> Bool
is_square n = (truncate (sqrt (fromIntegral n)))^2 == n

too_square :: (Integral a) => a -> a -> [a]
too_square n m = [ p | p <- (primes m), is_square (truncate ((fromIntegral (n-p))/2)) ]
      
nexp :: (Integral a, Integral b) => a -> b
nexp n = truncate (10**(fromIntegral $ half (n-1)))

nnums :: (Integral a, Integral b) => a -> [b]
nnums n = [(nexp n)..10*(nexp n)-1]

nDigitPalindromes :: (Integral a,Integral b,Read b,Show b) => a -> [b]
nDigitPalindromes n
  | n `mod` 2 == 1 = [ read $ (show i) ++ ((tail.reverse) (show i)) | i <- (nnums n) ]
  | otherwise = [ read $ (show i) ++ (reverse (show i)) | i <- (nnums n) ]

palindromes :: (Integral a,Read a,Show a) => [a]
palindromes = foldr (++) [] $ map nDigitPalindromes [1..]

isPalindrome n = (show n) == (reverse $ show n)

perfect_squares :: Integral a => [a]
perfect_squares = [ n*n | n <- [1..] ]

is_perfect :: Integral a => a -> Bool
is_perfect n = 0.0 == (snd $ properFraction (sqrt $ fromIntegral n))

perfect_root :: Integral a => a -> Maybe a
perfect_root n
  | (snd pfroot) == 0.0 = Just (fst pfroot)
  | otherwise = Nothing
    where
      pfroot = properFraction (sqrt $ fromIntegral n)

fibonacci = 1 : 1 : [ (fibonacci!!(i-1)) + (fibonacci!!i) | i <- [1..] ]

isLychrel n = isL (n+(reverse_digits n)) 53 where
  isL n max | max <= 0 = True
            | isPalindrome n = False
            | otherwise = isL (n+(reverse_digits n)) (max - 1)
                          
is_triangle n 
  | isNothing pfr = False
  | ((fromJust pfr) `mod` 2) == 1 = True
  | otherwise = False
    where
      pfr = perfect_root (1 + 8*n)
      
is_pentagonal n
  | isNothing pfr = False
  | ((fromJust pfr) `mod` 6) == 5 = True
  | otherwise = False
    where 
      pfr = perfect_root (1 + 24*n)
     
--triangleNums = map (\n ->
pentagonalNums = map (\n -> (n * (3*n - 1)) `div` 2) [1..]

hexNums = map (\n -> n * (2*n - 1)) [1..]                          

--pe034_nums :: [Integer]
--pe034_nums = [ n | n <- [3..10^7], n == sum (map factorial_lookup (digits n)) ]
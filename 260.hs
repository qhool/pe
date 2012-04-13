import Control.Applicative
import Data.List
import Data.Function
import Data.Functor
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet
import Data.Set (Set)
import qualified Data.Set as Set
import Debug.Trace

data Triple t = Triple { a :: t, b :: t, c :: t } deriving (Show,Eq)

tripleToList :: Triple a -> [a]
tripleToList (Triple a b c) = [a,b,c]

tripleFromList :: [a] -> Triple a
tripleFromList (a:b:c:_) = Triple a b c

instance (Num a, Ord a) => Ord (Triple a) where
  compare t1 t2 = let cmpsize = (compare `on` (sum.tripleToList)) t1 t2 in
    if cmpsize /= EQ then cmpsize else (compare `on` (reverse.tripleToList)) t1 t2
  
tripleZipper f t1 t2 = tripleFromList $ ((zipWith f) `on` tripleToList) t1 t2

instance Functor Triple where
  fmap f t = tripleFromList $ map f $ tripleToList t
  (<$) a _ = Triple a a a


instance Applicative Triple where
  pure x = Triple x x x
  (<*>) tf t = tripleFromList $ zipWith ($) (tripleToList tf) (tripleToList t)

instance (Num a) => Num (Triple a) where
  (+) a b = (+) <$> a <*> b
  (-) a b = (-) <$> a <*> b
  (*) a b = (*) <$> a <*> b
  negate t = negate <$> t
  abs t = abs <$> t
  signum t = signum <$> t
  fromInteger n = let x = fromIntegral n in Triple x x x

ascendingTriples :: Int -> [Triple Int]
ascendingTriples top = [ Triple (tot-y-z) y z | 
                         tot <- [1..3*top], 
                         z <- [tot `divup` 3..min tot top], 
                         y <- [(tot - z) `divup` 2..min z (tot-z)] ] where
  divup n m = n - (((m-1)*n) `div` m)
  
atComp [x] = []
atComp (x:y:xs) = (compare x y):(atComp (y:xs))
                       
sortPass [x] = [x]
sortPass (x:y:xs) | x > y = y:(sortPass (x:xs))
                  | otherwise = x:(sortPass (y:xs))

reorderTriple t = tripleFromList $ sort $ tripleToList t

tripleSum (Triple a b c) = a+b+c

--possibleMoves :: Integral a => (a,a,a) => [(a,a,a)]
--possibleMoves (x,y,z) = filter ((>=0).frst) $ map reorderTriple $ 
--                        map trip $ map (zipWith (-) [x,y,z]) $ 
--                        filter (any (>0)) $ map (onoffs 3) [1..5]

{- possibleMoves :: (Int,Int,Int) -> [(Int,Int,Int)]
possibleMoves (x,y,z) = let mxyz = maximum [x,y,z] in
  filter ((>=0).frst) $ map reorderTriple $ 
  map trip $ map (zipWith (-) [x,y,z]) $ 
  filter (any (>0)) $ concat $ map (onoffs 3) $ [mxyz,mxyz -1..1]  
                            
onoffs :: Int -> Int -> [[Int]]
onoffs 0 n = [[]]
onoffs m n = concat [ [ n:t, 0:t ] | t <- ( onoffs (m-1) n ) ]
-}
{-
isWinning (0,0,0) = False
isWinning (x,y,z) | ( y == z || y == 0 ) && ( x == z || x == 0 ) = True
                  | otherwise = any isLosing $ possibleMoves (x,y,z)
                                
isLosing (0,0,0) = True
isLosing t = all isWinning $ possibleMoves t
-}

allTriples top = Set.fromList $ ascendingTriples top

ascendingPatterns :: Int -> [[Triple Int]]
ascendingPatterns top = map pnum [1..top*3] where
  threeway n = if (n `mod` 3) == 0 then [pure $ n `div` 3] else []
  twoway n = if (n `mod` 2) == 0 && (n `div` 2) <= top 
             then map (*(pure $ n `div` 2)) $ map tripleFromList 
                  [[1,1,0],[1,0,1],[0,1,1]] else []
  oneway n = if n <= top then map (*(pure n)) $ map tripleFromList [[1,0,0],[0,1,0],[0,0,1]] else []
  pnum n = concat $ map ($n) [oneway,twoway,threeway]

unq [] = []
unq [x] = [x]
unq (x:y:xs) | x == y = unq (x:xs)
             | otherwise = x:(unq (y:xs))

applyPatterns :: Int -> Triple Int -> [Triple Int]
applyPatterns top start = concat $ map (unq.sort.(map (reorderTriple.(+start)))) $ 
                          ascendingPatterns $ top - (maximum $ tripleToList start)

winnersFromLoser top loser = (map reorderTriple $
                              filter (<=(Triple top top top)) $ 
                              map (+loser) [ (pure n)*p | n <- [1..ptop], p <- patterns ]) where
  ptop = top - (minimum $ tripleToList loser)
  patterns = sort $ tail [ Triple a b c | a <- [0,1], b <- [0,1], c <- [0,1] ]
   

removeWinners top tset loser = Set.difference tset winnerSet where
  ptop = top - (minimum $ tripleToList loser)
  patterns = tail [ Triple a b c | a <- [0,1], b <- [0,1], c <- [0,1] ]
  winnerSet = Set.fromList (loser:(map reorderTriple $
                                   filter (<=(Triple top top top)) $ 
                                   map (+loser) [ (pure n)*p | n <- [1..ptop], p <- patterns ]))

getLosers top = recl (allTriples top) (pure 0) where
  recl tset loser = let losers = removeWinners top tset loser in 
    --trace (show (Set.size losers)) $
      if Set.null tset then [] else loser:(recl losers (Set.findMin losers))

minus [] _ = []
minus t [] = t
minus (x:xs) (y:ys) | x < y = x:(minus xs (y:ys))
                    | y > x = minus (x:xs) ys
                    | otherwise = minus xs ys
                                  
loserSieve :: Int -> [Triple Int]
loserSieve top = ls $ (pure 0):(ascendingTriples top) where
  ls [x] = [x]
  ls (loser:ts) = loser:(ls $ minus ts $ applyPatterns top loser)
  
  
nat n = 0

natNums n = (natDiff n,length $ ascendingTriples $ truncate n, nat n,n+1, (n+1)^2, (n+1)^3, (n+1)^4, (n+1)^5)

natDiff n = (fromIntegral (length $ ascendingTriples $ truncate n)) - (nat n)

ndRat n = (natDiff (2*n - 1))/(natDiff (n-1))
--main = print $ sum $ map tripleSum $ getLosers 1000
{-
addTrip :: IntSet -> (Int,Int,Int) -> IntSet
addTrip losers t@(x,y,z) = let wins = ( y == z || y == 0 ) && ( x == z || x == 0 ) ||
                                    ( any (`IntSet.member` losers) $ map tripToInt $ possibleMoves t ) in
  if not wins then (IntSet.insert (tripToInt t) losers) else losers
  
allLosers top = IntSet.toList $ foldl addTrip (IntSet.fromList [0]) $ ascendingTriples top
  -}                     
-- main = sequence $ map print $ allLosers 30

--main = print $ length $ ascendingTriples 100

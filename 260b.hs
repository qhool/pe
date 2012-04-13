import Control.Applicative
import Data.List
import Data.Function
import Data.Functor
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet
import Debug.Trace

data Triple t = Triple { a :: t, b :: t, c :: t } deriving (Show,Eq)

tripleToList :: Triple a -> [a]
tripleToList (Triple a b c) = [a,b,c]

tripleFromList :: [a] -> Triple a
tripleFromList (a:b:c:_) = Triple a b c

instance (Num a, Ord a) => Ord (Triple a) where
  compare t1 t2 = let cmpsize = (compare `on` (sum.tripleToList)) t1 t2 in
    if cmpsize /= EQ then cmpsize else (compare `on` tripleToList) t1 t2
  
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


untrip :: (Int,Int,Int) -> [Int]
untrip (x,y,z) = [x,y,z]

trip :: [Int] -> (Int,Int,Int)
trip (x:y:z:_) = (x,y,z)

tripToInt :: (Int,Int,Int) -> Int 
tripToInt (x,y,z) = let base = 1024 in base*base*x + base*y + z

intToTrip :: Int -> (Int,Int,Int)
intToTrip i = (x,y,z) where
  b = 1024
  z = i `mod` b
  y = (i `div` b) `mod` b
  x = i `div` (b*b)

frst (x,_,_) = x
scnd (_,y,_) = y
thrd (_,_,z) = z

{- ascendingTriples top = concat $ map tripsval [1..3*top] where
  tripsval tot = filter (\(x,y,z) -> x >= 0 && y >= x && z >= y ) 
                 [ (x,tot-x-z,z) | z <- [onethird tot..(min tot top)], x <- [0..onethird tot] ]
  onethird n = n - ((2*n) `div` 3)
-}
--ascendingTriples top = concat $ map tripsval [1..3*top] where
ascendingTriples :: Int -> [ (Int,Int,Int) ]
ascendingTriples top = [ (tot-y-z,y,z) | 
                         tot <- {- map (\x -> trace (show x) x) -} [1..3*top], 
                         z <- [tot `divup` 3..min tot top], 
                         y <- [(tot - z) `divup` 2..min z (tot-z)] ] where
  divup n m = n - (((m-1)*n) `div` m)

ascendingTriples' top = (atrip 1 0 1) where
  atrip tot z y | tot > 3*top = []
                | z > min tot top = let tot' = tot + 1 
                                        z' = (tot' `divup` 3)
                                    in atrip tot' (z' - 1) z' 
                | y > min z (tot-z) = atrip tot (z+1) ((tot - z - 1) `divup` 2)
                | otherwise = (tot-y-z,y,z):(atrip tot z (y+1))

divup n m = n - (((m-1)*n) `div` m)

reorderTriple t = trip $ sort $ untrip t

reorderInt n = tripToInt $ reorderTriple $ intToTrip n

--possibleMoves :: Integral a => (a,a,a) => [(a,a,a)]
--possibleMoves (x,y,z) = filter ((>=0).frst) $ map reorderTriple $ 
--                        map trip $ map (zipWith (-) [x,y,z]) $ 
--                        filter (any (>0)) $ map (onoffs 3) [1..5]

possibleMoves :: (Int,Int,Int) -> [(Int,Int,Int)]
possibleMoves (x,y,z) = let mxyz = maximum [x,y,z] in
  filter ((>=0).frst) $ map reorderTriple $ 
  map trip $ map (zipWith (-) [x,y,z]) $ 
  filter (any (>0)) $ concat $ map (onoffs 3) $ [mxyz,mxyz -1..1]  
                            
onoffs :: Int -> Int -> [[Int]]
onoffs 0 n = [[]]
onoffs m n = concat [ [ n:t, 0:t ] | t <- ( onoffs (m-1) n ) ]

{-
isWinning (0,0,0) = False
isWinning (x,y,z) | ( y == z || y == 0 ) && ( x == z || x == 0 ) = True
                  | otherwise = any isLosing $ possibleMoves (x,y,z)
                                
isLosing (0,0,0) = True
isLosing t = all isWinning $ possibleMoves t
-}

allTriples top = IntSet.fromList $ map tripToInt $ 
                 --map (\t@(a,b,c) -> if (a==b)&&(b==c) then trace (show t) t else t) $
                 ascendingTriples top

allTriplesExclude top = trace ("triples to " ++ (show top)) $
  IntSet.fromList $ filter (excl top) $ map tripToInt $
  --map (\t@(a,b,c) -> if (a+1==b)&&(b+1==c) then trace (show t) t else t) $
  ascendingTriples top where
    elosers t = IntSet.fromList $ concat $ map (winnersFromLoser top) $ getLosers $ (t*4) `div` 5
    excl t | t >= 50 = (`IntSet.notMember` (elosers t))
           | otherwise = const True
                        
                 
winnersFromLoser top loser = (filter (<=(tripToInt (top,top,top))) $ 
                              map reorderInt $
                              map (+loser) [ n*p | n <- [1..top], p <- patterns ]) where
  patterns = map sum $ tail $ subsequences [2^20,2^10,1]

removeWinners top tset loser = IntSet.difference tset winnerSet where
  winnerSet = IntSet.fromList (loser:(winnersFromLoser top loser))
              
getLosers top = recl (allTriplesExclude top) (tripToInt (0,0,0)) where
  recl tset loser = let losers = removeWinners top tset loser in 
    --trace (show (IntSet.size losers)) $
      if IntSet.null losers then trace ("got losers: "++(show top)) [loser] else loser:(recl losers (IntSet.findMin losers))
    

addTrip :: (IntSet,IntSet) -> (Int,Int,Int) -> (IntSet,IntSet)
addTrip (winners,losers) t@(x,y,z) = let wins = ( y == z || y == 0 ) && ( x == z || x == 0 ) ||
                                                ( any (`IntSet.member` losers) $ map tripToInt $ possibleMoves t ) in
                                     ( if wins then (IntSet.insert (tripToInt t) winners) else winners,
                                       if not wins && ( all (`IntSet.member` winners) $ map tripToInt $ possibleMoves t ) 
                                       then (IntSet.insert (tripToInt t) losers) else losers )
  
winnersAndLosers top =
  foldl addTrip (IntSet.fromList $ map tripToInt $ [(0,0,1),(0,1,1),(1,1,1)], IntSet.fromList [0]) 
  $ ascendingTriples top where
    relist (t1,t2) = ((,) `on` ((map intToTrip).(IntSet.toList))) t1 t2
                       
-- main = sequence $ map print $ allLosers 30

-- 
main = print $ sum $ map (sum.untrip.intToTrip) $ getLosers 1000
--main = print $ length $ getLosers 200

{-
main  = sequence $ map (\t@(a,b,c) -> if (a==b)&&(b==c) then print t else putStr "") $
        ascendingTriples' 150
-}
{-
        0 2 4  
      
0 1 1   0 1 3
0 0 1   0 2 3
0 2 2   0 0 2 W
0 0 2   

-}
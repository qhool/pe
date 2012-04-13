import Data.List
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet

factorial n = foldr (*) 1 [2..n]

nck n k = div (factorial n) ((factorial k)*(factorial (n-k)))

squares = map (\s -> (div s 10,s `mod` 10))
          $ takeWhile (<100) [ n*n | n <- [1..] ]

extendDie d = if (or $ map (flip IntSet.member d) [6,9])
              then IntSet.union d (IntSet.fromList [6,9])
              else d

possibleDice = map extendDie $
               map IntSet.fromList $
               filter ((==6).length) $ subsequences [0..9]
               
diceHave d1 d2 s = ( ((fst s) `IntSet.member` d1) && 
                     ((snd s) `IntSet.member` d2) ) ||
                   ( ((snd s) `IntSet.member` d1) &&
                     ((fst s) `IntSet.member` d2) )
                   
diceOk d1 d2 = and $ map (diceHave d1 d2) squares

dicePairs = [ (possibleDice!!n, possibleDice!!m) | 
              n <- [0..209], m <- [0..209], n < m ]
            
okPairs = filter (\p -> diceOk (fst p) (snd p)) dicePairs
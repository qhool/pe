import PEFuncs
import Data.List
import Data.Maybe

--pentSumDiff n = filter (\p -> (is_pentagonal $ (snd p) - (fst p)) && (is_pentagonal $ (fst p) + (snd p)) ) $
--                pairs n pentagonalNums

--firstloweridx :: Ord a => (e -> a) -> Int -> [[e]] -> Int
--firstloweridx f i (x:y:xs) | (f $ head x) < (f $ head y) = i
--                           | otherwise = firstloweridx f (i+1) (y:xs)
--firstloweridx f i (x:xs) = i
--firstloweridx f _ _ = -1                
pairSum p = (fst p) + (snd p)
pairDiff p = abs $ (fst p) - (snd p)

mergeBy f t = mb $ extract_next t where
  --firstloweridx :: Ord a => (e -> a) -> Int -> [[e]] -> Int
  firstloweridx i (x:y:xs) | (f $ head x) < (f $ head y) = i
                           | otherwise = firstloweridx (i+1) (y:xs)
  firstloweridx i (x:xs) = i
  firstloweridx _ _ = -1                
  extract_next t = let fli = firstloweridx 0 t
                   in ( head $ t !! fli, (take fli t) ++ [tail $ t !! fli] ++ (drop (fli + 1) t) )
  mb (x,t) = x : (mb $ extract_next t)
            
pentPairs = mergeBy pairDiff $ map (\n -> pairs n pentagonalNums) [2..]

pentsAsPairs = [ (p,0) | p <- pentagonalNums ]

--pentSum = intersectByComparing pairSum pentPairs pentsAsPairs
pentSum = filter (is_pentagonal.pairSum) pentPairs

pentDiff = filter (is_pentagonal.pairDiff) pentPairs
pentSumDiff = filter (is_pentagonal.pairDiff) pentSum

main = sequence $ map print pentSumDiff
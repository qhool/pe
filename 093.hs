import PEFuncs
import Data.List
import Data.Ord
import Data.Set (Set)
import qualified Data.Set as Set

arithmeticOps = [ (+), (-), (flip (-)), (*), (/), (flip (/)) ]
                
combinator :: (Ord a) => [(a -> a -> a)] -> [a] -> [a]
combinator ops t = nub $ combo $ Set.fromList t where   
  combo s 
    | Set.size s == 1 = Set.elems s
    | otherwise = concat $ map (\x -> [ o x y | o <- ops, y <- (combo $ Set.delete x s) ]) $ Set.elems s   
                
isint n = (fromIntegral $ truncate n) == n && n < 1/0

intCombos t = map round $ sort $ filter (>0) $ filter isint $ combinator arithmeticOps t

comboRun t = length $ takeWhile (\pair -> fst pair == snd pair) $ zip ( intCombos t ) [1..]

main = print $ maximumBy (comparing fst) $ map (\t -> (comboRun t,t)) $ filter ((==4).length) $ subsequences [1..9]


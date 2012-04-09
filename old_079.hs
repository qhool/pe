import Data.Char
import Data.List
import PEFuncs 

overlapReduction :: [String] -> [String]
overlapReduction (x:xs)
  | x `elem` xs = overlapReduction xs 
  | (tail x) `elem` (map init xs) = 
    overlapReduction [ if (tail x) == (init y) 
                    then (head x) : y 
                    else y | y <- xs ]
  | otherwise = (overlapReduction xs) ++ [x]
overlapReduction [] = []

matchPFS :: Eq a => (a,a) -> (a,a) -> Bool
matchPFS x y = fst x == fst y

addPFS :: (String,String) -> (String,String) -> (String,String)
addPFS x y  
  | fst x == fst y = (fst x, nub $ snd x ++ snd y)
  | otherwise = x
                
splitPFS :: Eq a => [a] -> ([a],[a])
splitPFS x = (init x, [last x])

splitSFS :: Eq a => [a] -> ([a],[a])
splitSFS x = ([head x], tail x)


addTails :: [(String,String)] -> [(String,String)]
addTails [] = []
addTails all@(x:xs) = [(foldr1 addPFS all)] ++ 
                      ( addTails $ filter (not . (matchPFS x)) xs )

combinePrefixes :: [String] -> [(String,String)]
combinePrefixes t = addTails $ map splitPFS t

combineSuffixes :: [String] -> [(String,String)]
combineSuffixes t = map unflip $ addTails $ map splitPFS $ map reverse t where
  unflip (a,b) = (b, reverse a)
  
  
prefsuffReduction :: [String] -> [String]
prefsuffReduction t = [ fst p ++ snd s | 
                        p <- (combinePrefixes t),
                        s <- (combineSuffixes t),
                        snd p \\ snd s == [],
                        fst s \\ fst p == [] ]
                      
subsetReduction :: [String] -> [String]

stabilize :: Eq a => ([a] -> [a]) -> [a] -> [a]
stabilize _ [] = []
stabilize f t = firstStable $ iterate f t where
  firstStable [] = error "No iterations???"
  firstStable (x:y:xs)
    | (x \\ y) == [] = x
    | otherwise = firstStable (y:xs)
  firstStable (x:_) = x
  

main = do
  contents <- getContents
  print $ prefsuffReduction . nub $ prefsuffReduction . nub $ stabilize overlapReduction $ nub . qsort $ lines contents

                             
--main = print $ addPFS $ (splitPFS "123"
  
--main = print $ take 20 strNoFourFives
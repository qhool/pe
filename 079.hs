import Data.Char
import Data.List
import Data.Ord
import PEFuncs 

pairwiseReduce :: (Eq a) => ( a -> a -> [a] ) -> [a] -> [a]
pairwiseReduce _ [] = []
pairwiseReduce f t = nub $ foldr (++) [] $ map unraw $ rawReduce f t where
  rawReduce :: (a -> a -> [a] ) -> [a] -> [(a,[a])]
  rawReduce _ [] = []
  rawReduce g (x:xs) = ( x, foldr (++) [] $ map (g x) xs ) : ( rawReduce g xs )
  unraw :: (a,[a]) -> [a]
  unraw (x,[]) = [x]
  unraw (_,y) = y

containsInOrder :: Eq a => [a] -> [a] -> Bool
_ `containsInOrder` [] = True
[] `containsInOrder` _  = False
(c1:s1) `containsInOrder` all_sub@(c2:s2)  
  | c1 == c2 = s1 `containsInOrder` s2
  | otherwise = s1 `containsInOrder` all_sub 
                
containsAllInOrder :: Eq a => [a] -> [[a]] -> Bool
_ `containsAllInOrder` [] = True 
[] `containsAllInOrder` _ = False
x `containsAllInOrder` y 
  = foldr (&&) True (map (x `containsInOrder`) y)                
    
overlapReductionL :: Int -> Int -> String -> String -> [String]
overlapReductionL 0 _ s1 s2 
  | s2 `containsInOrder` s1 = [ s2 ]
  | otherwise = []
overlapReductionL head_len min_overlap s1 s2
  | (length s1) - head_len < min_overlap = [] 
  | s2 `containsInOrder` (drop head_len s1) = [ (take head_len s1) ++ s2 ]
  | otherwise = []

overlapReductionR :: Int -> Int -> String -> String -> [String]
overlapReductionR n m = flip (overlapReductionL n m)

--reductions :: Eq a => [ (a -> a -> [a]) ]
reductions = [ f n (min n 2) | f <- [overlapReductionL,overlapReductionR], 
               n <- [0..2] ]

reduce = foldl1 (.) $ map pairwiseReduce $ reductions

stabilize :: Eq a => ([a] -> [a]) -> [a] -> [a]
stabilize _ [] = []
stabilize f t = firstStable $ iterate f t where
  firstStable [] = error "No iterations???"
  firstStable (x:y:xs)
    | (x \\ y) == [] = x
    | otherwise = firstStable (y:xs)
  firstStable (x:_) = x
  
candidates klist = reduce . reverse . reduce $ klist

solutions klist = filter (`containsAllInOrder` klist) $ candidates klist

removeOnes :: [a] -> [[a]]
removeOnes x = [ (take n x) ++ (drop (n+1) x) | n <- [0..((length x)-1)] ]

minimalize :: [String] -> String -> String
minimalize keys pass = head $ sortBy (comparing length) $
                       pass : [ minimalize keys p2 | p2 <- removeOnes pass, p2 `containsAllInOrder` keys ]

readInteger :: String -> Integer
readInteger = read

minSol klist = sortBy (comparing length) $ map (minimalize klist) $ sortBy (comparing length) $ solutions klist

main = do
  contents <- getContents
  print $ minSol $ nub . qsort $ lines contents

                             
--main = print $ addPFS $ (splitPFS "123"
  
--main = print $ take 20 strNoFourFives
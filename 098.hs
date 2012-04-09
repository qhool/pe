import PEFuncs
import Data.List
import Data.Maybe
import Data.Map (Map)
import qualified Data.Map as Map

listPattern :: (Ord a,Eq a) => [a] -> [Int]
listPattern t = lp 0 Map.empty t where
  lp :: (Ord a,Eq a) => Int -> Map a Int -> [a] -> [Int]
  lp _ _ [] = []
  lp i m (x:xs) 
    | Map.member x m = ((Map.!)m x):(lp i m xs)
    | otherwise = i:(lp (i+1) (Map.insert x i m) xs)
                  
squareNumbers :: Integral a => [a]
squareNumbers = map (^2) [1..]

numberPatterns :: Integral a => [a] -> Map [Int] [a]
numberPatterns t = 
  Map.fromListWith (++) 
  $ map (\n -> (listPattern $ digits n, [n])) t
  
squarePatterns :: Integral a => a -> Map [Int] [a]
squarePatterns max = numberPatterns $ takeWhile (<=max) squareNumbers

squareMatches :: Integral a => String -> [a]
squareMatches word = fromMaybe [] $ Map.lookup (listPattern word) 
                     $ squarePatterns (10^(length word))
                     
parseWords :: String -> [String]
parseWords txt 
  | txt == "" = [] 
  | otherwise = (filter (/='"') $ fst br):(parseWords $ snd br) where
  br = break (==',') $ dropWhile (==',') txt
                     
anagramSets :: [String] -> [[String]]
anagramSets wordlist = filter ((>1).length) $
                       Map.elems $ agmap wordlist where
  agmap :: [String] -> Map String [String]
  agmap wlist =
    Map.fromListWith (++)
    $ map (\w -> (sort w,[w])) wlist
    
anagramPairs :: [String] -> [(String,String)]
anagramPairs wordlist = map (\p -> (p!!0,p!!1)) $
  concat $ map ((filter ((==2).length)).subsequences) 
  $ anagramSets wordlist

equivalentPermutation :: Eq a => [a] -> [a] -> [b] -> [b]
equivalentPermutation a1 a2 b1
  | (length a1) /= (length a2) || (length b1) /= (length a1)
    = error "non-equal lengths = bad"
  | otherwise = eps (permutations a1) (permutations b1) where
    eps (pa:pas) (pb:pbs) 
      | pa == a2 = pb
      | otherwise = eps pas pbs
    eps _ _ = error "no matching permutation!"
    
squareagram :: (Read a,Integral a) => String -> String -> a -> Maybe a
squareagram word1 word2 square1 
  | is_square square2 = Just square2
  | otherwise = Nothing where
    square2 = from_digits 
              $ equivalentPermutation word1 word2 $ digits square1
              
squarePairs :: (Integral a, Read a) => (String,String) -> [(a,a)]
squarePairs apair = 
  nub $ map (\p -> if (snd p) < (fst p) then (snd p, fst p) else p ) $ --unique pairs
  filter (\p -> (num_digits $ fst p) == (num_digits $ snd p)) $ --no leading zeros
  map (\p -> (fst p, fromJust $ snd p )) $ filter (isJust.snd) $ --only if there is a matching square
  map (\sq -> (sq,(uncurry squareagram) apair sq)) $ squareMatches $ fst apair
  
anagramSquarePairs :: (Integral a, Read a) => [String] -> [(a,a)]
anagramSquarePairs wordlist = concat $ map squarePairs $ anagramPairs wordlist
                                    
maxAnagramSquare wordlist = let z = unzip $ anagramSquarePairs wordlist in
  maximum $ (fst z) ++ (snd z)
                              
peWords = fmap parseWords $ readFile "./words.txt"

main = do
  wordlist <- peWords
  print $ maxAnagramSquare wordlist

import Data.Char
import Data.List
import System.IO
import Sudoku
import PEFuncs

checklens t = (any ((/=9).length)) t

parsePuzzles c = map initSudoku $ filter ((==9).length) $ foldr appendPuzzles [[]] $ lines c where
  appendPuzzles line p | line == "" = p
                       | (head (words line)) == "Grid" = [] : p
                       | otherwise = ((map digitToInt $ (take 9 line)):(head p)) : (tail p)

main = do 
  handle <- openFile "sudoku.txt" ReadMode  
  contents <- hGetContents handle  
  --sequence $ map print $ map isSolved $ map trySolver $ parsePuzzles contents  
  print $ sum $ map from_digits $ map (\p -> map knownVal $ section p [(1,1),(1,2),(1,3)]) 
    $ filter isSolved $ map (trySolverMax 2) $ parsePuzzles contents
  -- $ map deterministicSolver $ parsePuzzles contents
  --sequence $ map putStr $ map (toStr.(trySolverMax 2)) $ parsePuzzles contents
  hClose handle  
  
  


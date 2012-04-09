import PEFuncs
import Data.Char
import Text.Read

-- t = (1/2)(n(n+1))
-- t = (1/2)(n^2 + n)

wordValue w = sum $ map ((subtract $ (ord 'A' - 1)).ord) w

lexemes s = lexm $ lex s where
  lexm (m:_) | (fst m) == "" = []
             | otherwise = (fst m):(lexm $ lex (snd m)) 
  lexm _ = []
  
parseWords :: String -> [String]
parseWords c = map read $ filter (/=",") $ lexemes c


  
main = do
  contents <- getContents
  print $ length $ filter is_triangle $ map wordValue $ parseWords contents
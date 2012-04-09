romanDigits :: Integral a => [(Char,a)]
romanDigits = [ ('I',1), ('V',5), ('X',10), ('L',50), ('C',100), ('D',500), ('M',1000) ]

romanValue :: Integral a => Char -> a
romanValue c = snd $ head $ filter ((== c) . fst) romanDigits
          
fromRoman :: Integral a => String -> a
fromRoman s = rr $ map romanValue $ reverse s where
  rr (x:y:xs) 
    | x > y = x - y + rr xs
    | otherwise = x + rr (y:xs)
  rr (x:_) = x
  rr _ = 0
  
twoLetterRomans = reverse [ "I","IV","V","IX","X","XL","L","XC","C","CD","D","CM", "M" ]

best2letterRoman :: Integral a => a -> String  
best2letterRoman n = head $ filter ((>=0) . (n-) . fromRoman) twoLetterRomans

toRoman :: Integral a => a -> String
toRoman 0 = ""
toRoman n = b2 ++ ( toRoman (n - (fromRoman b2)) ) where
  b2 = best2letterRoman n
  
romanSavings roms =  (sum $ map length roms) - (sum $ map (length . toRoman . fromRoman) roms)
  
main = do
  contents <- getContents
  print $ romanSavings $ lines contents
import PEFuncs

nextInChain :: (Integral a,Read a) => a -> a
nextInChain n = sum $ map (^2) $ digits n

loopsAt :: (Integral a,Read a) => a -> a
loopsAt 1 = 1
loopsAt 89 = 89
loopsAt n = loopsAt $ nextInChain n

loopsAt89Low :: (Integral a, Read a) => [a]
loopsAt89Low = filter ((==89) . loopsAt) [1..600]


binsrElem :: Ord a => a -> [a] -> Bool
binsrElem e t = bse 0 ((length t) - 1) where
  middle :: Int -> Int -> Int
  middle a b = (truncate ((fromIntegral (b - a))/2)) + a  
  bse :: Int -> Int -> Bool
  bse a b 
    | (t !! a) == e = True
    | (t !! b) == e = True
    | b <= a + 1  = False
    | (t !! (middle a b)) <= e = bse (middle a b) b
    | otherwise = bse a (middle a b)

main = print $ length $ filter ((`elem` loopsAt89Low) . nextInChain) $ [1..10000000]
import PEFuncs

nextInChain :: (Integral a,Read a) => a -> a
nextInChain n = sum $ map (^2) $ digits n

loopsAt :: (Integral a,Read a) => a -> a
loopsAt 1 = 1
loopsAt 89 = 89
loopsAt n = loopsAt $ nextInChain n

loopsAt89Low :: (Integral a, Read a) => [a]
loopsAt89Low = filter ((==89) . loopsAt) [1..600]

main = print $ length $ filter ((`elem` loopsAt89Low) . nextInChain) $ [1..100000]
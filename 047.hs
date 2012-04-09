import PEFuncs

hasThreePF n = 3 == (length $ factorization n)

threePFs = filter hasThreePF [105,107..]

twoThreePFs = filter (hasFourPF) $ map (subtract 1) threePFs

hasFourPF n = 4 == (length $ factorization n)

matching3 = filter (hasFourPF.(+1)) $ map (*2) twoThreePFs

matching = filter (\n -> (hasFourPF (n-1)) || (hasFourPF (n+3))) matching3
firstnum n 
  | hasFourPF (n-1) = n - 1
  | otherwise = n

--main = print $ firstnum $ (take 1 matching) !! 0

main = print $ firstnum $ (take 1 matching) !! 0

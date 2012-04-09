import PEFuncs

nDigDigits 0 = 0
nDigDigits d = d*(exp10 d - exp10 (d-1)) + (nDigDigits (d-1))

nthDigitDig n = ndmag 1 where
  ndmag d 
    | (nDigDigits d ) > n = d
    | otherwise = ndmag (d+1)
                  
digitOffset n = n - (nDigDigits ((nthDigitDig n)-1))

nNnum n = div (digitOffset n) (nthDigitDig n)

dignum n = (exp10 ((nthDigitDig n) - 1)) + ((nNnum n))

digitIdx n = (digitOffset n) `mod` (nthDigitDig n) 

digit n = (digits $ dignum (n-1)) !! (digitIdx (n-1))

--main = print $ product $ map digit $ take 7 $ iterate (*10) 1
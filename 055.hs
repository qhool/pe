import PEFuncs

isLychrel n = isL (n+(reverse_digits n)) 53 where
  isL n max | max <= 0 = True
            | isPalindrome n = False
            | otherwise = isL (n+(reverse_digits n)) (max - 1)

lychrels m = filter isLychrel [1..(m-1)]

main = sequence [ print $ lychrels 10000, print $ length $ lychrels 10000 ]
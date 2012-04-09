import PEFuncs

isBinaryPalindrome n = (take (half n) (showBinary n)) == (take (half n) (reverse $ showBinary n)) 

main = print $ sum $ filter isBinaryPalindrome $ takeWhile (<1000000) palindromes
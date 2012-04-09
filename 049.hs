import PEFuncs
import Data.List

primeseq n = nub $ filter (>1000) $ filter is_prime $ permuteDigits n

findseq = nub $ map sort $ filter ((>2).length) $ map primeseq $ dropWhile (<1000) $ primes 9999

arithsubseq t = filter (\x -> ((x!!2)-(x!!1)) == ((x!!1)-(x!!0)) ) $ filter ((==3).length) $ subsequences t


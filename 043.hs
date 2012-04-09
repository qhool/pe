import PEFuncs
import Data.List

list2n :: Integral a => [a] -> a
list2n t = sum (zipWith (*) t (iterate (`div` 10) $ exp10 ((fromIntegral $ length t)-1)))


getDigitsSuff :: Integral a => a -> a -> [a] -> [a]
getDigitsSuff n suff diglist = filter ((==0).(`rem` n).(+suff).(*(100))) diglist 

nextDigits n digts = getDigitsSuff n (list2n $ take 2 digts) ([0..9] \\ digts)

nextNums n nums = concat $ [ map (:num) $ nextDigits n num | num <- nums ]

start17 :: Integral a => [[a]]
start17 = filter ((==0).(`rem` 17).list2n) $ concat $ map permutations $ filter ((==3).length) $ subsequences [0..9]

addLastDigit :: Integral a => [a] -> [a]
addLastDigit num = (head $ [0..9] \\ num) : num

buildNums [] nums = map addLastDigit nums
buildNums (d:ds) nums = buildNums ds $ nextNums d nums

main = print $ sum $ map list2n $ buildNums (reverse $ primes 13) start17

--oddPD 
import PEFuncs
import Data.List
import Data.Maybe

primesum m n = listToMaybe $ intersect (primes m) (takeWhile (<m) $ map sum $ windows n (primes m))

primesums m = map (primesum m) [(maxn m),((maxn m)-1)..2] 

ps m n = (n, sum $ take n (primes m))
maxn m = (fst . last) $ takeWhile ((<m).snd) $ map (ps m) [1..]

--main :: IO ()
main = print $ head $ catMaybes $ primesums 1000000

--main = sequence $ map print $ takeWhile ((<1000000).snd) $ map ps [1..]

--main = print $ maxn 10000
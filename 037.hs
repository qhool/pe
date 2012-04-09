import PEFuncs
  

rightTruncatablePrimes :: Integral a => [a]
rightTruncatablePrimes = rtp $ rtpStep $ primes 10 where
  rtpStep :: Integral a => [a] -> [a]
  rtpStep [] = []
  rtpStep (p:ps) = (filter is_prime $ map ((p*10)+) [1,3..9]) ++ (rtpStep ps)
  rtp :: Integral a => [a] -> [a]
  rtp [] = []
  rtp t = t ++ (rtp $ rtpStep $ t)
  
isLeftTruncatable :: Integral a => a -> Bool
isLeftTruncatable p 
  | p < 10 = False
  | p < 100 = is_prime p && ( is_prime $ truncateLeft p )
  | otherwise = (is_prime p) && (isLeftTruncatable $ truncateLeft p )

lrTruncs = filter isLeftTruncatable rightTruncatablePrimes

main = print ( sum lrTruncs, lrTruncs )
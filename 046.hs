import PEFuncs (primes,minus,is_square)

odd_composites :: (Integral a) => a -> [a]
odd_composites m = [9,11..m] `minus` (primes m)

too_square :: (Integral a) => a -> a -> [a]
too_square n m = [ p | p <- (primes m), is_square (truncate ((fromIntegral (n-p))/2)) ]

too_squares :: (Integral a) => a -> [a]
too_squares m = [ n | n <- odd_composites m, (take 1 (too_square n m)) == [] ]
main = print (too_squares 10000)
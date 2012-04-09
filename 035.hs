import PEFuncs (rotations,primes,multiplicity,digits,num_digits)

no_even_digits n = foldr (&&) True [ e `notElem` (digits n) | e <- [0,2..8] ]
rotated_primes m = foldr (++) [] [ rotations p | p <- (primes m), no_even_digits p ]
circular_primes m = 2 : [ p | (p,n) <- (multiplicity (rotated_primes m)), n >= num_digits p ]

--main = print (length (circular_primes 1000000))
--main = print (circular_primes 100)
main = print (rotated_primes 100)
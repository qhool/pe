import Data.Ratio
import PEFuncs

convergent :: (Integral a) => [a] -> Ratio a
convergent [] = error "no convergent exists for an empty sequence"
convergent (n:m:ns) = (n%1) + 1 / (convergent (m:ns)) 
convergent (n:_) = n % 1

sqrt2_seq = 1 : (repeat 2)

e_seq = 2 : ( foldr (++) [] [ [1,n,1] | n <- [2,4..] ] )

e_convergent n = convergent (take n e_seq)

main = print (sum (digits (numerator (e_convergent 100))))



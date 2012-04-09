import Data.List
import Data.Set
--ascendingTriples top = [ (x,y,z) | z <- [onethird tot..tot],  ] where
  
trip (x:y:z:_) = (x,y,z)
untrip (x,y,z) = [x,y,z]

ascendingTriples top = concat $ map totTriples [1..3*top] where
  totTriples tot = [ (tot-z-y,y,z) | z <- [tot `divup` 3..min tot top], y <- [(tot - z) `divup` 2..min (tot - z) z] ]
  divup n m = n - (((m-1)*n) `div` m)
  
triples top = [ (x,y,z) | z <- [1..top], y <- [0..z], x <- [0..y] ]

winnersAndLosers 
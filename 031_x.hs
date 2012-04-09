coins = reverse [2,5,10,20,50,100,200]
pt t = fst t * snd t
cons a t = a : t
ccounts i = [ x | x <- [0..(truncate (200/(coins!!i)) ) ] ]
combos i = if i == length coins - 1
           then [ [x] | x <- ccounts i ]
           else [ x : t | x <- ccounts i, t <- combos (i+1), 
                  200 >= x*(truncate (coins!!i)) + (head t)*(truncate (coins!!(i+1)))  ]
                
valps = [ sum (map pt (zip c (map truncate coins))) | c <- combos 0 ]
vals = [ v | v <- valps, v <= 200 ]
--x = [ (a,b) | a <- [1,2], b <- [1,2] ]
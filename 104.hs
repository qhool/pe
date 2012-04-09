import Data.List

fibsmod :: [Int]
fibsmod = 0:1:(fmgen 0 1) where
  fmgen a b = let c = (a+b) `mod` (1000000000) in
    c:(fmgen b c)

fibstrunc :: [Int]
fibstrunc = 0:1:(fgen 0 1) where
  fgen a b = let d = if a + b > 10^18 then (`div` 10) else (id) in 
    (a+b):(fgen (d b) (d (a+b)))
  
fibs = 0:1:(fgen 0 1) where
  fgen a b = (a+b):(fgen b (a+b))
  
fibslast9p = filter ((==['1'..'9']).sort.(take 9).reverse.show.snd) $ zip [0..] fibs
fibsfirst9p = filter ((==['1'..'9']).sort.(take 9).show.snd) $ zip [0..] fibs
  
fibsmodlast9p = filter ((==['1'..'9']).sort.show.snd) $ zip [0..] fibsmod
fibstruncfirst9p = filter ((==['1'..'9']).sort.(take 9).show.snd) $ zip [0..] fibstrunc

isect [] _ = []
isect _ [] = []
isect (x:xs) (y:ys) | x < y = isect xs (y:ys)
                    | y < x = isect (x:xs) ys
                    | otherwise = x:(isect xs ys)
                                  
fibsfirstlast9p = isect (map fst fibsmodlast9p) (map fst fibstruncfirst9p)
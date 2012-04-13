import Data.Numbers.Primes

spiral_diags' = sp 3 2 where
  sp n j = (n,j+1):(n+j,j+1):(n+j*2,j+1):(n+j*3,j+1):(sp (n+j*4+2) (j+2))
  
spiral_diags = map fst $ spiral_diags'
  
isect n nprimes (p:ps) (t:ts) 
  | ((n`mod`4) == 0) && 
      10*nprimes < n = [(t,nprimes,n,((fromIntegral nprimes)/(fromIntegral n)))]
  | p < t = isect n nprimes ps (t:ts)
  | p > t = isect (n+1) nprimes (p:ps) ts
  | otherwise = (p,nprimes,n,((fromIntegral nprimes)/(fromIntegral n))) : isect (n+1) (nprimes + 1) ps ts
                
--main = sequence $ map print $ isect 1 0 primes spiral_diags
                                  
--52481
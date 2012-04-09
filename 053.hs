-- n          n!
--  c  =   --------
--   r     r!(n-r)!
--
-- n             n!                 n!                 n!(n-r)       / n   \ (n-r)
--  c    = -------------- = --------------------- = ------------- = |   c   |-----
--   r+1   (r+1)!(n-r-1)!   (r+1)r!((n-r)!/(n-r))   (r+1)r!(n-r)!    \   r / (r+1)
--
-- n             n!                  n!                 n!r          / n   \    r
--  c    = -------------- = ------------------- = --------------- = |   c   |-------
--   r-1   (r-1)!(n-r+1)!   (r!/r)(n-r+1)(n-r)!   r!(n-r)!(n-r+1)    \   r / (n-r+1)
--
-- n-r > r+1 --> n+1 > 2r

import PEFuncs

crn n r = (factorial n)`div`((factorial r)*(factorial (n-r)))

crn_below m n = minimum [n-1,2 * (cb n 1)] where
  cb x r | 2*r >= n+1 = 0 
         | x <= m = 1 + (cb ((x*(n-r))`div`(r+1)) (r+1)) 
         | otherwise = 0
                       
crn_above_mil n = (n-1) - (crn_below 1000000 n)

main = print $ sum $ map crn_above_mil [1..100]
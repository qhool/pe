import Data.List
import Data.Ord

intRtSols :: Integral a => a -> [[a]]
intRtSols p = filter (\(x) -> (x!!0) < (x!!1)) $ filter ((==p).sum) $ map rtsol [1..(truncate ((fromIntegral p)/3))] 
  where
  rtsol a = let b = ((fromIntegral p)^2 - (fromIntegral (2*a*p)))/(fromIntegral (2*(p - a)))
            in [ a, (truncate b), truncate ((fromIntegral p) - (fromIntegral a) - b) ]  
               
maxIntRtSols = maximumBy (comparing length) $ map intRtSols [3..1000]

    -- a^2 + b^2 = c^2
    -- a + b + c = p ---> c = p - a - b 
    -- a^2 + b^2 = (p - a - b)^2 
    --           = p^2 - ap - bp - ap + a^2 + ab - bp + ab + b2
    --           = p^2 + a^2 + b^2 - 2ap - 2bp + 2ab 
    --         0 = p^2 - 2ap - 2bp + 2ab
    --         0 = p^2 - 2ap + (2a - 2p)b
    --(2p - 2a)b = p^2 - 2ap
    --
    --             p^2 - 2ap
    --         b = ---------
    --              2p - 2a              
    
import Data.Ratio
import Data.IntMap (IntMap)
import qualified Data.IntMap as IntMap
 
blueChance n = 1%((fromIntegral n)+1)

blueDistribution :: Int -> IntMap Rational
blueDistribution 1 = IntMap.fromList [(0,1%2),(1,1%2)]
blueDistribution n = addTurn (blueDistribution (n-1)) (blueChance n) where
  addTurn m t = IntMap.fromListWith (+) $ concat $ 
                map (\(n,p) -> [(n+1,p*t),(n,p*(1-t))]) $ IntMap.toList m
                
                
winChance n = sum $ map snd $
              filter ((>n).(*2).fst) $ 
              IntMap.toList $ blueDistribution n
              
prizeMoney n = floor $ fromRational $ (1/(winChance n))
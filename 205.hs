import Data.Ratio
import Data.IntMap (IntMap)
import qualified Data.IntMap as IntMap

roll :: Int -> [(Int,Rational)]
roll n = [ (x,1%(fromIntegral n)) | x <- [1..n] ]

addRolls :: [(Int,Rational)] -> [(Int,Rational)] -> [(Int,Rational)]
addRolls r s = IntMap.toList $ IntMap.fromListWith (+) $
               [ ((fst a)+(fst b),(snd a)*(snd b)) | a <- r, b <- s ]

rollNDM n m = foldl1 addRolls $ take n $ repeat (roll m)

negRoll r = map (\(n,p) -> (-n,p)) r

rollVS n d n' d' = addRolls (rollNDM n d) (negRoll $ rollNDM n' d')

game = fromRational $ sum $ map snd $ filter ((>0).fst) $ rollVS 9 4 6 6


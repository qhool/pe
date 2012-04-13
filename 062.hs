import Data.List
import Data.Map (Map) 
import qualified Data.Map as Map

sortDigits :: Integral a => a -> String
sortDigits n = sort $ show n

cubes :: Integral a => [a]
cubes = [ n*n*n | n <- [2..] ]

cubeHash digits = Map.fromListWithKey (\k s t -> s ++ t)
               $ takeWhile ((<digits).length.fst)
               $ map (\q -> (sortDigits q, [q])) cubes
                  
                  
cubeFive digits = concat $ Map.elems 
                  $ Map.filter ((==5).length) $ cubeHash digits


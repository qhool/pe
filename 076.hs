import Data.Array
import Debug.Trace

--numWaysX :: Integral a => (a, a, a, a, Array (Int,Int) a) 
--           -> (a,a,a,a,Array (Int,Int) a) 
--numWaysX (target,maxval,tot,multiple,memo)
--  | maxval == 1 = (1,
--  | otherwise = 
--                $ map (\n -> numWays (tot - (maxval*n)) (maxval - 1) memo) 
--                (0 

nCombos target = combolist where
  combolist = (take target $ repeat 1 ) ++ (take target $ repeat 1) ++
              [ sum $ map (\n -> if (targ - n*max_num) == 0 then 1 
                                 else
                                   combolist!!((max_num - 1)*target +
                                               (targ - n*max_num - 1))
                          )
                $ takeWhile ((<=targ).(*max_num)) [0..]
              | max_num <- [2..(target-1)], targ <- [1..target] ]

xxx target = (take target $ repeat [0 ]) ++ (take target $ repeat [1]) ++ [ takeWhile ((<targ).(*max_coin)) [0..] | max_coin <- [2..(target-1)], targ <- [1..target] ]

nc target = chunk $ nCombos target where
  chunk t | length t == 0 = []
          | otherwise = ( take target t ) : ( chunk $ drop target t )
--main = print $ numWays
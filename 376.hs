import Data.Ratio
import Data.List
import Timer

fact n = product [1..n]

nck n k = (fact n) `div` ( (fact (n-k)) * (fact k) )

genDice faces maxFace = gd faces 1 where
  gd 0 _ = []
  gd 1 minFace = map (:[]) [minFace..maxFace]
  gd f minFace = (map ((:)minFace) (gd (f-1) minFace)) ++
                 (if minFace < maxFace then (gd f (minFace+1)) else [])
                 
runsBy f t = rby [] t where
  rby _ [] = []
  rby [] (t:ts) = rby [t] ts
  rby run (t:ts) | (f (head run) t) = rby (t:run) ts
                 | otherwise = run:(rby [t] ts)
                               
runs n m = map (\t -> (head t, fromIntegral (length t))) $ filter ((>2).length) $ runsBy (==) $ sort $ map sum $ genDice n m

--winChanceVs a b = (1%(length a)) * (sum $ map (`facetWin` b) a ) where
--  facetWin n b = (length $ takeWhile (<n) b)%(length b)
  
winChanceVs a b = wcv a b 0 0 0 where
  wcv [] [] alen blen nwins = (nwins%(alen*blen))
  wcv [] bs alen blen nwins = wcv [] [] alen (blen + (length bs)) nwins
  wcv as [] alen blen nwins = wcv [] [] (alen + (length as)) blen (nwins + (length as)*blen)
  wcv (a:as) (b:bs) alen blen nwins | a > b = wcv (a:as) (bs) alen (blen+1) nwins   
                                    | a <= b = wcv as (b:bs) (alen+1) blen (nwins + blen)

--beatsHowMany f = length $ filter ((>(1%2)).([1,1,2,3,4,5] `f`)) $ genDice 6 22

--wcvTest = sequence $ map (uncurry timeWork) [ ("a'", beatsHowMany winChanceVs'),
--                                              ("a", beatsHowMany winChanceVs) ]


winlosefraDice f dice = filter (\d -> any ((f(1%2)).(winChanceVs d)) dice) dice

loserDice dice = winloseDice (>) dice

winnerDice dice = winloseDice (<) dice
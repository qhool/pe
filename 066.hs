import PEFuncs
import Data.List
import Data.Function
import Data.Maybe

{-

x^2 - D * y^2 = 1
x^2 = D*y^2 + 1

-}

diophant d y = d*y*y + 1

maybeHead [] = Nothing
maybeHead (x:_) = Just x

diophantineXinYs ys d = maybeHead $ filter (\x -> (fromIntegral $ floor x) == x) $ 
                              map (sqrt.fromIntegral.(diophant d)) ys
                 
diophantineXsNotInYs ys ds = map fst $ filter (isNothing.snd) $ map (\d -> (d,diophantineXinYs ys d)) ds

diophantineXsAscending step = iterate dxny (0,filter (not.is_square) [1..1000]) where
  dxny (yK,ds) = (yK+1,diophantineXsNotInYs [yK*step+1..(yK+1)*step] ds)
  
takeUntil f [] = []  
takeUntil f (x:xs) | f x = [x]
                   | otherwise = x:(takeUntil f xs)
  
diophs step = map (\(y,ds) -> (y*step, length ds, head ds, last ds)) $ 
              takeUntil ((<2).length.snd) $
              diophantineXsAscending step
              
chg_diophs step = cdph 1001 $ diophs step where
  cdph prev_n ((y, n, h, l):ds) | n == prev_n = cdph n ds
                                | otherwise = (y,n,h,l):(cdph n ds)

main = sequence $ map print $ chg_diophs 2

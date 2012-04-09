import Data.List
import Data.Ord
import Debug.Trace

rectSolutions w h = sum [ (w-w'+1)*(h-h'+1) | w' <- [1..w], h' <- [1..h] ]  

target :: Int
target = 2000000

bestRect (best_area, best_num) w h =
  ( let area = w * h
        num = rectSolutions w h
    in
     trace ( (show (area, num, abs(num - target), abs(best_num - target))) ++ " " ++ (show w) ++ " " ++ (show h) )
     ( if (abs (best_num - target)) <= (abs (num - target)) then (best_area, best_num)
       else
         foldr (\(w',h') (a,n) -> bestRect (a,n) w' h') (area,num)
         [ (w+dw,h+dh) | dw <- [-3..(-1)], dh <- [1..3], w+dw > 0, h+dh > 0, w+dw > h+dh ]
     )
  ) 
  
sign :: (Num a, Ord a) => a -> Int
sign n = if n > 0 then 1 else -1
  
bestH :: Int -> Int -> Int -> Int -> Bool -> Int
bestH w h prev_h prev_num crossed = 
  let num = rectSolutions w h
      prev_dist = abs(prev_num - target)
      dist = abs(num - target)
      crossed' = crossed || (num > target)
      delta = abs(h - prev_h)
      delta' = ( sign $ target - num ) * (if crossed' then (max (delta `div` 2) 1) else (2 * delta))
  in
   if crossed && (abs(delta') == 1) && prev_dist <= dist then prev_h else
     --trace ( show (w, h, delta, num) ) $
     bestH w (h + delta') h num crossed'
                      
bestHeight w = bestH w 1 0 0 False

bestHeights = takeWhile (\(w,h,s) -> w <= h) $
  map (\(w,h) -> (w,h,rectSolutions w h)) $ map (\w -> (w, bestHeight w)) [1..]
  
best = minimumBy (comparing (\(w,h,s) -> abs(s - target))) bestHeights
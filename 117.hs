import Tiles

crossConcat ts us = concat $ map ($us) (map applTo ts) where
  applTo t us = map ($t) $ map (flip (++)) us

waysToDivide2 t s = concat $
  map (\d -> crossConcat (waysToDivide (head d) s) [tail d]) t
  
waysToDivideWith n tiles = foldl waysToDivide2 [[n]] tiles

arrangementsWith n tiles = sum $ map waysToArrange $
                           waysToDivideWith n tiles
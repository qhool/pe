import Tiles



divideOneColor n t = filter ((!=0).last) $
                     concat $ map (waysToDivide n) t

oneColorArrangements n t = sum $ map waysToArrange $ divideOneColor n t


import Data.Array
import Data.Maybe
import Debug.Trace

myMat :: Array (Int,Int) Integer
myMat = listArray ((1,1),(5,5)) [131,673,234,103,18,201,96,342,965,150,630,803,746,422,111,537,699,497,121,956,805,732,524,37,331]

maxI arr = fst $ snd $ bounds arr
maxJ arr = snd $ snd $ bounds arr

extractElems :: Ix i => Array i e -> [i] -> [e]
extractElems a (x:xs) | inRange (bounds a) x = (a!x):(extractElems a xs)
                      | otherwise = extractElems a xs
extractElems a _ = []

mindex :: (Ix i,Ord e) => Array i (Maybe e) -> i -> i -> e
mindex a i1 i2 = minimum $ catMaybes $ extractElems a [i1,i2]

minPathsRD :: (Ix a,Ord a,Num a,Ord e,Num e) => Array (a,a) e -> a -> a -> Array (a,a) (Maybe e) -> Array (a,a) (Maybe e)
minPathsRD a i j mins | trace ("minPathsRD " ++ show i ++ " " ++ show j) False = undefined
minPathsRD a i j mins | trace "checkbounds" $ (i > (maxI a)) || (j > (maxJ a)) = trace "oob" mins
                      | trace "checkMemo.." $ isJust (mins ! (i,j)) = trace "memozed" mins
                      | (i == (maxI a)) && (j == (maxJ a)) = trace "At MAX!!!" $ mins // [ ((i,j), Just (a ! (i,j))) ] 
                      | otherwise = trace "other" $
                                    let numins = trace "numin" $ minPathsRD a i (j+1) $ minPathsRD a (i+1) j mins
                                    in numins // [ ((i,j), Just $ ( a ! (i,j) ) + 
                                                           ( mindex numins (i,(j+1)) ((i+1),j) ) ) ] 
                      
                              
--main = print $ minPathRD myMat 1 1

initMins :: Ix i => Array i e -> Array i (Maybe e)
initMins a = listArray (bounds a) (take (length (elems a)) (repeat Nothing))
                                       
--minPathRDmins a = minPathRDamij a (initMins) 1 1
--minPathRD :: Ix i => Array i e -> e
minPathRD a = fromJust $ (minPathsRD a 1 1 (initMins a)) ! (1,1)
                              
rdInt :: String -> Integer
rdInt = read
main = do
  contents <- getContents
  print $ minPathRD $ listArray ((1,1),(80,80)) $ map rdInt $ concat $ map words $ lines contents
                              
--main = print 10
--main = print $ minPathRD myMat

containsInOrder :: Eq a => [a] -> [a] -> Bool
_ `containsInOrder` [] = True
[] `containsInOrder` _  = False
(c1:s1) `containsInOrder` all_sub@(c2:s2)  
  | c1 == c2 = s1 `containsInOrder` s2
  | otherwise = s1 `containsInOrder` all_sub 

containsAllInOrder :: Eq a => [a] -> [[a]] -> Bool
_ `containsAllInOrder` [] = True 
[] `containsAllInOrder` _ = False
x `containsAllInOrder` y 
  = foldr (&&) True (map (x `containsInOrder`) y)
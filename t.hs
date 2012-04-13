times 0 _ = 0
times 1 n = n
times n m | n > m = times m n 
          | otherwise = sum $ take n $ repeat m
                        
mysubseq (x:xs) = let subs = mysubseq xs in
  ( map (x:) subs ) ++ subs
mysubseq _ = [[]]
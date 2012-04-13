module Timer where

import Data.Time

timeWork msg f = do 
  start <- getCurrentTime
  putStrLn msg
  print f
  end <- getCurrentTime
  putStr "Seconds elapsed: "
  print (diffUTCTime end start)
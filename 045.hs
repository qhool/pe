import Data.Maybe
import PEFuncs


main = print $ take 1 $ dropWhile (<=40755) $ filter is_triangle $ filter is_pentagonal hexNums 
                             
--- triangle
--- x = n(n+1)/2
--- 2x = n(n+1)
--- n^2 + n - 2x
--- 
---     -1 +- sqrt(1 + 8x)
--- n = ------------------
---              2
---
---      -1 + 5 
--- n3 =  ------
---        2

--- pentagonal
--- x = n(3n−1)/2
--- 2x = n(3n-1) = 3n^2 - n
--- 3n^2 - n - 2x
---
---     1 +- sqrt(1 - 4 * 3 * -2x)   1 + sqrt(1 + 24x)
--- n = -------------------------- = ------------------
---                 6                        6
---

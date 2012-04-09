import Data.Set (Set)
import qualified Data.Set as Set

data AlmostEQ = AlmostEQ { base :: Int,
                           side :: Int } deriving (Show)

data Pythag = Pythag { a :: Int, b :: Int, c :: Int } deriving (Show)

{-

base odd:

h^2 - b^2 - 0.25

2*m^2 - 2*n^2 ~= m^2 + n^2
m^2 ~= 3*n^2
n ~= sqrt(m^2/3)

2mn ~= m^2 + n^2
2m ~= m^2 + n
n ~= 2m - m^2

-}

isInt x = (fromIntegral $ floor x) == x

squares = Set.fromList $ takeWhile (<400000000) $ map (^2) [1..]

isSquare n = n `Set.member` squares

cp :: Integral a => a -> [a] 
cp n = --let approx_m = floor $ sqrt $ (fromIntegral (n^2))/3 in
             filter ((==1).(gcd n)) $ 
             filter ((/=(n `mod` 2)).(`mod` 2)) $ 
             filter (<n) $ filter (>0) [1..n] -- [approx_m-1000..approx_m+1000]
               

pTriples = map (\t -> if (a t) > (b t) then Pythag { a = (b t), b = (a t), c = (c t) } else t ) 
           [ Pythag { a = m^2 - n^2, b = 2*m*n, c = m^2 + n^2 } | m <- [1..], n <- cp m ] 

almostEQs = filter (\t -> abs( (base t) - (side t) ) == 1 ) $
            map (\t -> AlmostEQ { base = 2*(a t), side = (c t) } ) pTriples

perimeter t = 2*(base t) + (side t)
  
  
-- [2,6,16,66,240,902,3360,12546,46816,174726,652080,2433602,9082320,33895686,92604734,126500416,185209464,194291788,253000836,286896518]

main = print $ sum $ takeWhile (<=1000000000) $ map perimeter almostEQs
import Data.Set (Set)
import qualified Data.Set as Set

squareMap max = Set.fromList $ takeWhile (<max) $ map (^2) [1..]

test max = length $ filter (`Set.member` (squareMap max)) [1..max]

main = print $ test 10000000
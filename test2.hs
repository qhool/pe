isInt x = (fromIntegral $ floor x) == x

test max = length $ filter (isInt.sqrt) [1..max]

main = print $ test 10000000
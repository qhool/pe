import PEFuncs

aToTheB = [ a^b | a <- [1..99], b <- [1..99] ]

main = print $ maximum $ map (sum.digits) aToTheB
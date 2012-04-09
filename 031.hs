english_coins = reverse [1,2,5,10,20,50,100,200]

ncombos amount coins = if length coins == 1
                       then if gcd (head coins) amount == (head coins)
                            then 1
                            else 0
                       else sum [ ncombos (amount - n*(head coins)) (tail coins) |
                                  n <- [0..amount], n * (head coins) <= amount ]

from funcs import is_palindrome

max_pal = 0
for i in range(100,1000):
    for j in range(100,1000):
        p = i*j
        if is_palindrome(p) and p > max_pal:
            max_pal = p

print max_pal

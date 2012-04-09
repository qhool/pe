#!/usr/bin/env python
from funcs import permute,select_sublist

def max_num(digits):
    return int(''.join(map(str,digits[::-1])))
def num(digits):
    return int(''.join(map(str,digits)))

digits = map(int,"123456789")
dset = set(map(str,digits))
len_digits = len(digits)
nums = set()
for i in range(1,2**len_digits-1):
    a_digits = select_sublist(digits,i)
    bc_digits = select_sublist(digits,2**len_digits-1-i)
    #print a_digits, "/", bc_digits
    max_bc = max_num(bc_digits
    #if num(a_digits) > max_bc:
    #    continue
    for ap in permute(a_digits):
        a = num(ap)
        #print "a = ", a
        #if a > max_bc:
        #    continue
        len_bc = len(bc_digits)
        for j in range(1,2**len_bc-1):
            b_digits = select_sublist(bc_digits,j)
            c_digits = select_sublist(bc_digits,2**len_bc-1-j)
            #print "bc {0} / {1}".format(b_digits,c_digits)
            max_c = max_num(c_digits)
            #if a * num(b_digits) > max_c:
            #    continue
            for bp in permute(b_digits):
                b = num(bp)
                #print "ab {0} / {1}".format(a,b)
                c = a*b
                abc = str(a)+str(b)+str(c)
                
                if len(abc) == len_digits and set(abc) == dset:
                    print "=======>>> {0} * {1} = {2}".format(a,b,a*b)
                    nums.add(a*b)

print sum(nums)

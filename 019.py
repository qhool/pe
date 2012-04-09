#!/usr/bin/env python
from copy import copy
days_in = [31] * 12
for m in [9,4,6,11]: #September, April, June, and November
    days_in[m-1] = 30
days_in[1] = 28
first_days = map( lambda m: sum(days_in[:m]), range(12) )
first_days_ly = copy(first_days)
for i in range(2,12):
    first_days_ly[i] += 1

dayno = 2
tot = 0 
for year in range(1901,2001):
    fdays = first_days
    ndays = 365
    if year%4 == 0:
        fdays = first_days_ly
        ndays = 366
    tot += sum( map( lambda fd: 1 if (fd+dayno)%7 == 0 else 0, fdays ) )
    dayno = (dayno + ndays)%7
print tot

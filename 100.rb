#(1414213562371..10**13).step(2) do
# (3..5000000000).step(2) do
#   |i|
#   p = i**2
#   n_prod = (p-1)/2
#   n = Math.sqrt(n_prod).to_i + 1
#   #if i % 1000000 == 1 then
#   #  print "i = ", i, "\tn = ", n, "= 10^", Math.log(n)/Math.log(10), "\n"
#   #end
#   if (n+1)**2 - n - 1 == n**2 + n then
#     print "!"
#   else
#     print "."
#   end
#   if n*(n-1) == n_prod then
#     print Math.sqrt(n_prod), "^2 = ", n_prod, "\n"
#     print "i = ", i, "\tn = ", n, "\t"
#     b = (i + 1)/2
#     print " b = ", b, "\n"
#     if 2*b*(b-1) != n_prod then
#       print "Noooo!\n"
#     #else
#     #  break
#     end
#   end
# end
  

(1..10000).each do
  |n|
  sq = Math.sqrt( n*(n+1) )
  if n < sq and sq < n+1 then
    print n, "\n"
  end
end

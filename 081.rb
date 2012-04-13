require 'matrix_path'

pm = PathMatrix.new( 'matrix.txt', [ [1,0], [0,1] ] )
pm.set_destination( [79,79] )
print "Minimum path is ", pm.find_min_path( [0,0] ), "\n"

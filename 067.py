import imp
tfunc = imp.load_source( 'tfunc', '018.py' )

f = open('067triangle.txt')
tstr = f.read()

middle,t = tfunc.init_triang(tstr)
print tfunc.max_sum(t,0,middle)

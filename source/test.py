y=1
x=0
while y < 1000000000000:
	x=(13*(x**2)-1)**(1/2)
	y +=1
if isinstance( x, ( int, long ) ):
	print x



#include <stdio.h>

int count_divisors( int n ) {
  int n_divs = 2;
  int i, max_check;
  
  max_check = n / 2;
  for( i = 2; i <= max_check; i++ ) {
    if( n % i == 0 )
      n_divs++;
  }
  return n_divs;
}

void main() {
  int t = 0;
  int i = 0;
  int max_divs = 0;
  int n_div;

  while( 1 ) {
    i++;
    t = t + i;
    n_div = count_divisors( t );
    if( n_div > max_divs ) {
      printf( "%d has %d divisors\n", t, n_div );
      max_divs = n_div;
      if( n_div > 500 ) {
	break;
      }
    }
  }

  printf( "%d\n", t );
}

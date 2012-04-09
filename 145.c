#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>

unsigned long reversenum( unsigned long n ) {
  char str[50];
  char rev[50];
  int i,len;
  unsigned long ret;
  sprintf( str, "%lu", n );
  len = strlen(str);
  for(i=0;i<len;i++) {
    rev[i] = str[len - i - 1];
  }
  rev[len] = '\0';
  sscanf( rev, "%lu", &ret );
  return ret;
}

int is_all_odd( unsigned long n ) {
  char str[50];
  int len,i;
  sprintf( str, "%lu", n );
  len = strlen(str);
  for(i=0;i<len;i++) {
    if( (str[i] - '0')%2 == 0 ) {
      return 0;
    }
  }
  return 1;
}

void main() {
  unsigned long n = 1;
  char str[50];
  int count = 0;
  unsigned long rn;
  unsigned int pten;
  unsigned long min,max,last_digit,first_digit;
  min = 1;
  for( pten = 0; pten<9; pten++ ) {
    max = min*10;
    printf( "pten: %lu\n", pten );
    for( n = min; n < max; n++) {
      //printf( "%lu\n", n );
      last_digit = n%10;
      if( last_digit == 0 )
	continue;
      first_digit = n/min;
      if( (last_digit + first_digit)%2 == 0 )
	continue;
      //rn = reversenum(n);
      count += is_all_odd(n + reversenum(n));
    }
    min = max;
  }
  printf( "total: %d\n", count );

}

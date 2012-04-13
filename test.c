#include <stdio.h>

void main() {
  int i,j;
  double k;

  for( i = 1; i <= 12000; i++ ) {
    for( j = 1; j < i; j++ ) {
      k = (double)i/(double)j;
      //printf( "%f\n", k );
    }
  }
}

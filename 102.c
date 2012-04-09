#include <stdio.h>
#include <stdlib.h>
#include "petools.h"


void main() {
  int x[3], y[3], num_t = 0, num = 0, i;
  x[0] = -175; y[0] = 41;
  x[1] = -421; y[1] = -714;
  x[2] = 574; y[2] = -645;
  while( TRUE ) {
    scanf( "%d,%d,%d,%d,%d,%d", x, y, x+1,y+1, x+2, y+2 );
    if( feof( stdin ) ) {
      break;
    }
    //for( i = 0; i < 3; i++ ) {
    //  printf( "%d,%d  ", x[i],y[i] );
    //}
    if( includes_origin( x, y ) ) {
      //  printf( " -- yes\n" );
      num += 1;
    }
    //else {
    //  printf( "\n" );
    //}
    //break;
    num_t += 1;
  }
  printf( "total: %d out of %d\n", num, num_t );
}

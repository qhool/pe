#include "petools.h"
#include <stdio.h>

crossing y_crossing( int x1, int y1, int x2, int y2 ) {
  double slope,err=1e-12,cross;
  if( (x1 > 0 && x2 > 0) || 
      (x1 < 0 && x2 < 0) ) {
    return NONE;
  }
  if( y1 == y2 && y1 == 0 ) {
    return ZERO;
  }
  /*if( x1 > x2 ) {
    return y_crossing( x2, y2, x1, y1 );
    }*/
  if( x1 == 0 ) {
    cross = y1;
  } else if( x2 == 0 ) {
    cross = y2;
  } else if( y1 == y2 ) {
    cross = y1;
  } else {
    slope = ((double)(y2-y1))/((double)(x2-x1));
    cross = y1 - slope * x1;
    if( (cross*(cross<0?-1:1)) < err ) {
      cross = 0;
    }
  }
  if( cross == 0 ) {
    return ZERO;
  } else if( cross < 0 ) {
    return NEGATIVE;
  } else {
    return POSITIVE;
  }
}

crossing crossings( int x[3], int y[3] ) {
  crossing cross, tot = 0; 
  int *cx = x, *cy = y, i,j,k;
  for( k = 0; k < 2; k++ ) {
    for( i = 0; i < 3; i++ ) {
      for( j = i+1; j < 3; j++ ) {
	cross = y_crossing( cx[i], cy[i], cx[j], cy[j] );
	if( cross == ZERO ) {
	  return ZERO;
	}
	tot |= cross << (2*k);
      }
    }
    //switch coordinates
    cx = y;
    cy = x;
  }
  //printf( "  %d  ", tot );
  return tot;
}

bool includes_origin( int x[3], int y[3] ) {
  return crossings(x,y) == ALL;
}


char *fmt_triangle( int x[3], int y[3] ) {
  static char str[256]; //allow 25 chars per int, plus slop
  snprintf( str, sizeof(str)/sizeof(char), "(%d,%d) (%d,%d) (%d,%d)",
	   x[0], y[0], x[1], y[1], x[2], y[2] );
  return str;
}

#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <stdlib.h>
#include "petools.h"

int i_n_border( int radius, int axial_dist ) {
  //find first value of 2nd coord where distance from origin >= n
  return ceil( sqrt( radius*radius - axial_dist*axial_dist ) );
}

typedef struct {
  int *x;
  int *y;
  int radius;
  int cur_yborder;
} quad_iter;

typedef struct {
  quad_iter qi;
  int *x;
  int *y;
  int qix;
  int qiy;
  int xflip;
  int yflip;
  int start_yflip;
} circ_iter;

void print_qiter( quad_iter *iter ) {
  printf( "x: %p\n", iter->x );
  printf( "y: %p\n", iter->y );
  printf( "*x: %d\n", *(iter->x) );
  printf( "*y: %d\n", *(iter->y) );
  printf( "radius: %d\n", iter->radius);
  printf( "yb: %d\n", iter->cur_yborder);
}

void reset_quad_iter( quad_iter *iter ) {
  *(iter->x) = -1;
  *(iter->y) = -1;
  iter->cur_yborder = 0;
}  

void init_quad_iter( int radius, quad_iter *iter, int *x, int *y ) {
  iter->x = x;
  iter->y = y;
  iter->radius = radius;
  reset_quad_iter(iter);
  //print_qiter( iter );
}

int iter_quad( quad_iter *iter ) {
  (*iter->y)++;
  if( *(iter->y) >= iter->cur_yborder ) {
    (*iter->x)++;
    *iter->y = 0;
    iter->cur_yborder = i_n_border( iter->radius, *(iter->x) );
  }
  if( *iter->x >= iter->radius )
    return 0;
  return 1;
}

int iter_pos_quad( quad_iter *iter ) {
  do {
    if( !iter_quad( iter ) ) {
      break;
    }
  } while( *iter->y == 0 || *iter->x == 0 );
}

void reset_circ_iter( circ_iter *iter ) {
  reset_quad_iter( &iter->qi );
  iter->xflip = 1;
  iter->yflip = iter->start_yflip | 1;
}

#define POSITIVE_AND_NEGATIVE_Y 1
#define NEGATIVE_Y_ONLY -1
#define POSITIVE_Y_ONLY 0

int init_circ_iter( int radius, int yflip, circ_iter *iter, int *x, int *y ) {
  init_quad_iter( radius, &iter->qi, &iter->qix, &iter->qiy );
  iter->x = x;
  iter->y = y;
  iter->start_yflip = yflip;
  reset_circ_iter( iter );
}

int iter_circ( circ_iter *iter ) {
  int ok, reloop;
  do {
    reloop = 0;
    ok = iter_quad( &iter->qi );
    if( ok ) {
      *iter->x = iter->qix * iter->xflip;
      *iter->y = iter->qiy * iter->yflip;
    } else {
      iter->xflip -= 2;
      if( iter->xflip < -1 ) {
	if( iter->start_yflip == 0 ) {
	  return 0;
	}
	iter->xflip = 1;
	iter->yflip -= 2;
	if( iter->yflip < -1 ) {
	  return 0;
	}
      }
      reset_quad_iter( &iter->qi );
      reloop = 1;
    }
  } while( reloop || 
	   ( ok && 
	     ( ( iter->xflip == -1 && iter->qix == 0 ) ||
	       ( iter->yflip == -1 && iter->qiy == 0 ) ) ) );
  return ok;
}

int sign( int x ) {
  if( x > 0 ) return 1;
  else if( x < 0 ) return -1;
  else return 0;
}

//return number of steps *in* included region, not counting starting position
//vec should be a pointer to the x or y value to be modified
int border_search( int x[3], int y[3], int *vec, int dir, int max ) {
  int orig_vec = *vec, a = 0, b = max, c = max, dist;
  //printf( "Border search %d - %d = ", *vec + a, *vec + max );
  while( b > a + 1 ) {
    *vec = orig_vec + c * dir;
    if( includes_origin( x, y ) ) {
      printf( "%s\n", fmt_triangle( x, y ) );
      a = c;
    } else {
      b = c;
    }
    c = (b-a)/2 + a;
    if( c == a )
      c = a + 1;
  }
  *vec = orig_vec;
  //printf( " %d\n", a );
  return a;
}

int axial_search( int radius, int x[3], int y[3], int *axis, int *cross ) {
  int axial_dir = *axis, count = 0, max, rsq = radius * radius, asq;
  printf( "Axial search %d (%d,%d) ", radius, x[2], y[2] );
  while( *axis * axial_dir < radius ) {
    printf( "..%d..", *axis );
    asq = (*axis)*(*axis);
    max = (int)floor(sqrt(rsq - asq));
    if( asq + max*max == rsq ) 
      max--;
    count += border_search( x, y, cross, -1, max ) + border_search( x, y, cross, 1, max ) + 1;
    (*axis) += axial_dir;
  }
  printf( "%d\n", count );
  return count;
}

int diagonal_search( int radius, int x[3], int y[3] ) {
  int x2u = x[2], y2u = y[2], rsq = radius * radius;
  char prev_dir = 'Y', dir;
  crossing cross;
  printf( "diagonal search\n" );
  //for any point w/ nonzero coords in this quadrant, we'll either:
  // -- include the origin
  // -- miss so that we hit the x axis on the boundary of the quadrant
  // --                     ... y axis ...
  // in the 2nd case, the sign of the x crossing will match x2u
  //   which means abs(y)  should be increased, or abs(x) decreased
  // in the 3rd ..                 .. y ...                 y2u
  //   abs(x) should grow, abs(y) shrink
  while( x[2] * x[2] + y[2] * y[2] < rsq ) {
    cross = crossings( x, y );
    if( cross == ALL ) {
      //printf( "%s\n",  fmt_triangle( x, y ) );
      return 1;
    }
    if( cross == ZERO || cross == NONE ) {
      dir = prev_dir;
    }
    else if( ( (x2u > 0) && (cross & X_POSITIVE) ) ||
	     ( (x2u < 0) && (cross & X_NEGATIVE) ) ) {
      //case 2, increment y:
      dir = 'Y';
    } else {
      //case 3, increment x:
      dir = 'X';
    }
    if( dir == 'X' ) {
      x[2] += x2u;
    } else {
      y[2] += y2u;
    }
    prev_dir = dir;
    
    //printf( "%d, %d -- %d\n", x[2], y[2], cross );
  }
  //fail!
  //exit(1);
  return 0;
}

int completions_count( int radius, int x[3], int y[3] ) {
  int i,x2u, y2u;
  for( i = 0; i < 1; i++ ) {
    if( x[i] == 0 && y[i] == 0 ) {
      return 0;
    }
  }
  if( ( x[0] == 0 && x[1] == 0 ) ||
      ( y[0] == 0 && y[1] == 0 ) ) {
    return 0;
  }
  if( sign(y[0]) + sign(y[1]) != 0 ) { //zero and either sign or both same sign
    if( sign(x[0]) + sign(x[1]) == 0 ) { //opposite signs
      x[2] = 0; y[2] = -1 * ( sign(y[0]) || sign(y[1]) );
      return axial_search( radius, x, y, y+2, x+2 );
    } else { // x's are same or zero, y's same or zero
      //start at (+-1,+-1) in the appropriate quadrant
      x[2] = -1 * ( sign(x[0]) || sign(x[1]) );
      y[2] = -1 * ( sign(y[0]) || sign(y[1]) );
      return diagonal_search( radius, x, y );
    }
  } else { //y's are opposisite
    if( sign(x[0]) + sign(x[1]) != 0 ) { //same or zero
      y[2] = 0; x[2] = -1 * ( sign(x[0]) || sign(x[1]) );
      return axial_search( radius, x, y, x+2, y+2 );
    } else { //y's opposite, x's opposite
      for( x[2] = -1; x[2] <= 1; x[2] += 2 ) {
	for( y[2] = -1; y[2] <= 1; y[2] += 2 ) {
	  if( includes_origin( x, y ) )
	    return diagonal_search( radius, x, y );
	}
      }
      printf( "opp opp fail\n" );
      return 0;
    } 
  }
  printf( "exit fail\n" );
  return 0;
}


#define RADIUS 3
#define MAX_1ST 100000

void main() {
  int x[3], y[3], i;
  int xflip, yflip;
  long num_lines = 0, num_triang = 0, num_completed = 0;
  quad_iter iter1;
  circ_iter iter2, iter3;
  printf( "Searching I_%d...\n", RADIUS );
  init_quad_iter( RADIUS, &iter1, x, y );
  init_circ_iter( RADIUS, POSITIVE_Y_ONLY, &iter2, x+1, y+1 );
  while( iter_pos_quad( &iter1 ) ) {
    reset_circ_iter( &iter2 );
    while( iter_circ( &iter2 ) ) {
      //printf( "%s\n",  fmt_triangle( x, y ) );

      if( x[1] > 0 && y[1] > 0 && 
	  ( x[1] < x[0] || (x[1] == x[0] && y[1] <= y[0] ) ) )
	continue;
      //if( y[1] == 0 )
      //continue;
      num_lines++;
      num_triang += completions_count( RADIUS, x, y );
      num_completed++;
      
      if( num_completed > MAX_1ST )
	break;
      /*if( y[2] >= 0 || x[2] > 0 ) {
	printf( "wierd: %s\n",  fmt_triangle( x, y ) );
	}*/

      

    }
    if( num_completed > MAX_1ST )
      break;
  }

  printf( "%ld first sides;\t%ld (%.1f%%) completable;\t%ld triangles\n", 
	  num_lines, num_completed, ((double)num_completed/(double)num_lines)*100.0, num_triang );
}

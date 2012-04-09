#include <stdio.h>
#include <gmp.h>
#include <stdarg.h>
#include <math.h>

int cf_digits( int n, int *digits, 
	       int *cur_digit, mpf_t cur_val ) {
  int digit;
  mpf_t tmp;
  mpf_init( tmp );
  digit = mpf_get_si( cur_val );
  mpf_sub_ui( tmp, cur_val, digit );
  mpf_ui_div( cur_val, 1, tmp );
  mpf_clear(tmp);
  digits[*cur_digit] = digit;
  (*cur_digit)++;
  return digit;
}

int root_cont_fraction( int n ) {
  mpf_t cur_val, mp_n;
  int max_digit = 0;
  int min_cycle = 1;

  mpf_init( mp_n );
  mpf_init( cur_val );

  mpf_set_si( mp_n, n );
  mpf_sqrt( cur_val, mp_n );

  int digit, i, digits[1001];
  int r, j, k, is_cycle = 0;
  if( sqrt(n) == floor(sqrt(n)) ) {
    return 0;
  }
  //printf( "\n" );
  cf_digits( n, digits, &max_digit, cur_val );
  //look for repeats
  for( i=1; i < 1000; i++ ) {
    if( max_digit <= i )
      cf_digits( n, digits, &max_digit, cur_val );
    //printf( "i: %d=%d; r:", i, digits[i] );
    for( r = i+1; r < 1000; r++ ) {
      if( max_digit <= r )
	cf_digits( n, digits, &max_digit, cur_val );
      //printf( " %d=%d / ", r, digits[r] );
      if( digits[i] == digits[r] ) {
	//printf( " match!\n" );
	is_cycle = 1;
	for( j = 0; j < r - i; j++ ) {
	  if( digits[i+j] != digits[r+j] ) {
	    //printf( "[%d]=%d != [%d]=%d unmatch!!\n", 
	    //    i+j, digits[i+j], r+j, digits[r+j] );
	    is_cycle = 0;
	    break;
	  }
	}
	if( r - i < min_cycle ) {
	  is_cycle = 0;
	}
	else if( is_cycle && r - i == 1 ) {
	  for( k = 1; k < 10; k++ ) {
	    if( max_digit <= r+k ) {
	      cf_digits( n, digits, &max_digit, cur_val );
	    }
	    if( digits[r+k] != digits[r] ) {
	      is_cycle = 0;
	      min_cycle = (min_cycle> r - i)?min_cycle:(r-i);
	      min_cycle++;
	      //printf( "min cyc: %d\n", min_cycle );
	    }
	  }
	}
	if( is_cycle )
	  break;
      }
    }
    //printf( "r,j = %d,%d\n", r,j );
    if( is_cycle )
      break;
  }
  if( ! is_cycle ) {
    printf( "no cycle!! %d\n", n );
  }
  return r - i;
  printf( "root %d=[", n );
  for( j = 0; j < i; j++ ) {
    printf( "%d;", digits[j] );
  }
  printf( "(" );
  for( j = i; j < r; j++ ) {
    printf( j==i?"%d":",%d", digits[j] );
  }
  printf( ")], period = %d\n", r - i );

}

void main() {
  int i, num_odd = 0;
  mpf_set_default_prec( 2048 );
  for( i = 1; i < 10001; i++ ) {
    if( root_cont_fraction( i ) % 2 != 0 ) {
      num_odd++;
    }
  }
  printf( "Num odd = %d\n", num_odd );
}

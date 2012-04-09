#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <stdlib.h>

unsigned int sum_digits( unsigned long long n ) {
  unsigned int i, sum=0;
  char buf[100];
  sprintf( buf, "%llu", n );
  for( i = 0; buf[i] != '\0'; i++ ) {
    sum += buf[i] - '0';
  }
  return sum;
}

unsigned char is_a( unsigned long long n ) {
  unsigned int digit_sum;
  long double log_n, log_sd, log_rat;
  
  digit_sum = sum_digits(n);
  if( digit_sum > 1 ) {
    log_n = logl( n );
    log_sd = logl( sum_digits(n) );
    log_rat = log_n/log_sd;
    if( log_rat > 1 && ( truncl(log_rat) == log_rat ) ) {
      return 1;
    }
  }
  return 0;
}

int comp( const void *a, const void *b ) {
  if( *((unsigned long long *)a) < *((unsigned long long *)b) ) {
    return -1;
  } else if( *((unsigned long long *)a) > *((unsigned long long *)b) ) {
    return 1;
  } else {
    return 0;
  }
 
}

void main() {
  unsigned long long n, b, prev, max = 100000000000000000, min = 60466176;
//                                     18446744073709551615
 
  unsigned long long cands[100];
  int candidate_count = 0, count = 0, i;
  
  printf( "%llu\n", ULLONG_MAX );

  for( b = 2; b*b < max; b++ ) {
    //printf( "b: %llu\n", b );
    for( n = b*b; n < max && n > 0 ; n *= b ) {
      /*if( n < min )
	continue; */
      /*if( b == 4194304 ) {
	printf( "\tn: %llu\n", n );
	} */
      if( is_a( n ) ) {
	cands[candidate_count] = n;
	candidate_count++;
	printf( "candidate %u: %llu\n", candidate_count, n );
      }
      /* else if( b == 4194304 ) {
	printf( "nope? %llu\n", n * b );
	} */
    }
  }
  printf( "sorting: %d\n", candidate_count );
  qsort( cands, candidate_count, sizeof( unsigned long long int ), comp );
  prev = 0;
  for( i = 0; i < candidate_count; i++ ) {
    if( cands[i] != prev ) {
      prev = cands[i];
      count ++;
      printf( "%u: %llu\n", count, cands[i] );
    }
  }
  
}

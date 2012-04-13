#include <stdio.h>
#include <stdlib.h>

#define NUM_DIGITS 100

long num_decreasing( long num_digits, 
		     long first_digit,
		     long **buffer ) {
  long (*answers)[10];
  long num = 0;
  int i;
  answers = (long (*)[10])buffer;
  if( answers == NULL ) {
    /*printf( "calloc\n" ); */
    answers = (long (*)[10])calloc(sizeof(long), num_digits*20);
  }
  else if( answers[num_digits][first_digit] > 0 ) {
    //printf( "%ld\n", answers[num_digits][first_digit] );
    return answers[num_digits][first_digit];
  }  
  printf( "num_dec(%ld, %ld) = ", num_digits, first_digit );
  if( num_digits < 1 || first_digit == 0 ) {
    printf( "1\n" );
    return 1;
  }
  else if( num_digits == 1 ) {
    printf( "%ld\n", first_digit + 1 );
    return first_digit + 1;
  }
 
  printf( "....\n" );
  /* how many times current digit repeats */
  for( i=0; i<=num_digits; i++ ) {
    num += num_decreasing( num_digits - i, first_digit - 1, (long **)answers );
  }
  printf( ".......(%ld, %ld) = %ld\n", num_digits, first_digit, num );
  answers[num_digits][first_digit] = num;
  /*if( buffer == NULL )
    free( (void *)answers );*/
  return num;
}
  

void main() {
  long n=0;
  n = num_decreasing( NUM_DIGITS, 10, NULL ) +
    num_decreasing( NUM_DIGITS, 9, NULL ) - 2 - 10 * NUM_DIGITS;
  printf( "n=%ld\n", n );
}
  
/*
non_bouncy = 99
increasing = 54
decreasing = 63
both = 18
*/

/*
non_bouncy = 474
increasing = 219
decreasing = 282
both = 27
*/

/*
non_bouncy = 12951
increasing = 5004
decreasing = 8001
both = 54
*/

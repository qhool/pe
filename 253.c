#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void addpiece( int piece_num, unsigned long catersize, unsigned long *caterpillar ) {
  long pos = (random() % (catersize - piece_num));
  int i = 0;
  unsigned long c_val;
  for( i = 0; i<catersize; i++ ) {
    if( 0 == ((*caterpillar)>>i) % 2 ) {
      if( pos == 0 ) {
	*caterpillar = (*caterpillar) | ((1 << i) );
	return;
      }
      pos--;
    }
  }   
}

enum seg_state { OUT = 0, IN = 2 };

int countsegments( unsigned long catersize, unsigned long caterpillar ) {
  int i, segs=0;
  enum seg_state state = OUT;
  for( i = 0; i < catersize; i++ ) {
    switch( ((caterpillar>>i) % 2) | state ) {
    case 1:
      state = IN;
      segs++;
      break;
    case IN:
      state = OUT;
      break;
    }
  }
  return segs;
}

void printcaterpillar( unsigned long catersize, unsigned long caterpillar ) {
  int i;
  char *dispchars = "_#";
  //printf( "Cat: %lu\n", (caterpillar>>i) % );
  for( i = 0; i < catersize; i++ ) {
    printf( "%c", dispchars[(caterpillar>>i) % 2] );
  }
}

int maxsegments(unsigned long catersize) {
  unsigned long caterpillar = 0;
  int i, nseg, max=0;
  for( i = 0; i<catersize; i++ ) {
    addpiece( i, catersize, &caterpillar );
    nseg = countsegments( catersize, caterpillar );
    if( nseg > max ) {
      max = nseg;
    }
    //printcaterpillar( catersize, caterpillar );
    //printf( "  %d (%d)\n", nseg, max );
  }
  return max;
}

void main() {
  unsigned long numsegs = 0, i=0;
  long double avg = 0;
  srandom( time(NULL) );
  for( i = 1; 1; i++ ) {
    numsegs += maxsegments( 40 );
    if( i%100000 == 0 ) {
      avg = ((long double)numsegs) / ((long double)i); 
      printf( "%Lf = %lu/%lu\n", avg, numsegs, i );
    }
  } 
}

/*
2392031239/258900000

*/

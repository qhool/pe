#ifndef __PETOOLS_H
#define __PETOOLS_H

#define NONE 0
#define NEGATIVE 1
#define POSITIVE 2
#define ZERO 64
#define ALL 15
#define Y_NEGATIVE 1
#define Y_POSITIVE 2
#define X_NEGATIVE 4
#define X_POSITIVE 8

typedef unsigned int crossing;
typedef enum { FALSE, TRUE } bool;

crossing y_crossing( int x1, int y1, int x2, int y2 );
crossing crossings( int x[3], int y[3] );
bool includes_origin( int x[3], int y[3] );

char *fmt_triangle( int x[3], int y[3] );

#endif

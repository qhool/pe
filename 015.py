#!/usr/bin/env python

route_counts = {}

def num_routes(w,h):
    
    if w == h == 1:
        return 2
    elif w == 0 or h == 0:
        return 1
    else:
        rect = frozenset([w,h])
        if route_counts.has_key( rect ):
            return route_counts[rect]
        else:
            rc = num_routes( w - 1, h ) + num_routes( w, h - 1 )
            route_counts[rect] = rc
            return rc

print num_routes(20,20)

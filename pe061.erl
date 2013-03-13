-module(pe061).
-export([start/0]).

start() ->
    io:format("sum of cycle is ~w~n",
              [lists:sum(pe:xtagonal_chain(8))]).

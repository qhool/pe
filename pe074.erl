-module(pe074).
-export([start/0]).

chains(Len,Max) ->
    io:format("There are ~w digit factorial chains of length ~w below ~w.~n",
              [pe:digit_factorial_chains_of_length(Len,1,Max-1),Len,Max]).

start() ->
    chains(60,1000000).

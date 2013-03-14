-module(pe074).
-export([wire/2,
         multiples_below/2,
         wires_below/2,
         every_wire_below/1,
         all_wires_below/2,
         unique_wires_count/1,
         start/0]).

wire(M,N) ->
    lists:sum(tuple_to_list(pe:pythag(M,N))).

multiples_below(N,Max) ->
    lists:reverse(multiples_below(N,1,Max,[])).
multiples_below(N,P,Max,Mults) when N*P > Max ->
    Mults;
multiples_below(N,P,Max,Mults) ->
    multiples_below(N,P+1,Max,[N*P|Mults]).

every_wire_below(Max) ->
    lists:merge(
      lists:map( fun (N) -> all_wires_below(N,Max) end,
                 lists:seq(1,Max) )
     ).

all_wires_below(M,Max) ->
    if (M rem 1000) =:= 0 -> io:format( "M: ~w~n",[M] );
       true -> true
    end,
    lists:merge(
      lists:map(fun (W) -> multiples_below(W,Max) end,
                wires_below(M,Max))
     ).

wires_below(M,Max) ->
    lists:usort(wires_below(M,M+1,Max,[])).

wires_below_coprime(M,N,Max,Wires) ->
    Wire = wire(M,N),
    if Wire > Max -> Wires;
       Wire =< Max ->
            %io:format("M,N = ~w,~w ~n",[M,N]),
            wires_below(M,N+1,Max,[Wire|Wires])
    end.
            
wires_below(M,N,Max,Wires) ->
    Gcd = pe:gcd(M,N),
    if Gcd =:= 1 -> wires_below_coprime(M,N,Max,Wires);
       Gcd =/= 1 -> wires_below(M,N+1,Max,Wires)
    end.
            
unique_wires_count(Max) ->
    length(pe:single_items(every_wire_below(Max))).

start() ->
    io:format( "Count: ~w~n", [ unique_wires_count(1500000) ] ).

-module(pe).
-export([maptake/3,
         first_found/2,
         one_by_one/1,
         xtagonal/2,
         xtagonals/3,
         xtagonals_in/3,
         xtagonals_after/2,
         xtagonal_chain/1
         ]).

maptake(F,Pred,Lis) ->
    lists:reverse(maptake(F,Pred,Lis,[])).

maptake(_,_,[],_) ->
    [];
maptake(F,Pred,[H|Tail],OutList) ->
    V = F(H),
    P = Pred(V),
    if P -> maptake(F,Pred,Tail,[V|OutList]);
       true -> OutList
    end.

first_found(_,[]) ->
    throw(undefined);
first_found(F,[X|Xs]) ->
    try F(X) of
        R -> R
    catch
        throw:_ -> 
            first_found(F,Xs)
    end.

one_by_one(L) ->
    Len = length(L),
    lists:map( fun (N) -> {lists:nth(N,L),
                           lists:sublist(L,N-1)++
                               lists:sublist(L,N+1,Len)} end,
               lists:seq(1,Len) ).                         
                               

xtagonal(3,N) ->
    N*(N+1) div 2;
xtagonal(X,N) when X > 3 ->
    N*(N*(X-2)+(4-X)) div 2.

xtagonals(X,N1,N2) ->
    xtagonals(X,N1,N2,[]).

xtagonals(X,N,N,L) ->
    [xtagonal(X,N)|L];
xtagonals(_,N1,N2,_) when N1 > N2 ->
    [];
xtagonals(X,N1,N2,L) ->
    xtagonals(X,N1,N2-1,[xtagonal(X,N2)|L]).

xtagonals_in(X,Min,Max) ->
    lists:dropwhile
      ( fun (N) -> N < Min end,
        maptake(fun (N) -> xtagonal(X,N) end,
                fun (Xt) -> Xt =< Max end,
                lists:seq(1,Max))).

xtagonals_after(X,N) ->
    D = N rem 100,
    if D < 10 -> [];
       D >= 10 -> xtagonals_in(X,D*100,D*100+99)
    end.

xtagonal_chain(Max) ->
    first_found
        ( fun (N) ->
                  xtagonal_chain(lists:seq(3,Max-1),[N]) end,
          xtagonals_in(Max,1000,9999) ).

xtagonal_chain([],[]) ->
    throw(undefined);
xtagonal_chain([],Chain) ->
    N1 = hd(Chain),
    N2 = lists:last(Chain),
    if N1 rem 100 == N2 div 100 -> Chain;
       true -> throw(undefined)
    end;
xtagonal_chain(Xs,Chain) ->
    %io:format("chain/2: ~w   ~w~n",[Xs,Chain]),
    first_found
        ( fun ({X,R}) -> xtagonal_chain(X,R,Chain) end,
          one_by_one(Xs) ).
                  
xtagonal_chain(X,Xs,Chain) ->
    %io:format("chain/3: 
    first_found
      ( fun (N) -> xtagonal_chain(Xs,[N|Chain]) end,
        xtagonals_after(X,hd(Chain)) ).
                


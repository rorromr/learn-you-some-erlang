-module(test).
-export([
  even/1,
  get_city_by_weather/1,
  hello/0,
  greet/2,
  head/1,
  to_isodate/1,
  right_age/1,
  wrong_age/1,
  right_age_if/1,
  help_me/1,
  insert/2,
  nice_temperature/1,
  fac/1,
  len/1,
  duplicate/2,
  zip/2,
  zip_tail/2,
  map/2,
  decr/1,
  incr/1,
  prepare_alarm/1,
  filter/2,
  fold/3,
  reverse/1
]).

% Get even numers
even(L) ->
  [2*N || N <- L].

% Pattern matching examples
greet(male, Name) ->
  io:format("Hello, Mr ~s~n",[Name]);
greet(female, Name) ->
  io:format("Hello, Ms ~s~n",[Name]);
greet(_, Name) ->
  io:format("Hello, ~s~n",[Name]).

% Get city searching using weather type
get_city_by_weather(WeatherType) ->
  Weather = [{toronto, rain}, {montreal, storms}, {london, fog}, {paris, sun}, {boston, fog}, {vancouver, snow}],
  [X || {X,Y} <- Weather, Y ==  WeatherType].

% Hola
hello() ->
  io:format("Hola ~n").

% Funtions
head([H|_]) -> H.

% Separace functions clauses with ;
% Functions ends with .
to_isodate({Date = {Y,M,D}, Time = {H,Min,S}}) ->
  io:format("Tuple ~p and ~p: ~p~p~pT~p~p~p",[Date, Time,Y,M,D,H,Min,S]);
to_isodate(_) ->
  io:format("Error").

% and or always evaluate both sides
% andalso orelse short circuit
% guards , acts like andalso    ; acts like orelse

right_age(Age) when Age >= 24, Age =< 30 -> true;
right_age(_) -> false.

wrong_age(Age) when Age < 24; Age > 30 -> true;
wrong_age(_) -> false.

right_age_if(Age) ->
  if Age >= 24 andalso Age =< 30 ->
    true;
  true ->
    false
  end.

help_me(Animal) ->
  Talk =
    if
      Animal == cat -> "meow";
      Animal == cow -> "muuu";
      Animal == dog -> "woowoow";
      Animal == wolf -> "ahuuuu";
    true ->
      "asdasd"
    end,
  {Animal, "Says " ++ Talk ++ "!"} .


insert(X,[]) ->
  [X];
insert(X,Set) ->
  case lists:member(X,Set) of
    true ->
      Set;
    false ->
      [X | Set]
  end.


nice_temperature(Temperature) ->
  case Temperature of
    {celsius, N} when N >= 20 andalso N =< 45 ->
      true;
    {kelvin, N} when N >= 293 andalso N =< 318 ->
      true;
    {fahrenheit, N} when N >= 68 andalso N =< 113 ->
      true;
    _ ->
      false
  end.

fac(0) -> 1;
fac(N) when N > 0 -> N*fac(N-1).

% Tail recursive
len(L) -> len(L,0).
len([], Acc) -> Acc;
len([_|T], Acc) -> len(T,Acc+1).

duplicate(N, Term) -> duplicate_tail(N,Term,[]).
duplicate_tail(0,_,L) -> L;
duplicate_tail(N,Term,L) -> duplicate_tail(N-1,Term,[Term | L]).

zip([],[]) -> [];
zip([X|Rx],[Y|Ry]) -> [{X,Y}|zip(Rx,Ry)].

zip_tail(X,Y) -> zip_tail(X,Y,[]).
zip_tail([],[],Zip) -> Zip;
zip_tail([X|Rx],[Y|Ry],Zip) -> zip_tail(Rx,Ry,[{X,Y}|Zip]).

% High order functions
map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F,T)].

incr_internal(X) -> X + 1.
decr_internal(X) -> X - 1.

incr(X) -> map(fun(A) -> A + 1  end, X).
decr(X) -> map(fun(A) -> A - 1  end, X).

% "named" anonymous funtions

% This funtion will return Loop function that implement loop
prepare_alarm(Room) ->
  io:format("Alarm set in ~s.~n",[Room]),
  fun Loop() ->
     io:format("Alarm tripped in ~s! Call Batman!~n",[Room]),
     timer:sleep(500),
     Loop()
  end.
% AlarmReady = prepare_alarm("bathroom").
% AlarmReady().

% Apply a filter (Pred predicate) to a list
filter(Pred, L) -> lists:reverse(filter(Pred, L, [])).

filter(_, [], Acc) -> Acc;
filter(Pred, [H|T], Acc) ->
  case Pred(H) of
    true -> filter(Pred, T, [H|Acc]);
    false -> filter(Pred, T, Acc)
  end.


% Fold implementation, output it's single variable (Function to apply to element, Start value, List)
fold(_, Start, []) -> Start;
fold(F, Start, [H|T]) -> fold(F, F(H, Start), T).

% Test with complete sum
% test:fold(fun (A,B) when A > B -> A; (A,B) when A =< B -> B end, H, T).
% test:fold(fun (A,B) when A > B -> A; (_,B) -> B end, H, T).
% Get min
% test:fold(fun (A,B) when A < B -> A; (_,B) -> B end, H, T).
% Get complete sum
% test:fold(fun (A,B) -> A + B end, 0, [H|T]).

% Rerverse implementation with fold
% Function to apply it's an add at top of the list resulting in reverse
reverse(L) ->
  fold(fun(X,Acc) -> [X|Acc] end, [], L).

% reverse([1,2,3]) = fold(fun (X,Acc) -> [X|Acc] end, []               , [1,2,3])
%                  = fold(fun (X,Acc) -> [X|Acc] end, [1|[]]   =[1]    , [2,3])
%                  = fold(fun (X,Acc) -> [X|Acc] end, [2|1]    =[2,1]  , [3])
%                  = fold(fun (X,Acc) -> [X|Acc] end, [3|[2,1]]=[3,2,1], [])
%                  = [3,2,1]


% Map implementation with fold
map2(F,L) ->
  reverse(fold(fun(X, Acc) -> [F(X)|Acc] end, [], L)).

% Filter implementation with fold
filter2(Pred, L) ->
  F = fun(X, Acc) ->
    case Pred(X) of
      true -> [X|Acc];
      false -> Acc
    end
  end,
  reverse(fold(F,[],L)).






% Compile commands
% cd(".").
% ls().
% pwd().
% c(module_name).
% module_name:func() 



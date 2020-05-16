-module(test).
-compile(export_all).

-record(robot, 
  { name,
    type=industrial,
    hobbies,
    details=[]  
  }).

first_robot() ->
  #robot{name="Mechatron",type=handmade,details=["Moved by a samll man inside"]}.

robot_factory(#robot{name=Name,type=industrial}) ->
  io:format("~p Instrial robot!~n",[Name]);
robot_factory(#robot{name=Name}) ->
  io:format("~p it's not allowed~n",[Name]).

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


throws(F) ->
  try F() of
    _ -> ok
  catch
    Throw -> {throw, caught, Throw}
  end.

talk() -> "blah blah".

sword(1) -> throw(slice);
sword(2) -> erlang:error(cut_arm);
sword(3) -> exit(cut_leg);
sword(4) -> throw(punch);
sword(5) -> exit(cross_bridge).

black_knight(Attack) when is_function(Attack, 0) ->
  try Attack() of
    _ -> "None shall pass"
  catch
    throw:slice -> "it is but a scratch";
    error:cut_arm -> "its had worse";
    exit:cut_leg -> "come on you pansy";
    _:_ -> "Just a flesh wound"
  end.

% Reverse polish notation

rpn(L) when is_list(L) ->
  % Iterate over all values separated by space, apply fun rpn/2 with (Element, Acc), Acc starts at []
  [Res] = lists:foldl(fun rpn/2, [], string:tokens(L," ")),
  Res.

% Numeric casts
read(N) ->
  % Check for float
  case string:to_float(N) of
    % Error during cast to float, try integer
    {error,no_float} -> list_to_integer(N);
    {F,_} -> F
  end.

% If +, operate with sum for first 2 elements and save result at stack
rpn("+", [N1,N2|S]) -> [N2+N1|S];
% If -, operate with susbtract for first 2 elements and save result at stack
rpn("-", [N1,N2|S]) -> [N2-N1|S];
% Then it's a number, cast and add to the stack as number
rpn(X, Stack) -> [read(X)|Stack].





% Compile commands
% cd(".").
% ls().
% pwd().
% c(module_name).
% module_name:func() 



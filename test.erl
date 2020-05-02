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
  nice_temperature/1
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



% Compile commands
% cd(".").
% ls().
% pwd().
% c(module_name).
% module_name:func() 



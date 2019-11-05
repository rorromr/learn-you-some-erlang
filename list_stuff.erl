-module(list_stuff).
-export([
  even/1,
  get_city_by_weather/1,
  hello/0
]).

% Get even numers
even(L) ->
  [2*N || N <- L].


% Get city searching using weather type
get_city_by_weather(WeatherType) ->
  Weather = [{toronto, rain}, {montreal, storms}, {london, fog}, {paris, sun}, {boston, fog}, {vancouver, snow}],
  [X || {X,WeatherType} <- Weather].

% Hola
hello() ->
  io:format("Hola ~n").
 
% Compile commands
% cd().
% ls().
% pwd().
% c(module_name).
% module_name:func() 



-module(kitchen).
-compile(export_all).

fridge(FoodList) ->
    receive
        {From, {store, Food}} ->
            From ! {self(), ok},
            % Add element to list and call again
            fridge([Food | FoodList]);
        {From, {take, Food}} ->
            case lists:member(Food, FoodList) of
                true ->
                    From ! {self(), {ok,Food}},
                    % Delete from list
                    fridge(lists:delete(Food,FoodList));
                false ->
                    From ! {self(), not_found},
                    fridge(FoodList)
            end;
        {From, get_all} ->
            From ! {self(), FoodList},
            fridge(FoodList);
        terminate ->
            ok
    end.

% c(kitchen).
% Pid = spawn(kitchen,fridge,[[cocacola]]).
% Pid ! {self(), {store, manjar}}.
% flush().
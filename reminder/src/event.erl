-module(event).
-compile(export_all).
% State record
-record(
    state, {server, name="", to_go=[0]}
).

start(EventName, DeteTime) ->
    spawn(?MODULE, init, [self(),EventName,DeteTime]).

start_link(EventName, DeteTime) ->
    spawn_link(?MODULE, init, [self(),EventName,DeteTime]).


init(Server, EventName, DeteTime) ->
    loop(#state{server=Server, name=EventName, to_go=time_to_go(DeteTime)}).

cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
        {Ref, ok} ->
            erlang:demonitor(Ref,[flush]),
            io:format("Timer cancelled!~n"),
            ok;
        {'DOWN', Ref, process, Pid, _Reason} ->
            io:format("Timer it's already dead~n"),
            ok
    end.

normalize(N) ->
    Limit = 49*24*60*60,
    [N rem Limit | lists:duplicate(N div Limit, Limit)].

time_to_go(TimeOut={{_,_,_},{_,_,_}}) ->
    Now = calendar:local_time(),
    ToGo = calendar:datetime_to_gregorian_seconds(TimeOut) -
        calendar:datetime_to_gregorian_seconds(Now),
    Secs = 
        if
            ToGo > 0 ->
                ToGo;
            ToGo =< 0 ->
                0
        end,
    normalize(Secs).

loop(S = #state{server=Server, to_go=[T|Next]}) ->
    receive
        % Cancel message
        {Server, Ref, cancel} ->
            io:format("Cancel received!~n"),
            Server ! {Ref, ok}
    % Delay to send message back to server
    after T*1000 ->
        if
            Next =:= [] ->
                io:format("Trigger message!~n"),
                Server ! {done, S#state.name};
            Next =/= [] ->
                loop(S#state{to_go=Next})
        end
    end.

% Testing from shell
% c(event).
% rr(event,state).
% Pid = spawn(event,loop,[#state{server=self(),name="test",to_go=5}]).
% ReplyRef = make_ref().      
% Pid ! {self(),ReplyRef,cancel}.
% flush().
% With new interface
% event:start("Event",{{2020,6,14},{1,30,0}}).
 
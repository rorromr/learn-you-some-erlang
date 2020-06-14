-module(event).
-compile(export_all).
% State record
-record(
    state, {server, name="", to_go=0}
).

loop(S = #state{server=Server}) ->
    receive
        % Cancel message
        {Server, Ref, cancel} ->
            io:format("Cancel received!~n"),
            Server ! {Ref, ok}
    % Delay to send message back to server
    after S#state.to_go*1000 ->
        io:format("Trigger message!~n"),
        Server ! {done, S#state.name}
    end.

% Testing from shell
% c(event).
% rr(event,state).
% Pid = spawn(event,loop,[#state{server=self(),name="test",to_go=500}]).
% ReplyRef = make_ref().      
% Pid ! {self(),ReplyRef,cancel}.
% flush().
 
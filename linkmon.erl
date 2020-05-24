-module(linkmon).
-compile(export_all).

myproc() ->
    timer:sleep(5000),
    exit(reason).

start_critic() ->
    spawn(?MODULE, critic, []).

judge(Band, Album) ->
    io:format("Sending ~p~n",[{Band,Album}]),
    case whereis(critic) of
        undefined ->
            io:format("Process critic not running!~n"),
            {error,critic_not_running};
        Pid ->
            Pid ! {self(), {Band, Album}},
            receive
                {Pid, Criticism} -> Criticism
            after 2000 ->
                timeout
            end
    end.


critic() ->
    receive
        {From, {"Rage Aganist the Turing Machine", "Unit Testify"}} ->
            From ! {self(), "They are great!"};
        {From, {_Band, _Album}} ->
            From ! {self(), "They are terrible!"}
    end,
    critic().

start_critic_restarter() ->
    spawn(?MODULE, restarter, []).

restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic, []),
    register(critic,Pid),
    io:format("spawn critic process with pid ~p~n",[Pid]),
    receive
        % Normal exit
        {'EXIT', Pid, normal} ->
            ok;
        % Manual shutdown
        {'EXIT', Pid, shutdown} ->
            ok;
        % Unknown exit, restart
        {'EXIT', Pid, _} ->
            io:format("Restarting!~n"),
            restarter()
    end.


% Pid = spawn_link(linkmon,myproc,[]).
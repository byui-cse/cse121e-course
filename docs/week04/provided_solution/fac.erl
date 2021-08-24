-module(fac).

-export([start/0,rpc/2,loop/2]).

%%
%% Spawns a process providing factorial calculations for integers.
%%
%% Parameters - None
%% Value - the Process ID of the spawned factorial process
%% Complexity - O(1)

start() ->
	spawn(?MODULE,loop,[0,1]).%modified from pattern in reading



%%
%% This is the client for the factorial process. The current process blocks until
%% a response is received from the specified process.
%%
%% Parameters - 1) a Process ID for the factorial process to be used
%%				2) an integer for which the factorial calculation is desired
%% Value - None
%% Complexity - O(1)
rpc(Pid, N) -> %didn't want to write a handler each time rpc was called in the erl REPL
	Pid ! {self(),N},%send the integer to the process
	receive
		{ok,F} ->
			io:format("~p! is ~p~n",[N,F]);
		{fail,_}->
			io:format("Can not calculate factorial of ~p~n",[N])
	end.

loop(Last,Last_factorial)->
	receive
		{Pid,N} when is_integer(N) == false; N < 0 ->
			Pid ! {fail,-1},
			loop(0,1);
		{Pid,N} when N > Last ->
			Prod = fact(N,Last,Last_factorial),
			Pid ! {ok,Prod},
			loop(N,Prod);
		{Pid,N} ->
			Prod = fact(N,0,1),
			Pid ! {ok,Prod},
			loop(N,Prod)
	end.



%%
%% Calculates factorial when a partial value is already known.
%%
%% Parameters - 1)an Integer for which factorial is desired
%%              2)a number for which factorial has already been calculated
%%				3)an accumulator that is parameter 2 factorial
%% Value - factorial of the first parameter
%% Complexity - O(n)
%%
fact(I,0,_)->
	fact(I,1,1);
fact(I,C,Accum) when C < I ->
	fact(I,C+1,(C+1)*Accum);
fact(_,_,Accum)->Accum.






	

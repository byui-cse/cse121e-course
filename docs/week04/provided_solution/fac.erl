%% @author Lee Barney
%% @copyright 2022 Lee Barney licensed under the <a>
%%        rel="license"
%%        href="http://creativecommons.org/licenses/by/4.0/"
%%        target="_blank">
%%        Creative Commons Attribution 4.0 International License</a>
%%
%%
%% These solutions are not intended to be ideal solutions. Instead,
%% they are a solution that you can compare against yours to see
%% other options and to come up with even better solutions.
%%

-module(fac).
-export([start/0,rpc/2,run/0]).

%%
%% Spawns a process providing factorial calculations for integers.
%%
%% Parameters - None
%% Value - the Process ID of the spawned factorial process
%% Complexity - O(1)

start() ->
	spawn(?MODULE,run,[]).%modified from pattern in reading



%%
%% This is the client for the factorial process. The calling process blocks until
%% a response is received from the factorial process.
%%
%% Parameters - 1) a Process ID to which the factorial value is to be sent
%%				2) an Integer for which the factorial calculation is desired
%% Value - None
%% Complexity - O(1)
rpc(Pid, N) -> %didn't want to write a handler each time rpc was called in the erl REPL
	Pid ! {self(),N},%send the integer to the factorial process
	receive
		{ok,F} ->%if the factorial process returns valid value
			io:format("~p! is ~p~n",[N,F]);
		{fail,Reason}->%if the factorial process returned an invalid request report
			io:format("Can not calculate factorial of ~p. ~p~n",[N,Reason])
	end.

run()->
	receive
		{Pid,N} when is_integer(N) == false ->
			Pid ! {fail,non_integer};
		{Pid,N} when N < 0 ->
			Pid ! {fail,negative_number};
		{Pid,N} when is_integer(N) == true->
			Prod = fact(N),
			Pid ! {ok,Prod};
		{Pid,_other}->
			Pid ! {fail,unknown_request}
	end,
	run().



%%
%% Calculates factorial for positive integers.
%%
%% Parameter - a positive Integer for which factorial is desired
%% Value - factorial of the parameter
%% Complexity - O(n)
%%
fact(0)->1;
fact(N)->
	N*fact(N-1).






	

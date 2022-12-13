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

-module(divide).
-export([start/0,rpc/3,run/0]).

%%
%% Spawns a process providing a division behavior for Integers.
%%
%% Parameters - None
%% Value - the Process ID of the spawned factorial process
%% Complexity - O(1)

start() ->
	spawn(?MODULE,run,[]).%from pattern in reading



%%
%% This is the client for the division process. The calling process blocks until
%% a response is received from the division process.
%%
%% Parameters - 1) a Process ID to which the quotient is to be sent
%%				2) an Integer Dividend
%%				3) an Integer Divisor
%% Value - None
%% Complexity - O(1)
rpc(Pid,Dividend,Divisor) -> %didn't want to write a handler each time rpc was called in the erl REPL
	Pid ! {self(),Dividend,Divisor},%send the list to the division process
	receive
		{ok,Q} ->%if the summation process returns valid value
			io:format("The quotient is ~p~n",[Q]);
		{fail,Reason}->%if the factorial process returned an invalid request report
			io:format("Can not calculate the quotient of ~p divided by ~p since ~p~n",[Dividend,Divisor,Reason])
	end.

run()->
	receive
		{Pid,Dividend,_} when is_integer(Dividend) == false-> %can not calculate quotient of non-Integers
			Pid ! {fail,dividend_not_integer};
		{Pid,_,Divisor} when is_integer(Divisor) == false-> %can not calculate quotient of non-Integers
			Pid ! {fail,divisor_not_integer};
		{Pid,Dividend,Divisor} ->%happy path
			Pid ! {ok,Dividend div Divisor};%Complexity - O(1);
		{Pid,_other}->
			Pid ! {fail,unknown_request}
	end,
	run().










	

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

-module(multiply).
-export([start/0,rpc/2,run/0]).

%%
%% Spawns a process providing a product behavior for numbers.
%%
%% Parameters - None
%% Value - the Process ID of the spawned multiply process
%% Complexity - O(1)

start() ->
	spawn(?MODULE,run,[]).%from pattern in reading



%%
%% This is the client for the multiplication process. The calling process blocks until
%% a response is received from the multiplication process.
%%
%% Parameters - 1) a Process ID to which the product is to be sent
%%				2) a list of numbers for which the product is desired
%% Value - None
%% Complexity - O(1)
rpc(Pid, Numbers) -> %didn't want to write a handler each time rpc was called in the erl REPL
	Pid ! {self(),Numbers},%send the list to the multiplication process
	receive
		{ok,Product} ->%if the multiplication process returns valid value
			io:format("The product is ~p~n",[Product]);
		{fail,Reason}->%if the factorial process returned an invalid request report
			io:format("Can not calculate the product of ~p. ~p~n",[Numbers,Reason]);
		{Pid,_other}->
			Pid ! {fail,unknown_request}
	end.

run()->
	receive
		{Pid,[]} ->%can not calculate product of no numbers
			Pid ! {fail,empty_list};
		{Pid,Numbers} ->%use foldl to calculate product of a list of numbers
			Pid ! {ok,lists:foldl(fun(X,Y)->X*Y end,1,Numbers)}%Complexity - O(n)
	end,
	run().










	

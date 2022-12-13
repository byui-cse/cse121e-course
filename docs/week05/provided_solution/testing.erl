-module(testing).
-export([driver/0]).

%%
%% Exercise the different types of functionality of the friends module.
%%
driver()->
	%Start with a set of friends
	Pid1 = friends:start([bob,sue,jose,gunhilda]),
	Pid2 = friends:start([bob,sally,grace,frank]),
	%Print out my friends
	friends:rpc(Pid1,get,fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,get,fun(Response)-> print_response(Response) end),
	%Add a friend
	friends:rpc(Pid1,{add,jorge},fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,{add,jorge},fun(Response)-> print_response(Response) end),
	%Print out my friends
	friends:rpc(Pid1,get,fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,get,fun(Response)-> print_response(Response) end),
	%Remove a friend
	friends:rpc(Pid1,{remove,bob},fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,{remove,bob},fun(Response)-> print_response(Response) end),

	%Add a whole bunch of friends
	[friends:rpc(Pid1,{add,Friend_num},fun(Response)-> print_response(Response) end) || Friend_num <- lists:seq(1,1000)],
	[friends:rpc(Pid2,{add,Friend_num},fun(Response)-> print_response(Response) end) || Friend_num <- lists:seq(1,1000)],
	%Print out my friends
	friends:rpc(Pid1,get,fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,get,fun(Response)-> print_response(Response) end),
	%Remove a whole bunch of friends
	[friends:rpc(Pid1,{remove,Friend_num},fun(Response)-> print_response(Response) end) || Friend_num <- lists:seq(1,1000)],
	[friends:rpc(Pid2,{remove,Friend_num},fun(Response)-> print_response(Response) end) || Friend_num <- lists:seq(1,1000)],
	%Print out my friends
	friends:rpc(Pid1,get,fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,get,fun(Response)-> print_response(Response) end),
	%send junk message
	friends:rpc(Pid1,junk_msg,fun(Response)-> print_response(Response) end),
	friends:rpc(Pid2,junk_msg,fun(Response)-> print_response(Response) end).

%%--------------------
%% Internal Functions
%%--------------------

%This function is here to shorten how much I needed to type to print out all the stuff.
print_response(Response)->
	io:format("Got back ~p~n",[Response]).
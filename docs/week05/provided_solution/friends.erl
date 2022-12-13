-module(friends).
-export([start/1,rpc/3,run/1]).


%%
%% Spawn a process for adding, removing, and finding friends.
%% The parameter is an initial list of friends. It may be an 
%% empty list.
%%

start(Initial_friends_list)->
	spawn(?MODULE, run, [Initial_friends_list]).%The MODULE macro is used instead of hard coding the module name.


%%--------------------------
%% Client functions
%%--------------------------

%%
%% Add, remove, or find a friend.
%%
rpc(Pid,Message,Response_handler)->
	Pid ! {self(),Message},
	receive
         Response ->
             Response_handler(Response)
     end.


%%---------------------------
%% Server function
%%---------------------------

run(Friend_list)->
	receive
		{Pid,{add,Friend}}->
			Pid ! received,
			run([Friend]++Friend_list);
		{Pid,{find,Friend}}->
			Pid ! lists:any(fun(Element)-> Element == Friend end,Friend_list);
		{Pid,{remove,Friend}}->
			Pid ! received,
			run(lists:delete(Friend,Friend_list));
		{Pid,get}->
			Pid ! Friend_list;
		{Pid,_other}->
			Pid ! {fail, unrecoginized_message}
	end,
	run(Friend_list).


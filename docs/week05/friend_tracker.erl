-module(friend_tracker).
-export([start/1,rpc/2,run/1]).


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
rpc(Pid,Message)->
	Pid ! {self(),Message},
	receive
         Response ->
             Response
     end.


%%---------------------------
%% Server function
%%---------------------------

run(Friend_list)->
	Updated_list = receive
						{Pid,{add,Friends}} when is_list(Friends)->
							Pid ! received,
							Friends++Friend_list;
						{Pid,{add,Friend}}->
							Pid ! received,
							[Friend]++Friend_list;
						{Pid,{has_friends,Friends}} when is_list(Friends)->
							Pid ! length(Friend_list -- Friends) == length(Friend_list) - length(Friends),
							Friend_list;
						{Pid,{has_friend,Friend}}->
							Pid ! lists:any(fun(Element)-> Element == Friend end,Friend_list),
							Friend_list;
						{Pid,{remove,Friends}} when is_list(Friends)->
							Pid ! received,
							Friend_list -- Friends;
						{Pid,{remove,Friend}}->
							Pid ! received,
							Friend_list -- [Friend];
						{Pid,get}->
							Pid ! Friend_list,
							Friend_list;
						{Pid,_other}->
							Pid ! {fail, unrecognized_message},
							Friend_list
					end,
	run(Updated_list).

-ifdef(EUNIT).
%%
%% Unit tests go here. 
%%

-include_lib("eunit/include/eunit.hrl").


add_friend_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_adder,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_adder)
	end,
	%factorializer tests start here
	[ ?_assertEqual(received,rpc(test_adder,{add,bob})),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(received,rpc(test_adder,{add,1})),
	  ?_assertEqual(received,rpc(test_adder,{add,#{name=>suzannah,age=>23}}))
	]
}.

add_friends_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_adder,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_adder)
	end,
	%factorializer tests start here
	[ ?_assertEqual(received,rpc(test_adder,{add,[bob,alice,joe]})),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(received,rpc(test_adder,{add,[]})),
	  ?_assertEqual(received,rpc(test_adder,{add,[#{name=>suzannah,age=>23},#{name=>gunhild,age=>20}]}))
	]
}.

has_friend_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_finder,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_finder)
	end,
	%factorializer tests start here
	[ ?_assert(rpc(test_finder,{has_friend,sue})),%happy path
	  %nasty thoughts start here
	  ?_assertNot(rpc(test_finder,{has_friend,bob})),
	  ?_assertNot(rpc(test_finder,{has_friend,[#{name=>suzannah,age=>23},#{name=>gunhild,age=>20}]}))
	]
}.

has_friends_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_finder,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_finder)
	end,
	%factorializer tests start here
	[ ?_assert(rpc(test_finder,{has_friends,[sue,fred]})),%happy path
	  %nasty thoughts start here
	  ?_assert(rpc(test_finder,{has_friends,[]})),
	  ?_assertNot(rpc(test_finder,{has_friends,[bob]})),
	  ?_assertNot(rpc(test_finder,{has_friends,[#{name=>suzannah,age=>23},#{name=>gunhild,age=>20}]}))
	]
}.



remove_friend_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_remover,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_remover)
	end,
	%factorializer tests start here
	[ ?_assertEqual(received,rpc(test_remover,{remove,fred})),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(received,rpc(test_remover,{remove,bob})),
	  ?_assertEqual(received,rpc(test_remover,{remove,[#{name=>suzannah,age=>23},#{name=>gunhild,age=>20}]}))
	]
}.

remove_friends_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_remover,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_remover)
	end,
	%factorializer tests start here
	[ ?_assertEqual(received,rpc(test_remover,{remove,[sue,fred]})),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(received,rpc(test_remover,{remove,[bob]})),
	  ?_assertEqual(received,rpc(test_remover,{remove,[#{name=>suzannah,age=>23},#{name=>gunhild,age=>20}]}))
	]
}.

get_friends_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_remover,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_remover)
	end,
	%factorializer tests start here
	[ ?_assertEqual([sue,grace,fred],rpc(test_remover,get))%happy path
	]
}.

bad_message_test_() ->
	{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,run,[[sue,grace,fred]]),	
			register(test_bad_message,Pid)
		end,
	fun(_)->%runs after all of the tests
		unregister(test_bad_message)
	end,
	%factorializer tests start here
	[ ?_assertMatch({fail, unrecognized_message},rpc(test_bad_message,what)),%happy path
	  ?_assertMatch({fail, unrecognized_message},rpc(test_bad_message,nil)),
	  ?_assertMatch({fail, unrecognized_message},rpc(test_bad_message,[])),
	  ?_assertMatch({fail, unrecognized_message},rpc(test_bad_message,{}))
	]
}.



-endif.
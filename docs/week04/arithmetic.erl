-module(arithmetic).
-export([start_factorializer/0,start_adder/0,start_subtracter/0,start_multiplier/0,start_divider/0,
		 factorializer/0,adder/0,subtracter/0,multiplier/0,divider/0,
		 factorial_of/2,add/3,subtract/3]).


%% Spawning functions
start_factorializer() ->
	io:format("in factorializer"),
	spawn(?MODULE,factorializer,[]).
start_adder() ->
	io:format("in adder"),
	spawn(?MODULE,adder,[]).
start_subtracter() ->
	io:format("in subtracter"),
	spawn(?MODULE,subtracter,[]).
start_multiplier() ->
	io:format("in multiplier"),
	spawn(?MODULE,multiplier,[]).
start_divider() ->
	io:format("in divider"),
	spawn(?MODULE,divider,[]).

%% Clients
factorial_of(Factorializer_pid, Number) ->
	Factorializer_pid ! {self(), Number},
	receive
		Response ->
			Response % the response will print out in the REPL
	end.

add(Adder_pid, Augend, Addend) ->
	Adder_pid ! {self(), Augend, Addend},
	receive
		Response ->
			Response % the response will print out in the REPL
	end.

subtract(Subtracter_pid, Minuend, Subtrahend) ->
	Subtracter_pid ! {self(), Minuend, Subtrahend},
	receive
		Response ->
			Response % the response will print out in the REPL
	end.

multiply(Multiplier_pid, Multiplicand, Multiplier) ->
	Multiplier_pid ! {self(), Multiplicand, Multiplier},
	receive
		Response ->
			Response % the response will print out in the REPL
	end.

divide(Dividerer_pid, Dividend, Divisor) ->
	Dividerer_pid ! {self(), Dividend, Divisor},
	receive
		Response ->
			Response % the response will print out in the REPL
	end.

%% Process functions
factorializer()->
	receive
		{Requesting_pid, Data} when is_integer(Data) == false ->
			Requesting_pid ! {fail, Data, is_not_integer};
		{Requesting_pid, Integer} when Integer < 0 ->
			Requesting_pid ! {fail, Integer, is_negative};
		{Requesting_pid, Number} ->
			Requesting_pid ! lists:foldl(fun(X,Accum) -> X*Accum end, 1, lists:seq(1,Number))
	end,
	factorializer().

adder() ->
	receive
		{Requesting_pid,Augend, _Addend} when (is_number(Augend) == false)  ->
			Requesting_pid ! {fail,Augend, is_not_number};
		{Requesting_pid,_Augend, Addend} when (is_number(Addend) == false)  ->
			Requesting_pid ! {fail,Addend, is_not_number};
		{Requesting_pid,Augend, Addend} ->
			Requesting_pid ! Augend+Addend
	end,
	adder().

subtracter() ->
	receive
		{Requesting_pid, Minuend, _Subtrahend} when (is_number(Minuend) == false)  ->
			Requesting_pid ! {fail, Minuend, is_not_number};
		{Requesting_pid, _Minuend, Subtrahend} when (is_number(Subtrahend) == false)  ->
			Requesting_pid ! {fail, Subtrahend, is_not_number};
		{Requesting_pid, Minuend, Subtrahend} ->
			Requesting_pid ! Minuend-Subtrahend
	end,
	subtracter().

multiplier() ->
	receive
		{Requesting_pid, Multiplicand, _Multiplier} when (is_number(Multiplicand) == false)  ->
			Requesting_pid ! {fail, Multiplicand, is_not_number};
		{Requesting_pid, _Multiplicand, Multiplier} when (is_number(Multiplier) == false)  ->
			Requesting_pid ! {fail, Multiplier, is_not_number};
		{Requesting_pid, Multiplicand, Multiplier} ->
			Requesting_pid ! Multiplicand*Multiplier
	end,
	multiplier().

divider() ->
	receive
		{Requesting_pid, Dividend, _Divisor} when (is_number(Dividend) == false)  ->
			Requesting_pid ! {fail, Dividend, is_not_number};
		{Requesting_pid, _Dividend, Divisor} when (is_number(Divisor) == false)  ->
			Requesting_pid ! {fail, Divisor, is_not_number};
		{Requesting_pid, _Dividend, 0} ->
			Requesting_pid ! {fail, division_by_zero};
		{Requesting_pid, Dividend, Divisor} ->
			Requesting_pid ! Dividend/Divisor
	end, 
	divider().

-ifdef(EUNIT).
%%
%% Unit tests go here. 
%%

-include_lib("eunit/include/eunit.hrl").


factorializer_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,factorializer,[]),	
			register(test_factorializer,Pid)
		end,
	%fun(_)->%runs after all of the tests
		%there is no teardown needed, so this fun doesn't need to be implemented.
	%end,
	%factorializer tests start here
	[ ?_assertEqual(120,factorial_of(test_factorializer,5)),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(1,factorial_of(test_factorializer,0)),
	  ?_assertEqual({fail,-3,is_negative},factorial_of(test_factorializer,-3)),
	  ?_assertEqual({fail,bob,is_not_integer},factorial_of(test_factorializer,bob)),
	  ?_assertEqual({fail,5.0,is_not_integer},factorial_of(test_factorializer,5.0))
	]
}.

adder_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,adder,[]),	
			register(test_adder,Pid)
		end,
	%fun(_)->%runs after all of the tests
		%there is no teardown needed, so this fun doesn't need to be implemented.
	%end,
	%factorializer tests start here
	[ ?_assertEqual(8,add(test_adder,5,3)),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(0,add(test_adder,0,0)),
	  ?_assertEqual(0.0,add(test_adder,0.0,0.0)),
	  ?_assertEqual(0,add(test_adder,-5,5)),
	  ?_assertEqual(1.5,add(test_adder,0.75,0.75)),
	  ?_assertEqual({fail,bob,is_not_number},add(test_adder,bob,3)),
	  ?_assertEqual({fail,sue,is_not_number},add(test_adder,3,sue)),
	  ?_assertEqual({fail,bob,is_not_number},add(test_adder,bob,sue))
	]
}.

subtracter_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,subtracter,[]),	
			register(test_subtracter,Pid)
		end,
	%fun(_)->%runs after all of the tests
		%there is no teardown needed, so this fun doesn't need to be implemented.
	%end,
	%factorializer tests start here
	[ ?_assertEqual(2,subtract(test_subtracter,5,3)),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(0,subtract(test_subtracter,0,0)),
	  ?_assertEqual(0.0,subtract(test_subtracter,0.0,0.0)),
	  ?_assertEqual(-10,subtract(test_subtracter,-5,5)),
	  ?_assertEqual(0.75,subtract(test_subtracter,1.5,0.75)),
	  ?_assertEqual({fail,bob,is_not_number},subtract(test_subtracter,bob,3)),
	  ?_assertEqual({fail,sue,is_not_number},subtract(test_subtracter,3,sue)),
	  ?_assertEqual({fail,bob,is_not_number},subtract(test_subtracter,bob,sue))
	]
}.

multiplier_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,multiplier,[]),	
			register(test_multiplier,Pid)
		end,
	%fun(_)->%runs after all of the tests
		%there is no teardown needed, so this fun doesn't need to be implemented.
	%end,
	%factorializer tests start here
	[ ?_assertEqual(15,multiply(test_multiplier,5,3)),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(0,multiply(test_multiplier,0,0)),
	  ?_assertEqual(0.0,multiply(test_multiplier,0.0,0.0)),
	  ?_assertEqual(-25,multiply(test_multiplier,-5,5)),
	  ?_assertEqual(1.125,multiply(test_multiplier,1.5,0.75)),
	  ?_assertEqual({fail,bob,is_not_number},multiply(test_multiplier,bob,3)),
	  ?_assertEqual({fail,sue,is_not_number},multiply(test_multiplier,3,sue)),
	  ?_assertEqual({fail,bob,is_not_number},multiply(test_multiplier,bob,sue))
	]
}.

divider_test_() ->
{setup,
	fun()->%runs before any of the tests
			Pid = spawn(?MODULE,divider,[]),	
			register(test_divider,Pid)
		end,
	%fun(_)->%runs after all of the tests
		%there is no teardown needed, so this fun doesn't need to be implemented.
	%end,
	%factorializer tests start here
	[ ?_assert((1.6 < divide(test_divider,5,3)) and (divide(test_divider,5,3) < 1.7)),%happy path
	  %nasty thoughts start here
	  ?_assertEqual(-1.0,divide(test_divider,-5,5)),
	  ?_assertEqual(2.0,divide(test_divider,1.5,0.75)),
	  ?_assertEqual({fail,bob,is_not_number},divide(test_divider,bob,3)),
	  ?_assertEqual({fail,sue,is_not_number},divide(test_divider,3,sue)),
	  ?_assertEqual({fail,bob,is_not_number},divide(test_divider,bob,sue))
	]
}.

-endif.
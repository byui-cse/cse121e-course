-module(team_builder).
-export([divide/2,lower_divide/2,remainder/2]).

%% this function has floats as its value
divide(_Dividend,0)-> fail;
divide(Dividend,Divisor)->
	Dividend/Divisor.

%% this function has as its value the greatest integer less than the float that is the result of division
lower_divide(_Dividend,0)-> fail;
lower_divide(Dividend,Divisor)->
	Dividend div Divisor.

%% this function has as its value an integer that is the remainder of doing the division
remainder(_Dividend,0)-> fail;
remainder(Dividend,Divisor) when (is_integer(Dividend) == false) or (is_integer(Divisor) == false) -> fail;
remainder(Dividend,Divisor)->
	Dividend rem Divisor.



-ifdef(EUNIT).
%%
%% Unit tests go here. 
%%

-include_lib("eunit/include/eunit.hrl").

divide_test_() ->
	[?_assertEqual(2.0,divide(10,5)),%happy path
	 %nasty thoughts start here
	 ?_assertEqual(fail,divide(3,0)),
	 ?_assertEqual(0.75,divide(3,4)),
	 ?_assert(3.5714285713 =< divide(1.25,0.35)),%the check can be broken up into two checks instead of using and
	 ?_assert(3.5714285715 >= divide(1.25,0.35)),
	 ?_assert((-0.6666666 >= divide(2,-3)) and (-0.7 =< divide(2,-3))),
	 ?_assert((-0.6666666 >= divide(-2,3)) and (-0.7 =< divide(2,-3))),
	 ?_assert((0.6666666 =< divide(-2,-3)) and (0.7 >= divide(2,-3)))
	].
lower_divide_test_() ->
	[?_assertEqual(2,lower_divide(10,5)),%happy path
	 %nasty thoughts start here
	 ?_assertEqual(fail,lower_divide(10,0)),
	 ?_assertEqual(-2,lower_divide(-10,5)),
	 ?_assertEqual(-2,lower_divide(10,-5)),
	 ?_assertEqual(2,lower_divide(-10,-5)),
	 ?_assertEqual(0,lower_divide(5,10)),	 
	 ?_assertEqual(0,lower_divide(2,3)),
	 ?_assertEqual(0,lower_divide(-2,10)),
	 ?_assertEqual(0,lower_divide(2,-10))
	].

remainder_test_()->
	[?_assertEqual(0,remainder(10,5)),%happy path
	 %nasty thoughts start here
	 ?_assertEqual(fail,remainder(5,0)),
	 ?_assertEqual(fail,remainder(5.0,2.0)),
	 ?_assertEqual(5,remainder(5,10)),
	 ?_assertEqual(-5,remainder(-5,10)),
	 ?_assertEqual(-5,remainder(-5,-10)),
	 ?_assertEqual(0,remainder(0,7))
	].
-endif.
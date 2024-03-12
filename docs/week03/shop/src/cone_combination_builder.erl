-module(cone_combination_builder).
-export([cone_combinations/2, cone_combinations/1, most_popular_combinations/2]).

% TODO: Complete this function so it passes all of its unit tests
cone_combinations(Top_flavors, Bottom_flavors) ->
	to_do.

% TODO: Complete this function so it passes all of its unit tests
cone_combinations(Flavor_list)->
	to_do.

% TODO: Complete this function so it passes all of its unit tests
most_popular_combinations(Count, List)->
	to_do.



-ifdef(EUNIT).
%
% Unit tests go here. 
%

-include_lib("eunit/include/eunit.hrl").

% For this set of tests, the expected results are defined first, 
% then the unit tests are done.
% 
% This takes up less visual space than reusing the lists in each assertion.
	

%The tests start here.
cone_combinations_two_list_test_() ->
	% First set up the necessary lists in order to run the tests.
	
	% The lists from which combinations are built.
	Top_scoop_list = [vanilla,chocolate,cherry_ripple],
	Bottom_scoop_list = [lemon,butterscotch,licorice_riple],
	
	% Top scoop from one list, bottom scoop from the other
	Short_combinations = [  {vanilla,lemon},
							{vanilla,butterscotch},
							{vanilla,licorice_riple},
							{chocolate,lemon},
							{chocolate,butterscotch},
							{chocolate,licorice_riple},
							{cherry_ripple,lemon},
							{cherry_ripple,butterscotch},
							{cherry_ripple,licorice_riple}],

	% This is where the unit tests start
	[?_assertEqual(Short_combinations,cone_combinations(Top_scoop_list,Bottom_scoop_list)), % happy path
	 % Less obvious things we need to test start start here, the edge cases.
	 ?_assertEqual([],cone_combinations(Top_scoop_list,[])),
	 ?_assertEqual([],cone_combinations([],Bottom_scoop_list)),
	 ?_assertEqual([],cone_combinations([],[])),
	 ?_assertEqual([],cone_combinations([],nil)),
	 ?_assertEqual(fail,cone_combinations(nil,[])),
	 ?_assertEqual(fail,cone_combinations(nil,nil))
	].
cone_combinations_one_list_test_() ->
	% Set up the lists from which combinations are built.
	Top_scoop_list = [vanilla,chocolate,cherry_ripple],
	Bottom_scoop_list = [lemon,butterscotch,licorice_riple],
	
	% Create all possible combinations from either list for top and bottom scoops
	All_combinations = [ {vanilla,vanilla},
						 {vanilla,chocolate},
						 {vanilla,cherry_ripple},
						 {vanilla,lemon},
						 {vanilla,butterscotch},
						 {vanilla,licorice_riple},
						 {chocolate,vanilla},
						 {chocolate,chocolate},
						 {chocolate,cherry_ripple},
						 {chocolate,lemon},
						 {chocolate,butterscotch},
						 {chocolate,licorice_riple},
						 {cherry_ripple,vanilla},
						 {cherry_ripple,chocolate},
						 {cherry_ripple,cherry_ripple},
						 {cherry_ripple,lemon},
						 {cherry_ripple,butterscotch},
						 {cherry_ripple,licorice_riple},
						 {lemon,vanilla},
						 {lemon,chocolate},
						 {lemon,cherry_ripple},
						 {lemon,lemon},
						 {lemon,butterscotch},
						 {lemon,licorice_riple},
						 {butterscotch,vanilla},
						 {butterscotch,chocolate},
						 {butterscotch,cherry_ripple},
						 {butterscotch,lemon},
						 {butterscotch,butterscotch},
						 {butterscotch,licorice_riple},
						 {licorice_riple,vanilla},
						 {licorice_riple,chocolate},
						 {licorice_riple,cherry_ripple},
						 {licorice_riple,lemon},
						 {licorice_riple,butterscotch},
						 {licorice_riple,licorice_riple}],
	% Do the actual tests
	[?_assertEqual(All_combinations, cone_combinations(Top_scoop_list++Bottom_scoop_list)),%happy path
	 % Less obvious things we need to test start start here, the edge cases.
	 ?_assertEqual([],cone_combinations([])),
	 ?_assertEqual(fail,cone_combinations(nil))
	].

most_popular_combinations_test_()->
	% Create all possible combinations from either list for top and bottom scoops
	All_combinations = [ {vanilla,vanilla},
						 {vanilla,chocolate},
						 {vanilla,cherry_ripple},
						 {vanilla,lemon},
						 {vanilla,butterscotch},
						 {vanilla,licorice_riple},
						 {chocolate,vanilla},
						 {chocolate,chocolate},
						 {chocolate,cherry_ripple},
						 {chocolate,lemon},
						 {chocolate,butterscotch},
						 {chocolate,licorice_riple},
						 {cherry_ripple,vanilla},
						 {cherry_ripple,chocolate},
						 {cherry_ripple,cherry_ripple},
						 {cherry_ripple,lemon},
						 {cherry_ripple,butterscotch},
						 {cherry_ripple,licorice_riple},
						 {lemon,vanilla},
						 {lemon,chocolate},
						 {lemon,cherry_ripple},
						 {lemon,lemon},
						 {lemon,butterscotch},
						 {lemon,licorice_riple},
						 {butterscotch,vanilla},
						 {butterscotch,chocolate},
						 {butterscotch,cherry_ripple},
						 {butterscotch,lemon},
						 {butterscotch,butterscotch},
						 {butterscotch,licorice_riple},
						 {licorice_riple,vanilla},
						 {licorice_riple,chocolate},
						 {licorice_riple,cherry_ripple},
						 {licorice_riple,lemon},
						 {licorice_riple,butterscotch},
						 {licorice_riple,licorice_riple}],
	% This list consists of 2-tuples of the form {integer(), {atom(), atom()}}.
	% The integer in the tuple represents the number of purchases of the cone pair.
	% The cone-scoop-pair is represented by the 2-tuple, {atom(), atom()} where each atom is a flavor.
	Sorted_combinations_with_purchases = lists:sort(lists:zip([rand:uniform(100000)||_<-lists:seq(0, length(All_combinations)-1)], All_combinations)),

	{H,_Remainder} = lists:split(10, Sorted_combinations_with_purchases),

	% The actual tests start here
	[?_assertEqual(H, most_popular_combinations(10, Sorted_combinations_with_purchases)),% Happy path
	 % Less obvious things we need to test start start here. Let's test the edge cases.
	 ?_assertEqual(fail, most_popular_combinations(5, [])),
	 ?_assertEqual(fail, most_popular_combinations(5, [{86656, {vanilla,vanilla}}])),
	 ?_assertEqual(fail, most_popular_combinations(5, [{86656, {vanilla,vanilla}}, {58876, {vanilla,chocolate}}])),
	 ?_assertEqual(fail, most_popular_combinations(5, [{86656, {vanilla,vanilla}},
													  {58876, {vanilla,chocolate}},
													  {23473, {vanilla,cherry_ripple}}])),
	 ?_assertEqual(fail, most_popular_combinations(5,[{86656, {vanilla,vanilla}},
													  {58876, {vanilla,chocolate}},
													  {23473, {vanilla,cherry_ripple}},
													  {62009, {vanilla,lemon}}])),
	 ?_assertEqual([], most_popular_combinations(0, Sorted_combinations_with_purchases)),
	 ?_assertEqual(fail, most_popular_combinations(-3, Sorted_combinations_with_purchases))
	].
-endif.
-module(tasks).
-export([start/0]).

%% used to execute the simulated situation
start()->
	io:format("chocolate first options, partial:~n~p~n~n",[fixed_first(chocolate,[lemon,butterscotch,licorice_ripple])]),
	All = [lemon,butterscotch,licorice_ripple,vanilla, chocolate, cherry_ripple],
	io:format("chocolate first options, complete:~n~p~n~n",[fixed_first(chocolate,All)]),
	All_combinations = [{First,Second} || First<-All,Second<-All],
	io:format("all combinations ~p~n",[All_combinations]),

	%add popularity to each combo, sort by the first element of these new tuples, then revers the list.
	All_with_popularity = lists:reverse(lists:keysort(1,lists:map(fun(Combo)->{1.0-rand:uniform(),Combo}  end,All_combinations))),

	io:format("all by popularity:~n~p~n~n",[All_with_popularity]),

	%split the list into two parts, discarding the second part
	{Top_10,_} = lists:split(10,All_with_popularity),
	%reduce these two lists to get the total popularity
	Top_10_total = lists:foldl(fun({Popularity,_},Accum)-> Accum+Popularity end,0.0,Top_10),
	Others_total = lists:foldl(fun({Popularity,_},Accum)-> Accum+Popularity end,0.0,All_with_popularity),
	io:format("Top 10 percentage popularity:~p%~nTop 10: ~p~n",[Top_10_total/Others_total*100.0,Top_10]).


%%
%% Generates a list of two scoop cone options where the first scoop is always the same type.
%%
%% Parameters - 1)First scoop flavor
%%              2)Possible flavors for the second scoop
%% Value - a list of possible flavor combinations
%% Complexity - O(n)
%%
fixed_first(_, []) ->
	[];
fixed_first(First_flavor,Others)->
	[{First_flavor,Second}||Second<-Others].



	

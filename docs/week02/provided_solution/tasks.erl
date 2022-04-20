-module(tasks).
-export([start/0,generate_contestants/2]).

%% used to execute the simulated situation
start()->
	Shuffled = list_lib:shuffle(generate_contestants([other,female,male],20)),
	list_lib:generate_teams(Shuffled,5).


%%
%% Generates a defined number of contestants as if the data for them had been pulled from a database.
%% It is not expected that you would have figured out how to generate the list this way.
%%
%% Parameters - 1)List of genders
%%              2)Number of contestants of each gender to create
%% Value - a list of contestants
%% Complexity - O(n^2)
%%
generate_contestants([],_) ->
	[];
generate_contestants([H|T],Count)->
	%% Since I don't have names from a database, I have chosen to use the gender and a number for the name of the contestant.
	[{rand:uniform(),atom_to_list(H)++"_" ++ [N],H} || N<-lists:seq(1,Count)]++generate_contestants(T,Count).


	

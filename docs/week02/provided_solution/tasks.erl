-module(tasks).
-export([start/0]).

%% used to execute the simulated situation
start()->
	Shuffled = list_lib:shuffle(generate_contestants([other,female,male],20)),
	generate_teams(Shuffled,5).


%%
%% Generates a defined number of contestants as if the data for them had been pulled from a database.
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
	[{rand:uniform(),atom_to_list(H)++"_" ++ integer_to_list(N),H} || N<-lists:seq(1,Count)]++generate_contestants(T,Count).


%%
%% Given a list of contestants, creates a list of teams.
%%
%% Parameters - 1)List of contestants
%%				2)team size
%% Value - a list of teams
%% Complexity - O(n^2)
%%
generate_teams(Contestants,Size) when length(Contestants) < Size ->
	[];
generate_teams(Contestants,Size) ->
	Team = build_team(lists:sublist(Contestants,Size),{0.0,[]}),
	[Team]++generate_teams(lists:nthtail(Size,Contestants),Size).

%%
%% Builds a team from a list of contestants
%%
%% Parameters - 1)List of team member contestants
%%				2)A tuple used to accumulate the team
%% Value - a tuple representing the team
%% Complexity - O(n)
%%
build_team([],Accum) ->
	Accum;
build_team([{Propensity,Name,Gender}|T],{Total_propensity,Members}) ->
	build_team(T,{Total_propensity+Propensity,Members++[{Name,Gender}]}).
	

-module(list_lib).
-export([shuffle/1,generate_teams/2]).


%%
%% Given a list of contestants, creates a list of teams.
%%
%% Parameters - 1)List of contestants
%%          2)team size
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
%%          2)A tuple used to accumulate the team
%% Value - a tuple representing the team
%% Complexity - O(n)
%%
build_team([],Accum) ->
   Accum;
build_team([{Propensity,Name,Gender}|T],{Total_propensity,Members}) ->
   build_team(T,{Total_propensity+Propensity,Members++[{Name,Gender}]}).

%%
%% Shuffles a list as you might a deck of cards.
%%
%% Parameters - 1)List of items to shuffle
%% Value - a shuffled list
%% Complexity - O(n^3)
%%
shuffle(List) ->
%% Determine where to initially divide the list, then perform a series of randomizations.
   randomize(round(math:log(length(List)) + 0.5), List).

%%
%%
%%
%% Parameters - 1)Where to divide the list
%%              2)List to randomize
%% Value - a randomized list
%% Complexity - O(n^3)
%%
randomize(1, List) ->
   randomize(List);
randomize(T, List) ->
   lists:foldl(fun(_, Acc) ->
                  randomize(Acc)
               end, randomize(List), lists:seq(1, (T - 1))).

%%
%% Uses uniform random numbers to randomize a list.
%%
%% Parameters - 1)List to randomize
%% Value - a randomized version of the list parameter
%% Complexity - O(n^2)
%%
randomize(List) ->
   %% create a list of tuples from a list of elements
   %% the first member of the tuple is a random number 0.0<rand<=1.0.

   %% map complexity is O(n)
   Tuples = lists:map(fun(Element) ->
                    {1.0 - rand:uniform(), Element}
             end, List),

   %% sort the list of tuples based on the first tuple element (keysort),
   %% then generate a tuple where the first element is list of 
   %% the random numbers used to sort and the second element is
   %% a list containing the elements of the list passed in (unzip).

   %% keysort complexity is O(n^2)
   %% unzip complexity is O(n)
   {_, Randomized} = lists:unzip(lists:keysort(1, Tuples)), 
   Randomized.
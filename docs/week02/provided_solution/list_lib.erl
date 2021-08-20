-module(list_lib).
-export([shuffle/1]).


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
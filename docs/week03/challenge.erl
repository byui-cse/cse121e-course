-module(challenge).
-export([start/0]).

%%
%% This file is not intended to be shared with students.
%% It is here to help instructors with one way of how this
%% task might be completed. 
%%


start()->
	People = generate_people_for_genders([other,female,male],4),
	Pairs = generate_pair_team_combos(People),
	Teams = generate_teams(Pairs),
	pick_teams(Teams).




generate_people_for_genders([],_)->
	[];
generate_people_for_genders([H|T],Count)->
	[generate_people_by_gender(H,Count)]++generate_people_for_genders(T,Count).

generate_people_by_gender(_,0)->
	[];
generate_people_by_gender(Gender,N)->
	[{rand:uniform(),atom_to_list(Gender)++"_" ++ integer_to_list(N),Gender}]++generate_people_by_gender(Gender,N-1).



generate_pair_team_combos([])->
	[];
generate_pair_team_combos([H|T])->
	[comb_take(2,H)]++generate_pair_team_combos(T).


generate_teams([])->
	[];
generate_teams([H|_]) when length(H) == 0 ->
	[];
generate_teams([H|T])->
	[Pair|Remaining_pairs] = H,
	Other_pairs = gendered_groups_to_list_of_pairs(T),
	build_teams_with(Pair,Other_pairs)++generate_teams([Remaining_pairs|T]).

gendered_groups_to_list_of_pairs([])->
	[];
gendered_groups_to_list_of_pairs([H|T])->
	H++gendered_groups_to_list_of_pairs(T).



build_teams_with(_,[])->
	[];
build_teams_with([{Prop,Name,Gender},{Other_prop,Other_name,Other_gender}],
		[[{Mate_prop,Mate_name,Mate_gender},{Other_mate_prop,Other_mate_name,Other_mate_gender}]|T])->
	Team_propensity = Prop+Other_prop+Mate_prop+Other_mate_prop,
	[{Team_propensity,[{Name,Gender},{Other_name,Other_gender},
					   {Mate_name,Mate_gender},{Other_mate_name,Other_mate_gender}]
					   }]++build_teams_with(Pair,T).

pick_teams(All)->
	lists:sublist(lists:sort(fun({Prop_1,_},{Prop_2,_}) -> Prop_1 >= Prop_2 end,All),4).

comb_take(0,_) ->
    [[]];
comb_take(_,[]) ->
    [];
comb_take(N,[H|T]) ->
    [[H|L] || L <- comb_take(N-1,T)]++comb_take(N,T).
%% @author Lee Barney
%% @copyright 2022 Lee Barney licensed under the <a>
%%        rel="license"
%%        href="http://creativecommons.org/licenses/by/4.0/"
%%        target="_blank">
%%        Creative Commons Attribution 4.0 International License</a>
%%
%%
%% These solutions are not intended to be ideal solutions. Instead,
%% they are a solution that you can compare against yours to see
%% other options and to come up with even better solutions.
%%
-module(testing).
-export([driver/0]).

%%
%% Exercise the different types of functionality of the friends module.
%%
driver()->
	%Start two processes for each module
	Fact1 = fac:start(),
	Fact2 = fac:start(),
	Mult1 = multiply:start(),
	Mult2 = multiply:start(),
	Sum1 = sum:start(),
	Sum2 = sum:start(),
	Div1 = divide:start(),
	Div2 = divide:start(),
	%exercise the factorial processes
	[fac:rpc(Fact1,N)||N<-lists:seq(1,1_000)],
	[fac:rpc(Fact2,N)||N<-lists:seq(1_000,5_000)],
	fac:rpc(Fact1,-5),
	fac:rpc(Fact1,0),
	fac:rpc(Fact2,fdsa),

	%the product of ten rand integers between 1 and 1,000 done 1,000 times
	[multiply:rpc(Mult1,
		[rand:uniform(1_000)|| _X<-lists:seq(1,10)])
		||_Y<-lists:seq(1,1_000)],
	[multiply:rpc(Mult2,
		[rand:uniform(1_000)|| _X<-lists:seq(1,10)])
		||_Y<-lists:seq(1,1_000)],
	multiply:rpc(Mult1,[]),
	%calculate the product of 1,000 zeros :)
	multiply:rpc(Mult2,lists:duplicate(1_000,0)),

	%the sum of ten rand integers between 1 and 1,000 done 1,000 times
	[sum:rpc(Sum1,
		[rand:uniform(1_000)|| _X<-lists:seq(1,10)])
		||_Y<-lists:seq(1,1_000)],
	[sum:rpc(Sum2,
		[rand:uniform(1_000)|| _X<-lists:seq(1,10)])
		||_Y<-lists:seq(1,1_000)],
	sum:rpc(Sum1,[]),
	%calculate the sum of 1,000 zeros :)
	sum:rpc(Sum2,lists:duplicate(1_000,0)),

	%the quotient of two rand numbers between 1 and 1,000 done 1,000 times
	[divide:rpc(Div1,rand:uniform(1_000),rand:uniform(1_000))
		||_X<-lists:seq(1,1_000)],
	[divide:rpc(Div2,rand:uniform(1_000),rand:uniform(1_000))
		||_X<-lists:seq(1,1_000)],
	divide:rpc(Div2,10,5),
	divide:rpc(Div1,10,0).%this will cause a crash. You'll learn how to deal with this in later classes.





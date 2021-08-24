-module(ctemplate).
-export([start/0,rpc/2,loop/0]).%loop must be exported so it can be spawned.
start() ->
	spawn(?MODULE,loop,[]).%this is a very effective way of not having to type this over and over in your code.

rpc(Pid, Request) -> %no response handler parameter. You probably want one
	Pid ! {self(),Request},
	receive
		{Pid,Response} ->
			Response %ignoring the response
	end.

loop()->
	receive
		Any ->
			io:format("Received:~p~n",[Any]),%empty looping. does not send a response.
			loop()
	end.
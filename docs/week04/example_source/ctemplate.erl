-module(ctemplate).
-export([start/0,rpc/2,loop/0]). % loop must be exported so it can be spawned.
start() -> % specialize this to the function being spawned
	spawn(?MODULE,loop,[]). % this is a very effective way of not having to type this over and over in your code.

rpc(Pid, Request) -> % rename this to match what will be done by the spawned process
	Pid ! {self(),Request},
	receive
		{Pid,Response} ->
			Response -> Response % just sending the response back to the caller
	end.

% rename this to something other than loop.
loop()->
	receive
		Any ->
			io:format("Received:~p~n",[Any]), % change this to do pattern matching, calculations, and to send a response.
			
	end,
	loop().
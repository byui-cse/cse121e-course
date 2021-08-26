%% @author Lee Barney
%% @copyright 2020 Lee Barney licensed under the <a>
%%        rel="license"
%%        href="http://creativecommons.org/licenses/by/4.0/"
%%        target="_blank">
%%        Creative Commons Attribution 4.0 International License</a>
-module(factorial_service).
%% gen_server
-behaviour(gen_server).
-export([start_link/0]).
%% export gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
%% export client functions
-export([start/0,stop/0,for/1]).

-define(SERVER,?MODULE).

%%%--------
%%% client functions
%%%--------

%%These can be used as a template.

%% @doc The <kbd>start/0</kbd> function spawns the gen_server.
start() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
%% @doc The <kbd>stop/0</kbd> function causes a graceful stop of the gen_server.
stop()  -> gen_server:call(?MODULE, stop).


%%@doc The <kbd>for/1</kbd> function returns the sum of all elements of the parameter of type list. The list can be empty.
for(N) -> gen_server:call(?MODULE,{fact,N}).


%%%--------
%%% gen_server callbacks
%%% these functions match the interface the <kbd>gen_server</kbd> needs in order to provide the services desired.
%%%--------
%% These can also be used as a template.

%% getting things going
start_link() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
init([]) -> {ok,up}.%% setting the state to up

%%doc the <kbd>handle_call/3</kbd> function deals with the requests made to <kbd>gen_server</kbd>. The available request types are:
%% <ol>
%%   <li>factorial of a number. If the number is negative the value is 1.
%%       If the number is a floating or fixed point number, the value is factorial of the next largest integer (BigO(n)),</li>
%% </ol>
%% All for messages are to be tuples following the pattern {\<command\>,
%% \<list\>}. To stop the server the parameters are:
%% <ol>
%%   <li>stop, an atom,</li>
%%   <li>From, the PID of the <kbd>gen_server</kbd> process, and</li>
%%   <li>State, the current state of the <kbd>gen_server</kbd>.</li>
%% </ol> 


%%These are specific to your need.
handle_call({fact,N},_From,State) ->
          Result = factorial_helper(N,State),
          {reply,
                factorial_helper(N,State),
           {N,Result}};%% modifying the server's internal state to be the last and last factorial tuple.
handle_call(stop, _From, _State) -> 
	{stop,normal,
                server_stopped,
          down}. %% setting the server's internal state to down

%%%--------
%%% gen_server callbacks
%%% the default behavior here is sufficient for this service.
%%%--------
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> io:format("code changing",[]),{ok, State}.

%%
%% Controls access to the factorial calculation. This function is not available outside of this module.
%%
%% Parameters - 1)an Integer fro which factorial is desired
%%              2)the current state tuple of the service containing the last number for which
%%                factorial was requested and factorial value for that number
%% Value - factorial of the first parameter
%% Complexity - O(n)
%%
factorial_helper(N,{Last,Last_factorial}) when N > Last ->
  factorial(N,Last,Last_factorial);
factorial_helper(N,_) ->
  factorial(N,0,1).


%%
%% Calculates factorial when a partial value is already known. This function is not available outside of this module.
%%
%% Parameters - 1)an Integer for which factorial is desired
%%              2)a number for which factorial has already been calculated
%%        3)an accumulator that is parameter 2 factorial
%% Value - factorial of the first parameter
%% Complexity - O(n)
%%
factorial(I,0,_)->
  factorial(I,1,1);
factorial(I,C,Accum) when C < I ->
  factorial(I,C+1,(C+1)*Accum);
factorial(_,_,Accum)->Accum.



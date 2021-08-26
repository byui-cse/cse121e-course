%% @author Lee Barney
%% @copyright 2020 Lee Barney licensed under the <a>
%%        rel="license"
%%        href="http://creativecommons.org/licenses/by/4.0/"
%%        target="_blank">
%%        Creative Commons Attribution 4.0 International License</a>
-module(permutation_service).
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


%%@doc The <kbd>for/1</kbd> function returns a list of all permutations of the elements of the parameter of type list. The list can be empty.
for(List) -> gen_server:call(?MODULE,{perm,List}).


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
%%   <li>addition of all elements of a list of numbers (BigO(n)),</li>
%% </ol>
%% All for messages are to be tuples following the pattern {\<command\>,
%% \<list\>}. To stop the server the parameters are:
%% <ol>
%%   <li>stop, an atom,</li>
%%   <li>From, the PID of the <kbd>gen_server</kbd> process, and</li>
%%   <li>State, the current state of the <kbd>gen_server</kbd>.</li>
%% </ol> 


%%These are specific to your need.
handle_call({perm,List},_From,State) ->
          {reply,
                [{N,M}||N<-List,M<-List],
           State};%% not modifying the server's internal state
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
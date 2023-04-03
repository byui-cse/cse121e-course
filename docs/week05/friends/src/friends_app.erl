%%%-------------------------------------------------------------------
%% @doc friends public API
%% @end
%%%-------------------------------------------------------------------

-module(friends_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    friends_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

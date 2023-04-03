%%%-------------------------------------------------------------------
%% @doc intro public API
%% @end
%%%-------------------------------------------------------------------

-module(intro_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    intro_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

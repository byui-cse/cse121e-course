%%%-------------------------------------------------------------------
%% @doc game_show public API
%% @end
%%%-------------------------------------------------------------------

-module(game_show_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    game_show_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

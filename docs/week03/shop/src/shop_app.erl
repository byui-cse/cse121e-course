%%%-------------------------------------------------------------------
%% @doc shop public API
%% @end
%%%-------------------------------------------------------------------

-module(shop_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    shop_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

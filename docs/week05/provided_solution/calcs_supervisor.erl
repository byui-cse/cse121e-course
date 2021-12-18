%% @author Lee Barney
%% @copyright 2020 Lee Barney licensed under the <a>
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

-module(calcs_supervisor).
-behaviour(supervisor).
 
-export([start/0, start_link/1, start_in_shell_for_testing/0]).
-export([init/1]).

-define(SERVER, ?MODULE).


start() ->
    spawn(fun() ->
        supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
    end).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
    % A list of available service modules to start with a unique ID atom for each.
    Services = [{div_it,division_service},{add_it,sum_service},
                {mult_it,product_service},{perm_it,permutation_service},
                {fac_it,factorial_service},{binom_it,binomial_service}],
    {ok,
        {
          % The pattern for the supervision tuple is {supervision_type, restart_limit, restart_limit_time}. 
          % in this case, if the managed gen_server has to be restarted more than 3 times in 10 seconds, 
          % the supervisor should notify it's supervisor, if one exists, by failing.
          {one_for_one, 3, 10},
            % The list of services to be supervised. These are all of a common form.
            [{Uid,{M, start_link, []},permanent,10000,worker,[M]} || {Uid,M}<-Services]
            }}.
				
-module(math).
-export([fib/1]).
-include_lib("eunit/include/eunit.hrl").

%%
%%The fibonacci function
%%
fib(0) -> 0;
fib(1) -> 1;
fib(N) when N > 1 -> fib(N-1) + fib(N-2).

-ifdef(EUNIT).
-include_lib("eunit/include/eunit.hrl").

fib_test_() ->
      [
       ?_assertEqual(0,fib(0)),
       ?_assertEqual(1,fib(1)),
       ?_assertEqual(1,fib(2)),
       ?_assertEqual(2,fib(3)),
       ?_assertEqual(3,fib(4)),
       ?_assertEqual(5,fib(5)),
       ?_assertEqual(1346269,fib(31))
      ].
-endif.


-module(io_explore).
-export([print_greeting_nice/0,print_greeting_strange/0]).

print_greeting_nice()->
    {ok,Name} = io:read("Hello, what's your name? "),
    io:format("It is so nice to meet you ~s.~n",[Name]).

print_greeting_strange()->
    {ok,Name} = io:read("Hello, what's your name? "),
    io:format("It is so nice to meet you ~w.~n",[Name]).
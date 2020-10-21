-module(io_explore).
-export([print_greeting_nice/0,print_greeting_strange/0, get_data/0]).

print_greeting_nice()->
    {ok,Name} = io:read("Hello, what's your name? "),
    io:format("It is so nice to meet you ~s.~n",[Name]).

print_greeting_strange()->
    Name = io:get_line("Hello, what's your name? "),
    io:format("It is so nice to meet you ~w.~n",[Name]).

get_data() ->
        {ok, Term} = io:read("Enter a number: "),
        io:format("The number you entered plus one is: ~w~n", 
                  [Term + 1]).
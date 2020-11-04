-module(conversation).

start_conversation()->
    {ok,Name} = io:read("What's your name? "),
    io:format("It's so good to see you, ~w~n",Name).
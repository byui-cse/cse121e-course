% This is the module and functions for your first attempt to load and run an Erlang file.
-module(test).
-export([print_hello/0]).

print_hello()->
	io:fwrite("Hello everybody!\nThis is soooo cool!\n").
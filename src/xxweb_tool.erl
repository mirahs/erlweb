-module(xxweb_tool).

-export([
	info/5,
	error/5
]).


info(Format, Args, Pid, Module, Line) ->
	Msg = format("xxweb INFO", Format, Args, Pid, Module, Line),
	echo(Msg).

error(Format, Args, Pid, Module, Line) ->
	Msg = format_error(Format, Args, Pid, Module, Line),
	echo(Msg).


format(Info, Format, Args, Pid, Module, Line) ->
	{{Y, M, D}, {H, I, S}} = erlang:localtime(),
	Date = lists:concat([Y, "-", M, "-", D, " ", H, ":", I, ":", S]),
	erlang:iolist_to_binary(io_lib:format(lists:concat(["## ", Info, " ~s Pid:~w [~w:~w] ", Format, "~n"]), [Date, Pid, Module, Line] ++ Args)).

format_error(Format, Args, Pid, Module, Line) ->
	{{Y, M, D}, {H, I, S}} = erlang:localtime(),
	Date = lists:concat([Y, "-", M, "-", D, " ", H, ":", I, ":", S]),
	erlang:iolist_to_binary(io_lib:format("~n*****~nDATE:~s Pid:~w xxweb Error ~w:~w~n" ++ Format ++ "~n*****~n", [Date, Pid, Module, Line] ++ Args)).

%% 输出到控制台
echo(Msg) ->
	io:format("~ts", [Msg]).

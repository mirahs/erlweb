-module(controller_cp_index).

-compile(export_all).


index(_Method, _Req, _OPts) ->
	io:format("~p index function method:~p~n", [?MODULE, _Method]),
	{output, "hello,from controller_cp_index:index"}.


test(_Method, _Req, _OPts) ->
	{output, "This is a test!"}.

noaccess(_Method, _Req, _OPts) ->
	{output, "No Access!"}.

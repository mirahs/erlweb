-module(xxweb_handler_error).

-include("common.hrl").

-export([
		 init/2,
		 error_out/2
		]).


init(Req, Opts) ->
	error_out(Req, Opts).


error_out(Req, Opts) ->
	Req2 = cowboy_req:reply(500, [{<<"content-type">>, <<"text/plain;charset=utf-8">>}], <<"request failed, sorry\n">>, Req),
	{?ok, Req2, Opts}.

-module(erlweb_handler_error).

-export([
    init/2

    ,error_out/2
    ,error_out/3
]).


init(Req, Opts) ->
    error_out(Req, Opts).


error_out(Req, Opts) ->
    Req2 = cowboy_req:reply(500, [{<<"content-type">>, <<"text/plain;charset=utf-8">>}], <<"request failed, sorry\n">>, Req),
    {ok, Req2, Opts}.

error_out(Req, State, Content) ->
    Req2 = cowboy_req:reply(500, #{<<"content-type">> => <<"text/plain;charset=utf-8">>}, Content, Req),
    {ok, Req2, State}.

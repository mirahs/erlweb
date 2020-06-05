-module(controller_cp_index).

-compile(export_all).


index(_Method, _Req, _OPts) ->
    {output, "hello,from controller_cp_index:index"}.

test(_Method, _Req, _OPts) ->
    {output, "This is a test!"}.

session(_Method, _Req, _Opts) ->
    Num = erlweb_session:get(num, 0),
    Num2= Num + 1,
    erlweb_session:set(num, Num2),
    {output, "num is " ++ erlweb_util:to_list(Num2)}.

noaccess(_Method, _Req, _OPts) ->
    {output, "No Access!"}.

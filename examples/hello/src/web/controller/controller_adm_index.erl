-module(controller_adm_index).

-compile(nowarn_export_all).
-compile(export_all).


index(_Method, _Req, _OPts) ->
    {text, "Hello from controller_adm_index:index"}.

test(_Method, _Req, _OPts) ->
    {text, "This is a test!"}.

session(_Method, _Req, _Opts) ->
    Num = erlweb_session:get(num, 0),
    Num2= Num + 1,
    erlweb_session:set(num, Num2),
    {text, "num is " ++ erlweb_util:to_list(Num2)}.

noaccess(_Method, _Req, _OPts) ->
    {text, "No Access!"}.

%% -*- coding: latin-1 -*-
-module(erlweb_handler).

-export([
    init/2
]).

-include("common.hrl").


init(Req = #{path := Path, method := Method}, State = #{session_apps := SessionApps, dispatcher := Dispatcher}) ->
    AppB = cowboy_req:binding(app, Req),
    ModuleB	= cowboy_req:binding(module, Req),
    FuncB	= cowboy_req:binding(func, Req),

    case Dispatcher:get(Path, AppB, ModuleB, FuncB) of
        {ok, PH} ->
            try
                {ok, Req2, State2} = handle_do(Method, Req, State, PH),
                Req3 = ?IF(lists:member(AppB, SessionApps), erlweb_session:on_response(Req2), Req2),
                {ok, Req3, State2}
            catch
                Error:Reason ->
                    ?ERR("Path:~p, PH:~p, Error:~p,~nReason:~n~p,~nStackTrace:~n~p", [Path, PH, Error, Reason, erlang:get_stacktrace()]),
                    error_out(Req, State)
            end;
        {error, Path = <<"/favicon.ico">>} ->
            error_out(Req, State, <<"get ", Path/bitstring, " file.">>);
        {error, UrlNoAccess} ->
            handle_do_redirect(Req, State, UrlNoAccess)
    end.


handle_do(Method, Req, State, #{controller := Module, func := Func, dtl := Dtl, dtle := DtlEdit}) ->
    try Module:Func(Method, Req, State) of
        {output, Content} ->
            Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain; charset=utf-8">>}, Content, Req),
            {ok, Req2, State};
        {output, Content, Req1, Opts1} ->
            Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain;charset=utf-8">>}, Content, Req1),
            {ok, Req2, Opts1};
        {ok, dtl} ->
            handle_do_dtl(Req, State, Dtl, []);
        {ok, dtl_edit} ->
            handle_do_dtl(Req, State, DtlEdit, []);
        {ok, dtl, DtlKeyValues} ->
            handle_do_dtl(Req, State, Dtl, DtlKeyValues);
        {ok, dtl_edit, DtlKeyValues} ->
            handle_do_dtl(Req, State, DtlEdit, DtlKeyValues);
        {json, JsonData} ->
            Req1 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/json;charset=utf-8">>}, JsonData, Req),
            {ok, Req1, State};
        redirect ->
            handle_do_redirect(Req, State);
        {redirect, Url} ->
            handle_do_redirect(Req, State, Url);
        {redirect, Url, Req2} ->
            handle_do_redirect(Req2, State, Url);
        {ok, Req1, Opts1} ->
            {ok, Req1, Opts1};
        {error, Msg} ->
            handle_do_error(Req, State, Msg);
        {error, Msg, Url} ->
            handle_do_error(Req, State, Msg, Url)
    catch
        error:{error, Msg} -> handle_do_error(Req, State, Msg);
        error:{error, Msg, Url} -> handle_do_error(Req, State, Msg, Url);
        error:redirect -> handle_do_redirect(Req, State);
        error:{redirect, Url} -> handle_do_redirect(Req, State, Url)
    end.


handle_do_dtl(Req, Opts, DtlA, DtlKeyValues) ->
    {ok, Html} = DtlA:render(DtlKeyValues),
    Req3 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html;charset=utf-8">>}, Html, Req),
    {ok, Req3, Opts}.

handle_do_error(Req, Opts, Msg) ->
    handle_do_error(Req, Opts, Msg, cowboy_req:path(Req)).
handle_do_error(Req, Opts, Msg, Url) ->
    Content = <<"<script type=\"text/javascript\">alert('", ?B(Msg) ,"');</script>">>,
    Req2	= cowboy_req:reply(200, #{<<"refresh">> => <<"0;url=\"", ?B(Url), "\"">>, <<"content-type">> => <<"text/html; charset=utf-8">>}, Content, Req),
    {ok, Req2, Opts}.

handle_do_redirect(Req, State) ->
    handle_do_redirect(Req, State, cowboy_req:path(Req)).
handle_do_redirect(Req, State, Url) ->
    Req2 = cowboy_req:reply(303, #{<<"location">> => ?TOB(Url)}, <<>>, Req),
    {ok, Req2, State}.


error_out(Req, State) ->
    Req2 = cowboy_req:reply(500, #{<<"content-type">> => <<"text/plain;charset=utf-8">>}, <<"request failed, sorry\n">>, Req),
    {ok, Req2, State}.

error_out(Req, State, Content) ->
    Req2 = cowboy_req:reply(500, #{<<"content-type">> => <<"text/plain;charset=utf-8">>}, Content, Req),
    {ok, Req2, State}.

-module(erlweb_handler).

-include("common.hrl").

-export([
	init/2
]).


init(Req, State = #{apps := Apps, session_apps := SessionApps, dispatcher := Dispatcher}) ->
	AppB = cowboy_req:binding(app, Req),
	case lists:member(AppB, Apps) of
		true ->
			Path	= cowboy_req:path(Req),
			Method	= cowboy_req:method(Req),
			ModuleB	= cowboy_req:binding(module, Req),
			FuncB	= cowboy_req:binding(func, Req),

			Req2 = ?IF(lists:member(AppB, SessionApps), erlweb_session:on_request(Req), Req),
			case Dispatcher:get(Path, AppB, ModuleB, FuncB) of
				{ok, PH} ->
					try
						handle_do(Method, Req2, State, PH)
					catch
						Error:Reason ->
							?ERR("Path:~p, PH:~p, Error:~p, Reason:~p,~nStackTrace:~p", [Path,PH,Error,Reason,erlang:get_stacktrace()]),
							erlweb_handler_error:error_out(Req2, State)
					end;
				{error, UrlNoAccess} ->
					Req3 = cowboy_req:reply(303, [{<<"location">>, ?TOB(UrlNoAccess)}], <<>>, Req2),
					{ok, Req3, State}
			end;
		false -> erlweb_handler_error:error_out(Req, State)
	end.


handle_do(Method, Req, Opts, #{controller:=ModuleA,func:=FuncA,dtl:=DtlA,dtle:=DtlEditA}) ->
	try ModuleA:FuncA(Method, Req, Opts) of
		{output, Content} ->
			Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain; charset=utf-8">>}, Content, Req),
			{?ok, Req2, Opts};
		{output, Content, Req1, Opts1} ->
			Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain;charset=utf-8">>}, Content, Req1),
			{?ok, Req2, Opts1};
		{?ok, dtl} ->
			handle_do_dtl(Req, Opts, DtlA, []);
		{?ok, dtl_edit} ->
			handle_do_dtl(Req, Opts, DtlEditA, []);
		{?ok, dtl, DtlKeyValues} ->
			handle_do_dtl(Req, Opts, DtlA, DtlKeyValues);
		{?ok, dtl_edit, DtlKeyValues} ->
			handle_do_dtl(Req, Opts, DtlEditA, DtlKeyValues);
		{json, JsonData} ->
			Req1 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/json;charset=utf-8">>}, JsonData, Req),
			{?ok, Req1, Opts};
		redirect ->
			handle_do_redirect(Req, Opts);
		{redirect, Url} ->
			handle_do_redirect(Req, Opts, Url);
		{redirect, Url, Req2} ->
			handle_do_redirect(Req2, Opts, Url);
		{?ok, Req1, Opts1} ->
			{?ok, Req1, Opts1};
		{?error, Msg} ->
			handle_do_error(Req, Opts, Msg);
		{?error, Msg, Url} ->
			handle_do_error(Req, Opts, Msg, Url)
	catch
		error:{error, Msg} -> handle_do_error(Req, Opts, Msg);
		error:{error, Msg, Url} -> handle_do_error(Req, Opts, Msg, Url);
		error:redirect -> handle_do_redirect(Req, Opts);
		error:{redirect, Url} -> handle_do_redirect(Req, Opts, Url)
	end.


handle_do_dtl(Req, Opts, DtlA, DtlKeyValues) ->
	{?ok, Html} = DtlA:render(DtlKeyValues),
	Req3 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html;charset=utf-8">>}, Html, Req),
	{?ok, Req3, Opts}.

handle_do_error(Req, Opts, Msg) ->
	handle_do_error(Req, Opts, Msg, cowboy_req:path(Req)).
handle_do_error(Req, Opts, Msg, Url) ->
	MsgB	= erlweb_util:to_binary(Msg),
	Content = <<"<script type=\"text/javascript\">alert('", MsgB/binary ,"');</script>">>,
	%PathB	= {<<"refresh">>, <<"0;url=\"", ?B(Url), "\"">>},
	%Req2	= cowboy_req:reply(200, [PathB, {<<"content-type">>, <<"text/html; charset=utf-8">>}], Content, Req),
	Req2	= cowboy_req:reply(200, #{<<"refresh">> => <<"0;url=\"", ?B(Url), "\"">>, <<"content-type">> => <<"text/html; charset=utf-8">>}, Content, Req),
	{?ok, Req2, Opts}.

handle_do_redirect(Req, State) ->
	handle_do_redirect(Req, State, cowboy_req:path(Req)).
handle_do_redirect(Req, State, Url) ->
	Req2= cowboy_req:reply(303, #{<<"location">> => ?TOB(Url)}, <<>>, Req),
	{ok, Req2, State}.

-module(admin_app).

-behaviour(application).

-export([
	start/2
	,stop/1
]).


start(_StartType, _StartArgs) ->
	case init:get_plain_arguments() of
		[DirVar] ->
			gen_event:swap_handler(alarm_handler, {alarm_handler, swap}, {sys_alarm_handler, null}),
			error_logger:logfile({open, lists:concat([DirVar, "admin_error.log"])}),

			admin_sup:start_link();
		_ -> {error, args_error}
	end.

stop(_State) ->
	ok.

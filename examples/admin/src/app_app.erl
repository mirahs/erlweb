%% -*- coding: latin-1 -*-
-module(app_app).

-behaviour(application).

-export([
    start/2
    ,stop/1
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

start(_StartType, _StartArgs) ->
    case init:get_plain_arguments() of
        [DirVar] ->
            gen_event:swap_handler(alarm_handler, {alarm_handler, swap}, {sys_alarm_handler, null}),
            error_logger:logfile({open, lists:concat([DirVar, "app_error.log"])}),

            % 热更管理器初始化
            sys_code:init(),

            % MySQL 初始化
            mysql:add_pool(?db_admin, ?mysql_username, ?mysql_password, ?mysql_database),

            app_sup:start_link();
        _ -> {error, args_error}
    end.

stop(_State) ->
    erlweb:stop(),
    ok.

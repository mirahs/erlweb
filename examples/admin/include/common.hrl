%%% -*- coding: latin-1 -*-

%%%===================================================================
%%% 日志记录
%%%===================================================================

-ifdef(debug).
-define(DEBUG(Msg), logger:debug(Msg, [], ?MODULE, ?LINE)).         % 输出调试信息
-define(DEBUG(F, A),logger:debug(F, A, ?MODULE, ?LINE)).
-else.
-define(DEBUG(Msg), ok).
-define(DEBUG(F, A),ok).
-endif.

-define(INFO(Msg),  catch logger:info(Msg, [], ?MODULE, ?LINE)).    % 输出普通信息
-define(INFO(F, A), catch logger:info(F, A, ?MODULE, ?LINE)).
-define(ERR(Msg),   catch logger:error(Msg, [], ?MODULE, ?LINE)).   % 输出错误信息
-define(ERR(F, A),  catch logger:error(F, A, ?MODULE, ?LINE)).


%%%===================================================================
%%% 配置
%%%===================================================================

%% 目录
-define(DIR_ROOT,   "./").
-define(DIR_PRIV,   ?DIR_ROOT ++ "priv/").


%% MySQL 数据库 ID
-define(db_admin,	db_admin).


%%%===================================================================
%%% 数据类型与常量
%%%===================================================================

%% 时间
-define(DATE_SECONDS,   86400).
-define(DATE_MS,        86400000).
-define(HOUR_SECONDS,   3600).
-define(HOUR_MS,        3600000).

%% 数字型 bool 值
-define(true, 1).
-define(false, 0).


%%%===================================================================
%%% 函数封装
%%%===================================================================

%% 转二进制 简写
-define(B(D),   (util:to_binary(D))/binary).

%% 函数封装
-define(IF(B,T,F),  case (B) of true -> (T); false -> (F) end).

%% 带catch的gen_server:call/2，返回{error, timeout} | {error, noproc} | {error, term()} | term() | {exit, normal}
%% 此宏只会返回简略信息，如果需要获得更详细的信息，请使用以下方式自行处理:
-define(CALL(Pid, Req),
    case catch gen_server:call(Pid, Req) of
        {'EXIT', {timeout, _}} -> {error, timeout};
        {'EXIT', {noproc, _}} -> {error, noproc};
        {'EXIT', normal} -> {exit, normal};
        {'EXIT', ReasonErr} -> {error, ReasonErr};
        Rtn -> Rtn
    end).

-define(GCALL(Pid, Req),
    case catch gen_server:call(Pid, Req) of
        {'EXIT', Err} ->
            ?ERR("gen_server call error(~w)", [Err]),
            {false, err_server_busy};
        Rtn -> Rtn
    end).

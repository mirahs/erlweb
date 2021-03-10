%%% -*- coding: latin-1 -*-

%%%===================================================================
%%% 日志记录
%%%===================================================================

-ifdef(debug).
-define(DEBUG(Msg), erlweb_logger:debug(Msg, [], ?MODULE, ?LINE)).         % 输出调试信息
-define(DEBUG(F, A),erlweb_logger:debug(F, A, ?MODULE, ?LINE)).
-else.
-define(DEBUG(Msg), ok).
-define(DEBUG(F, A),ok).
-endif.

-define(INFO(Msg),  catch erlweb_logger:info(Msg, [], ?MODULE, ?LINE)).    % 输出普通信息
-define(INFO(F, A), catch erlweb_logger:info(F, A, ?MODULE, ?LINE)).
-define(ERR(Msg),   catch erlweb_logger:error(Msg, [], ?MODULE, ?LINE)).   % 输出错误信息
-define(ERR(F, A),  catch erlweb_logger:error(F, A, ?MODULE, ?LINE)).


%%%===================================================================
%%% 函数封装
%%%===================================================================

-define(IF(B, T, F),case (B) of true -> (T); false -> (F) end).

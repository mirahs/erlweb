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

-define(IF(B,T,F),          case (B) of true -> (T); false -> (F) end).

-define(B(D),				(erlweb_util:to_binary(D))/binary).

-define(TOU8B(Characters),  unicode:characters_to_binary(Characters)).
-define(TOI(Arg),			erlweb_util:to_integer(Arg)).
-define(TOB(Arg),			erlweb_util:to_binary(Arg)).
-define(TOA(Arg),			erlweb_util:to_atom(Arg)).
-define(TOL(Arg),			erlweb_util:to_list(Arg)).

-define(M2L(Arg),			maps:to_list(Arg)).
-define(MGET(K,M),			maps:get(K,M)).
-define(MGET(K,M,D),		maps:get(K,M,D)).

-define(PLGET(K,L),			proplists:get_value(K,L)).
-define(PLGET(K,L,D),		proplists:get_value(K,L,D)).

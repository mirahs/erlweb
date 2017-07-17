-include("logger.hrl").
-include("util.hrl").


-define(CONST_TRUE,						1).
-define(CONST_FALSE,					0).

-define(CONST_PERCENT_FAST,             100).	% 百分比,转换速算数(如:5978 除以本速算数5978/100=59.78%) Ps:主要是前端用 
-define(CONST_PERCENT,                  10000).	% 百分比分母(100为1% 10000为100%))

%% 常量 一分钟
-define(CONST_MINUTE_MULTIPLE,			60000).
%% sleep(半秒)
-define(CONST_TIME_SLEEP,				500).
%% 一天的时间（秒）
-define(CONST_DAY_SECONDS,        		86400).	
%% 一天时间（毫秒）
-define(CONST_DAY_MILLISECONDS, 		86400000).
%% 0000到1970年的秒数
-define(DIFF_SECONDS_0000_1900, 		62167219200).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 数据类型与常量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-define(true, 					true).		 %% true  真/开
-define(false, 					false).		 %% false 假/关
-define(ok, 					ok).	 	 %% ok
-define(error, 					error).	 	 %% error
-define(start, 					start).	 	 %% start
-define(stop, 					stop).	 	 %% stop
-define(reply, 					reply).	 	 %% reply
-define(loop, 					loop).		 %% loop 
-define(doloop, 				doloop).	 %% doloop 
-define(noreply, 				noreply).	 %% noreply
-define(timeout, 				timeout).	 %% timeout
-define(ignore, 				ignore).	 %% ignore
-define(skip,					skip).	     %% skip
-define(nan,					nan).		 %% nan
-define(undefined, 				undefined).	 %% undefined
-define(null, 					null).		 %% null 
-define(normal, 				normal).	 %% normal 
-define(exit, 					exit).	 	 %% exit
-define(trap_exit, 				trap_exit).	 %% trap_exit 
-define(change_socket,			change_socket). 
-define(inet_reply,				inet_reply). %% inet_reply
-define(alive,					alive).		 %% alive
-define(pong,					pong).		 %% pong
-define(exec,					exec).		 %% exec
-define(atomic,					atomic).	 %% atomic


-define(bool, 					boolean).	 %% 布尔值
-define(int8, 					int8).		 %% 8位带符号整型
-define(int8u, 					int8u).		 %% 8位无符号整型
-define(int16, 					int16).		 %% 16位带符号整型
-define(int16u, 				int16u).	 %% 16位无符号整型
-define(int32, 					int32).		 %% 32位带符号整型
-define(int32u, 				int32u). 	 %% 32位无符号整型
-define(int64, 					int64).		 %% 64位带符号整型 
-define(int64u, 				int64u).	 %% 64位无符号整型
%-define(float32,				float32).	 %% 单精度(32 位)浮点数
-define(float64,				float64).	 %% 双精度(64 位)浮点数
-define(string, 				string).     %% 短字符串(小于256)
-define(stringl, 				string_long).%% 长字符串(小于65536)

-define(tip, 					tip).	 	 %% tip


%% 转二进制 简写

%% 语言包参数转换
-define(LANG(Tran, Args),		io_lib:format(Tran, Args)).
%% 函数封装
-define(TRY_FAST(B,T), 			try (B) catch _:_ -> (T) end).
-define(TRY_DO(B), 				try (B) catch Error:Reason -> ?MSG_ECHO("Error:~p, ~nReason:~p, ~nStackTrace:~p", [Error,Reason,erlang:get_stacktrace()]) end).
-define(TRY_DO(B,R),			try (B) catch Error:Reason -> ?MSG_ECHO("Error:~p, ~nReason:~p, ~nStackTrace:~p", [Error,Reason,erlang:get_stacktrace()]), R end).
-define(TRY_DO_WEB(B,Path,E), 	try (B) catch Error:Reason -> ?MSG_ECHO("Path:~p, Error:~p, Reason:~p,~nStackTrace:~p", [Path,Error,Reason,erlang:get_stacktrace()]), (E) end).
-define(IF(B,T,F), 				case (B) of ?true -> (T); ?false -> (F) end).

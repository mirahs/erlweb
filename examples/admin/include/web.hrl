%%% -*- coding: latin-1 -*-

%%%===================================================================
%%% erlweb
%%%===================================================================

-define(web_port,           	1111).          % web 端口
-define(web_session_app,    	[<<"adm">>]).   % web 需要 session 处理的 app 列表


%%%===================================================================
%%% ets
%%%===================================================================

-define(ets_web_path_to_mfd,			ets_web_path_to_mfd).
-define(ets_web_purview_data,			ets_web_purview_data).
-define(ets_web_purview_check,			ets_web_purview_check).


-define(CP_IP_COUNT,				5).
-define(CP_IPS_COUNT,				20).

-define(PROJECT_NAME,				<<"《欢乐转转》">>).		% 项目名称
-define(POWERED_CORP_NAME,			<<"干货科技">>).			% 公司名称
-define(POWERED_CORP_URL,			"http://www.gank.top").		% 公司官网
-define(POWERED_STUDIO_NAME,		<<"干货悦读">>).			% 工作室名称
-define(POWERED_STUDIO_URL,			"http://www.read.gank.top").% 工作室官网

-define(static_url,					"/static/").

-define(METHOD_GET,					<<"GET">>).
-define(METHOD_POST,				<<"POST">>).

-define(WEB_ERROR(Msg),				erlang:error({error, Msg})).
-define(WEB_ERROR(Msg, Url),		erlang:error({error, Msg, Url})).
-define(WEB_REDIRECT(),				erlang:error(redirect)).
-define(WEB_REDIRECT(Url),			erlang:error({redirect, Url})).
-define(WEB_MUST_LOGIN(),			web_cp:must_login()).


-record(path_handle_dtl, {
	path,
	controller,
	module,
	func,
	dtl,
	dtle
}).

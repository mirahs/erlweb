%%% -*- coding: latin-1 -*-

%%%===================================================================
%%% erlweb
%%%===================================================================

-define(web_port,           	    1111).                      % web 端口

-define(web_project_name,			"干货悦读").		        % 项目名称
-define(web_powered_corp_name,		"干货科技").			    % 公司名称
-define(web_powered_corp_url,		"http://www.gank.top").		% 公司官网
-define(web_powered_studio_name,	"干货悦读").			    % 工作室名称
-define(web_powered_studio_url,		"http://www.read.gank.top").% 工作室官网

-define(web_app_adm,			    <<"adm">>).		            % app-adm
-define(web_session_app,    	    [?web_app_adm]).            % web 需要 session 处理的 app 列表

%% web 资源地址
-define(web_static_url,				"/static/").
%% 无权限提示
-define(web_noaccess_url,		    "/adm/noaccess").


%%%===================================================================
%%% ets
%%%===================================================================

-define(ets_web_path2mfd,	ets_web_path2mfd).	% 路径转控制器和方法
-define(ets_web_menu_data,	ets_web_menu_data).	% 账号对应菜单数据
-define(ets_web_menu_check,	ets_web_menu_check).	% 路径和账号对应访问权限缓存


%% 后台账号类型
-define(adm_user_type_admin,	10). % 管理员
-define(adm_user_type_guest,	20). % 游客

-define(adm_user_types_desc, #{
    ?adm_user_type_admin    => "管理员",
    ?adm_user_type_guest    => "游客"
}).


%% 不需要检查的 控制器 和 方法
-define(adm_non_check_cv,		[
    {index, index}
    ,{index, login}
    ,{index, logout}
    ,{index, noaccess}
]).


-define(adm_ip_count,				5).
-define(adm_ips_count,				20).

-define(web_get,					<<"GET">>).
-define(web_post,					<<"POST">>).

-define(web_error(Msg),				erlang:error({error, Msg})).
-define(web_error(Msg, Url),		erlang:error({error, Msg, Url})).
-define(web_redirect(),				erlang:error(redirect)).
-define(web_redirect(Url),			erlang:error({redirect, Url})).
-define(web_must_login(),			web_cp:must_login()).


-record(web_path2mfd, {
    path,
    controller,
    module,
    func,
    dtl,
    dtle
}).

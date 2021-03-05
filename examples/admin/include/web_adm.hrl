%%% -*- coding: latin-1 -*-

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

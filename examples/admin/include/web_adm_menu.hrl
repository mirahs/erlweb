%%% -*- coding: latin-1 -*-

%% 菜单
-define(web_menus, [
    #{code => home,     name => "首页",       data => ?web_menu_home},
    #{code => sys,      name => "管理",       data => ?web_menu_sys}
]).


%% 菜单-首页
-define(web_menu_home, [
    #{code => welcome,      name => "欢迎",           url => "home/welcome",      key => [10,20]},
    #{code => menu_update,  name => "菜单更新",       url => "home/menu_update",  key => [10]}
]).

%% 菜单-管理
-define(web_menu_sys, [
    #{code => password,     name => "密码更新",     key => [10,20]},
    #{name => "管理员管理", data => [
        #{code => master_new,       name => "添加管理员",        key => [10]},
        #{code => master_list,      name => "管理员列表",        key => [10]}
    ]},
    #{name => "日志", data => [
        #{code => log_login,        name => "登录日志",         url => "sys/log_login",     key => [10]}
    ]}
]).

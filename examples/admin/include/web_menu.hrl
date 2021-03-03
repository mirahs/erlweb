%%% -*- coding: latin-1 -*-

%% 菜单列表
-define(web_menus, [
    #{code => home,	name => "首页",   default => '/adm/home/welcome',		sub => ?web_menu_home}
    ,#{code => sys,		name => "管理",   default => '/adm/sys/password', 		sub => ?web_menu_sys}
]).

%% 菜单-首页
-define(web_menu_home, [
    #{code_sub => welcome, 		name => "欢迎",           url => '/adm/home/welcome',     key => [10,20]}
    ,#{code_sub => clear, 			name => "清除网站缓存",   url => '/adm/home/clear',       key => [10]}
]).

%% 菜单-管理
-define(web_menu_sys, [
    #{code_sub => password, 		name => "密码更新",       url => '/adm/sys/password',       key => [10,20]},
    #{name => "管理员管理", data => [
        #{code_sub => master_new,       name => "添加管理员", 	url => '/adm/sys/master_new',       key => [10]},
        #{code_sub => master_list,      name => "管理员列表", 	url => '/adm/sys/master_list',      key => [10]}
    ]},
    #{name => "日志", data => [
        #{code_sub => log_login,        name => "登录日志",		url => '/adm/sys/log_login',        key => [10]}
    ]}
]).

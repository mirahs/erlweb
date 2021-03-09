%% -*- coding: latin-1 -*-
-module(controller_adm_sys).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").
-include("web_adm.hrl").


%% 密码更新
password(?web_get, Req, _Opts) ->
    Data    = cowboy_req:parse_qs(Req),
    Account0= proplists:get_value(<<"account">>, Data),
    Account = ?IF(Account0 =:= undefined, web_adm:get_account(), Account0),
    {dtl, [{account, Account}]};
password(?web_post, Req, _Opts) ->
    {ok, Data, _Req2} = cowboy_req:read_urlencoded_body(Req),
    Account = proplists:get_value(<<"account">>, Data, <<>>),
    Password= proplists:get_value(<<"password">>, Data, <<>>),
    ?IF(Account =:= <<>> orelse Password =:= <<>>, ?web_failed("请输入正确的数据"), skip),
    tbl_adm_user:update_password_by_account(Account, util:md5(util:md5(Password))),
    web:echo_success().

%% 管理员列表
master_list(?web_get, Req, _Opts) ->
    #{page := Page, datas := Datas0} = web_page:page(Req, adm_user),
    Fun = fun
              (#{type := TypeF, lock := LockF} = Data, DatasAcc) ->
                  TypeDesc = maps:get(TypeF, ?adm_user_types_desc),
                  LockDesc = ?IF(LockF =:= 0, "锁定", "解锁"),
                  [Data#{type_desc => TypeDesc, lock_desc => LockDesc} | DatasAcc]
          end,
    Datas = lists:reverse(lists:foldl(Fun, [], Datas0)),
    {dtl, [{page, Page}, {datas, Datas}]}.

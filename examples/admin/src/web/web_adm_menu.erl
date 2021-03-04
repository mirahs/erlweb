%% -*- coding: latin-1 -*-
-module(web_adm_menu).

-export([
    menu_init/0
    ,menu_check/3
    , menus/1
]).

-include("web.hrl").
-include("web_menu.hrl").


%%%===================================================================
%%% API
%%%===================================================================

%% 菜单数据初始化
menu_init() ->
    ets:insert(?ets_web_menu_data, [{UserType, do_menu_init(UserType)} || UserType <- maps:keys(?adm_user_types_desc)]).

%% 检查路由菜单权限
menu_check(Path, Code, CodeSub) ->
    %?INFO("~p", [{Path, Code, CodeSub}]),
    case lists:member({Code, CodeSub}, ?adm_non_check_cv) of
        true -> true;
        false ->
            Type = erlweb_session:get(session_type, 0),
            case Type of
                0 -> false;
                _ ->
                    case ets:lookup(?ets_web_menu_check, {Path, Type}) of
                        [{{Path, Type}, Flag}] -> Flag;
                        [] ->
                            Flag = menu_check2(Type, Code, CodeSub),
                            ets:insert(?ets_web_menu_check, {{Path, Type}, Flag}),
                            Flag
                    end
            end
    end.

%% 根据账号类型得到原始菜单数据
menus(UserType) ->
    [{UserType, Menus}] = ets:lookup(?ets_web_menu_data, UserType),
    MenuHeaderCodes	= menu_header_codes(Menus),
    {Menus, MenuHeaderCodes}.


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 头部菜单数据
menu_header_codes(Menus) ->
    jsx:encode([Code || #{code := Code} <- Menus]).

%% 检查菜单权限
menu_check2(UserType, Code, CodeSub) ->
    {Menus, _MenuHeaderCodes} = menus(UserType),
    menu_check3(Code, CodeSub, Menus).

menu_check3(Code, CodeSub, [#{code := Code, sub := Sub} | _Menus]) ->
    Fun = fun
              (#{data := Data}) ->
                  Fun2 = fun(#{code_sub := CodeSubXX}) -> CodeSub =:= CodeSubXX end,
                  lists:any(Fun2, Data);
              (#{code_sub := CodeSubXX}) ->
                  CodeSub =:= CodeSubXX
          end,
    lists:any(Fun, Sub);
menu_check3(Code, CodeSub, [_Menu | Menus]) ->
    menu_check3(Code, CodeSub, Menus);
menu_check3(_Code, _CodeSub, []) ->
    false.


%% 菜单数据初始化(根据账号类型)
do_menu_init(UserType) ->
    Fun = fun
              (#{sub := Sub} = Menu, MenusAcc) ->
                  Fun2 = fun
                             (#{key := Keys} = MenuSub, MenuSubsAcc) ->
                                 case Keys =:= [] orelse lists:member(UserType, Keys)  of
                                     true -> MenuSubsAcc ++ [MenuSub];
                                     false -> MenuSubsAcc
                                 end;
                             (#{data := Data} = MenuSub, MenuSubsAcc) ->
                                 Fun3 = fun
                                            (#{key := KeysSub} = MenuSubSub, MenuSubSubsAcc) ->
                                                case KeysSub =:= [] orelse lists:member(UserType, KeysSub) of
                                                    true -> MenuSubSubsAcc ++ [MenuSubSub];
                                                    false -> MenuSubSubsAcc
                                                end
                                        end,

                                 case lists:foldl(Fun3, [], Data) of
                                     [] -> MenuSubsAcc;
                                     Data2 ->
                                         MenuSub2 = MenuSub#{data => Data2},
                                         MenuSubsAcc ++ [MenuSub2]
                                 end
                         end,

                  case lists:foldl(Fun2, [], Sub) of
                      [] -> MenusAcc;
                      Sub2 ->
                          Menu2 = Menu#{sub => Sub2},
                          MenusAcc ++ [Menu2]
                  end
          end,
    lists:foldl(Fun, [], ?web_menus).

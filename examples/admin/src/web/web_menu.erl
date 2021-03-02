%% -*- coding: latin-1 -*-
-module(web_menu).

-compile(nowarn_export_all).
-compile(export_all).

-include("web.hrl").
-include("web_menu.hrl").


%% 检查访问权限
purview_check(Path, Code, CodeSub) ->
	%?INFO("~p", [{Path, Code, CodeSub}]),
	case lists:member({Code, CodeSub}, ?web_non_check_cv) of
		true ->
			%?INFO("~p", [{Path, Code, CodeSub}]),
			true;
		false ->
			Type = erlweb_session:get(session_type, 0),
			case Type of
				0 ->
					%?INFO("~p", [{Path, Code, CodeSub}]),
					false;
				_ ->
					%?INFO("~p", [{Path, Code, CodeSub}]),
					case ets:lookup(?ets_web_purview_check, {Path,Type}) of
						[{{Path,Type}, Flag}] ->
							%?INFO("~p", [{Path, Code, CodeSub}]),
							Flag;
						[] ->
							%?INFO("~p", [{Path, Code, CodeSub}]),
							Flag = purview_check_do(Type, Code, CodeSub),
							ets:insert(?ets_web_purview_check, {{Path,Type}, Flag}),
							Flag
					end
			end
	end.

%% 根据账号类型得到原始菜单数据
purview(Type) ->
	[{Type, Menus, MenuHeaders}] = ets:lookup(?ets_web_purview_data, Type),
	{Menus, MenuHeaders}.

%% 菜单数据初始化(根据权限类型)
menu_init() ->
	ets:insert(?ets_web_purview_data, [
		begin
			Menus		= menu_init(UserType),
			MenuHeaders	= web_menu:purview_headers(Menus),
			{UserType, Menus, MenuHeaders}
		end
		|| UserType <- maps:keys(?adm_user_types_desc)]),
	ok.

menu_init(UserType) ->
	Fun = fun
			  (#{sub:=Sub} = Purview, PurviewsAcc) ->
				  Fun2 = fun
							 (#{key:=Keys} = Menu, MenusAcc) ->
								 case lists:member(UserType, Keys) orelse Keys =:= [] of
									 true ->
										 MenusAcc ++ [Menu];
									 false ->
										 MenusAcc
								 end;
							 (#{data:=Data} = Menu, MenusAcc) ->
								 Fun3 = fun
											(#{key:=SubKeys} = SubMenu, SubMenusAcc) ->
												case lists:member(UserType, SubKeys)  orelse SubKeys =:= [] of
													true ->
														SubMenusAcc ++ [SubMenu];
													false ->
														SubMenusAcc
												end
										end,
								 case lists:foldl(Fun3, [], Data) of
									 [] ->
										 MenusAcc;
									 Data2 ->
										 Menu2 = Menu#{data=>Data2},
										 MenusAcc ++ [Menu2]
								 end
						 end,
				  case lists:foldl(Fun2, [], Sub) of
					  [] ->
						  PurviewsAcc;
					  Sub2 ->
						  Purview2 = Purview#{sub=>Sub2},
						  PurviewsAcc ++ [Purview2]
				  end
		  end,
	lists:foldl(Fun, [], ?web_menus).



%% 菜单导航数据
purview_headers(Menus) ->
	jsx:encode([Code || #{code := Code} <- Menus]).

purview_check_do(Type, Code, CodeSub) ->
	{Menus, _MenuHeaders} = web_menu:purview(Type),
	%?INFO("Menus:~p", [Menus]),
	case purview_check_menu(Code, CodeSub, Menus) of
		true ->
			%?INFO("~p", [{Type, Code, CodeSub}]),
			true;
		false ->
			%?INFO("~p", [{Type, Code, CodeSub}]),
			CodeSub =:= index
	end.

purview_check_menu(Code, CodeSub, [#{code:=Code,sub:=Sub}|_]) ->
	Fun = fun
			  (#{data:=Data}) ->
				  Fun2 = fun
							 (#{code_sub:=CodeSubXX}) ->
								 CodeSub =:= CodeSubXX
						 end,
				  lists:any(Fun2, Data);
			  (#{code_sub:=CodeSubXX}) ->
				  CodeSub =:= CodeSubXX
		  end,
	lists:any(Fun, Sub);
purview_check_menu(Code, CodeSub, [_Purview|Purviews]) ->
	purview_check_menu(Code, CodeSub, Purviews);
purview_check_menu(_Code, _CodeSub, []) ->
	false.

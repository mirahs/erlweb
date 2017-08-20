-module(xxweb_util).

-include("common.hrl"). 

-export([
		 rec2map/2,
		 
		 betweet/3,
		 betweet_his/2,
		 ceil/1,
		 int_unsigned/1,
		 float_format/2,
		 floor/1,
		 
		 to_atom/1,
		 to_binary/1,
		 to_float/1,
		 to_integer/1,
		 to_list/1,
		 to_tuple/1,
		 
		 uniform/0,
		 uniform/1,
		 rand/2,
		 rand_list/1,
		 rand_list/2,
		 rand_list_all/1,
		 rand_odds/2,
		 rand_percent/1,
		 odds_list/1,
		 odds_list/2,
		 odds_list_count/2,
		 odds_list_count_repeat/2,
		 odds_list_count_repeat/3,
		 odds_list_init/1,
		 odds_list_sum/1,
		 
		 for/3,
		 for/4,
		 map/2,
		 map_reduce/2,
		 unzip/1,
		 unzip3/1,
		 list_to_string/4,
		 lists_delete/2,
		 lists_keydelete/3,
		 lists_shuffle/1,
		 lists_merge/2,
		 lists_shuffle/2,
		 lists_split/2,
		 lists_group/1,
		 lists_intersect/2,
		 lists_dic_get/1,
		 lists_dic_put/2,
		 
		 db_decode/1,
		 db_encode/1,
		 bitstring_to_term/1,
		 term_to_bitstring/1,
		 string_to_term/1,
		 term_to_string/1,
		 
		 milliseconds/0,
		 seconds/0,
		 date/0,
		 time/0,
		 localtime/0,
		 localtime_tomorrow/0,
		 week/0,
		 week/3,
		 week_number/0,
		 week_number/3,
		 date_Ymd/0,
		 date_Ymd/1,
		 date_YmdE/0,
		 date_YmdE/1,
		 date_YmdH/0,
		 date_YmdH/1,
		 date_YmdHis/0,
		 date_YmdHi5/0,
		 datetime2timestamp/1,
		 datetime2timestamp/6,
		 seconds2localtime/1,
		 date_to_gregorian_days/1,
		 days_diff/2,
		 days_diff/3,
		 days_diff_second/2,
		 is_same_date/2,
		 is_same_week/2,
		 is_yesterday/1,
		 second_today_current/0,
		 seconds_today_tomorrow/1,
		
		 element2/2,
		 nth2/2,
		 md5/1,
		 bin_to_hex/1,
		 sub_atom/2,
		 list_to_atom/1,
		 post_list/2,
		 post_tuple/2,
		 
		 
		 ip/1,
		 sort/1,
		 sleep/1,
		 sleep/2,
		 core_count/0,
		 core_idx/0,
		 flush_buffer/0,
		 request_get/2
		 ]).



%% record to map
rec2map(Rec, Fields) ->
	FieldSize	= tuple_size(Rec),
	rec2map(Rec, Fields, FieldSize).

rec2map(Rec, Fields, FieldSize) ->
	rec2map(Rec, Fields, 2, FieldSize, #{}).

rec2map(_Rec, _Fields, Pos, PosMax, Map) when Pos > PosMax ->
	Map;
rec2map(Rec, Fields, Pos, PosMax, Map) ->
	Val		= element(Pos, Rec),
	Field	= lists:nth(Pos - 1, Fields),
	Map2	= Map#{Field=>Val},
	rec2map(Rec, Fields, Pos + 1, PosMax, Map2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 数学小函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 在指定时间内  开始时分秒  	结束时分秒
betweet_his({SH,SI,SS},{EH,EI,ES}) ->
	{H, I, S} = ?MODULE:time(),
	Now = H*3600+I*60+S,
	Now =:= betweet(Now, SH*3600+SI*60+SS, EH*3600+EI*60+ES).

%% betweet（a，b，c） 函数是一个限制函数，即，a是以b 为下限，c为上限
betweet(V, Min,_Max) when V =< Min -> Min;
betweet(V,_Min, Max) when V >= Max -> Max;
betweet(V,_Min,_Max) -> V.


%% 取整 大于X的最小整数
ceil(X) ->
    T = trunc(X),
	case X of
		T ->
			T;
		_ ->
			case X > 0 of
				?true ->
					T + 1;
				?false ->
					T
			end
	end.

%% 取整 小于X的最大整数
floor(X) ->
    T = trunc(X),
	case X of
		T ->
			T;
		_ ->
			case X > 0 of
				?true ->
					T;
				?false ->
					T - 1
			end
	end.


%% 取大于0的数 少于0为0
int_unsigned( I) when I > 0 -> I;
int_unsigned(_I) -> 0.

%% 保留 X位小数
float_format(FloatNumber, X) ->
	N = math:pow(10,X),
	round(FloatNumber * N) / N.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各种转换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% atom
to_atom(Msg) when is_atom(Msg) -> 
    Msg;
to_atom(Msg) when is_binary(Msg) -> 
	?MODULE:list_to_atom(binary_to_list(Msg));  
to_atom(Msg) when is_integer(Msg) ->
	?MODULE:list_to_atom(integer_to_list(Msg));
to_atom(Msg) when is_tuple(Msg) -> 
	?MODULE:list_to_atom(tuple_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
	Msg2 = list_to_binary(Msg),
	Msg3 = binary_to_list(Msg2),
    ?MODULE:list_to_atom(Msg3);
to_atom(_) ->
    ?MODULE:list_to_atom("").
%% list
to_list(Msg) when is_list(Msg) -> 
    Msg;
to_list(Msg) when is_atom(Msg) -> 
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) -> 
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) -> 
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) -> 
    float_to_list(Msg);
to_list(_) ->
    [].
%% binary
to_binary(Msg) when is_binary(Msg) -> 
    Msg;
to_binary(Msg) when is_atom(Msg) ->
	list_to_binary(atom_to_list(Msg));
to_binary(Msg) when is_list(Msg) -> 
	list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) -> 
	list_to_binary(integer_to_list(Msg));
to_binary(_Msg) ->
    <<>>.
%% float
to_float(Msg)->
	Msg2 = to_list(Msg),
	list_to_float(Msg2).
%% integer
to_integer(Msg) when is_integer(Msg) -> 
    Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
    list_to_integer(Msg);
to_integer(_Msg) ->
    0.
%% tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 随机数相关
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uniform(N) when is_integer(N), N >= 1 ->
    trunc(?MODULE:uniform() * N) + 1.

uniform() ->
	{A1, A2, A3} =
		case get(random_seed) of
			undefined ->
				crond_api:seed();
			Tuple ->
				Tuple
		end,
	B1 = (A1 * 171) rem 30269,
	B2 = (A2 * 172) rem 30307,
	B3 = (A3 * 170) rem 30323,
	put(random_seed, {B1,B2,B3}),
	R = A1/30269 + A2/30307 + A3/30323,
	R - trunc(R).

%% 产生一个介于Min到Max之间的随机整数
rand(Same, Same) ->
	Same; 
rand(N1, N2) -> 
	{Min,Max} = ?IF(N1 >= N2, {N2, N1}, {N1, N2}),
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    M 		  = Min - 1,
    ?MODULE:uniform(Max - M) + M.

%% 相当于在Percent（1~1w）之间抽奖
%% 返回 true  or false
rand_percent(Percent) when Percent >= ?CONST_PERCENT ->
	?true;
rand_percent(Percent) ->
	rand_odds(Percent, ?CONST_PERCENT).

%% 机率
%% Numerator   分子
%% Denominator 分母
rand_odds(Denominator, Denominator) ->
	?true;
rand_odds(Denominator, Numerator) when Denominator > Numerator ->
	rand_odds(Numerator, Denominator);
rand_odds(Numerator, Denominator)->
	Odds = ?MODULE:uniform(Denominator),
	Odds =< Numerator.

rand_list({OddsList, Denominator}) ->
	odds_list(OddsList, Denominator);
%% 从列表中随机取出一个数据(等概率) 
%% util:rand_list([a,b,c,d,e]).
rand_list([])->
	?null;
rand_list(List)->
	Len = length(List),
	Idx = ?MODULE:uniform(Len),
	lists:nth(Idx, List).

rand_list_all(List) ->
	rand_list_all(List, []).

rand_list_all([], ListAcc) ->
	ListAcc;
rand_list_all([{Value,Percent}|List], ListAcc) ->
	case rand_odds(Percent, ?CONST_PERCENT) of
		?true ->
			rand_list_all(List, [Value|ListAcc]);
		?false ->
			rand_list_all(List, ListAcc)
	end.

%% 从列表中随机取出多个数据(等概率) 
%% util:rand_list([a,b,c,d,e],3).
rand_list(List, Count) ->
	case length(List) =< Count of
		?true ->
			List;
		?false ->
			Fun= fun(_, {ListAcc, RandAcc}) -> 
						 L = rand_list(ListAcc),
						 {ListAcc -- [L], [L|RandAcc]}
				 end,
			{_, RandList} = lists:foldl(Fun, {List,[]}, lists:duplicate(Count, 0)),
			RandList
	end.
 
%% 随机一个物品 [{Value1, Odds1}|....]
%% return : null | Value
odds_list([]) ->
	?null;
odds_list(List) ->
	{OddsList, Denominator} = odds_list_init(List),
	odds_list(OddsList, Denominator).

%% 从列表中随机取出一个数据(配置概率)
%% util:odds_list(List, Denominator).
%% util:odds_list([{a,20},{b,45},{c,85},{d,90},{e,100}],100).
odds_list(OddsList, OddsListSum) ->
	Odds = ?MODULE:uniform(OddsListSum),
	case odds_list2(Odds, OddsList) of
		?null ->
			?null;
		Value ->
			Value
	end.

odds_list2(Odds, [{Value,ValueOdds}|_List]) when Odds =< ValueOdds ->
	Value;
odds_list2(Odds, [_|List]) ->
	odds_list2(Odds, List);
odds_list2(_Odds, []) ->
	?null.

%% 随机一个列表里面Count个(不重复)数据
%% 列表不同元素个数大于Count
%% util:odds_list_count([{1,1500},{2,1500},{3,1500},{4,1500},{5,1500},{6,2500}],3)
odds_list_count(List, Count) when is_list(List) ->
	case length(List) =< Count of
		?true->
			[ID || {ID,_} <- List];
		_->
			{OddsList, Denominator} = odds_list_init(List), 
			odds_list_count(OddsList, Denominator, List, Count, 0, [])
	end;
odds_list_count(_, _)->
	[].

odds_list_count([], _Denominator, _List, _Count, _Num, Acc)->
	Acc;
odds_list_count(_, _Denominator, _List, 0, _Num, Acc)->
	Acc;
odds_list_count(OddsList, Denominator, List, Count, Num, Acc)->
	OddsRs = odds_list(OddsList, Denominator),
	Num2   = Num + 1,
	if
		Num2 == Count ->
			[OddsRs|Acc];
		?true ->
			List2					  = lists_keydelete(OddsRs, 1, List),
			{OddsList2, Denominator2} = odds_list_init(List2),
			odds_list_count(OddsList2, Denominator2, List2, Count, Num2, [OddsRs|Acc])
	end.

%% 随机一个列表里面Count个(可重复)数据
%% util:odds_list_count_repeat([{1,1500},{2,1500},{3,1500},{4,1500},{5,1500},{6,2500}],3)
odds_list_count_repeat(List, Count) when is_list(List) ->
	{OddsList, Denominator} = odds_list_init(List),
	odds_list_count_repeat(OddsList, Denominator, Count, 0, []).

odds_list_count_repeat(OddsList, Denominator, Count) ->
	odds_list_count_repeat(OddsList, Denominator, Count, 0, []).

odds_list_count_repeat(OddsList, Denominator, Count, Num, Acc)->
	OddsRs = odds_list(OddsList,Denominator),
	Num2   = Num + 1,
	?IF(Num2 == Count, [OddsRs|Acc], odds_list_count_repeat(OddsList,Denominator,Count,Num2,[OddsRs|Acc])).
 
%% 随机列表初始化
%% odds_api:odds_list_init(?MODULE, ?LINE, [{a,20},{b,25},{c,40},{d,5},{e,10}], 100).
%% {List, Denominator} =:= {[{a,20},{b,45},{c,85},{d,90},{e,100}],100}
odds_list_init(List) ->
	Fun = fun({_Value, 0}, Acc) ->
				  Acc;
			 ({Value, Odds}, {Acc, OddsAcc}) ->
				  NewOdds = Odds + OddsAcc,
				  {[{Value, NewOdds}|Acc], NewOdds}
		  end,
	{List2, Denominator} = lists:foldl(Fun, {[], 0}, List),
	{lists:reverse(List2), Denominator}.

%% 计算列表中概率总和
odds_list_sum(L) -> 
	odds_list_sum(L, 0).

odds_list_sum([{_Id, Odds}|T], Sum) -> 
	odds_list_sum(T, Sum + Odds);
odds_list_sum([], Sum) -> 
	Sum.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% List相关
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% for
for(I,  Max,_F) when I > Max ->
	[];
for(Max,Max, F) -> 
	[F(Max)];
for(I,  Max, F) -> 
	[F(I)|for(I+1,Max,F)].

%% 带返回状态的for循环
%% @return {ok, State}
for(Max, Min, _F, State) when Min<Max -> 
	{?ok, State};
for(Max, Max, F, State) -> 
	F(Max, State);
for(I, Max, F, State)   -> 
	{?ok, NewState} = F(I, State), 
	for(I+1, Max, F, NewState).

%% map 结果是倒序的
map(F, L) ->
	map(F, L, []).

map(_, [], R) ->
	R;
map(F, [H|T], R) ->
	map(F, T, [F(H)|R]).

%% 在处理大量重复任务的时候，为了加快速度，通常会用map-reduce的方式
map_reduce(F, L) ->
	ParentPid = self(),
	Ref 	  = make_ref(),
	[receive {Ref, Result} -> Result end
	 || _ <- [spawn(fun() -> ParentPid ! {Ref, F(X)} end) || X <- L]].

%% 
unzip(Ts) -> unzip(Ts, [], []).
unzip([{X, Y} | Ts], Xs, Ys) -> unzip(Ts, [X | Xs], [Y | Ys]);
unzip([], Xs, Ys) -> {Xs, Ys}.
%% 
unzip3(Ts) -> unzip3(Ts, [], [], []).
unzip3([{X, Y, Z} | Ts], Xs, Ys, Zs) -> unzip3(Ts, [X | Xs], [Y | Ys], [Z | Zs]);
unzip3([], Xs, Ys, Zs) -> {Xs, Ys, Zs}.



%% %% 在List中的每两个元素之间插入一个分隔符
%% implode(_S, [])-> 
%% 	[<<>>];
%% implode(S, L) when is_list(L) ->
%%     implode(S, L, []).
%% implode(_S, [H], NList) ->
%%     lists:reverse([to_list(H) | NList]);
%% implode(S, [H | T], NList) ->
%%     L = [to_list(H) | NList],
%%     implode(S, T, [S | L]).
%% 
%% %% 字符->列
%% explode(S, B)->
%%     re:split(B, S, [{return, list}]).
%% explode_int(S, B) ->
%%     [list_to_integer(Str) || Str <- explode(S, B), length(Str) > 0].

%% 数组转成字符串
%% List -> String 
%% H 附加在开头
%% M 夹在中间
%% T 附加在尾部
list_to_string([],_H,_M,_T) -> [];
list_to_string([HList|TList], H, M,T)     -> list_to_string(TList,H,M,T,H++to_list(HList)).
list_to_string([],           _H,_M,T,Str) -> Str++T;
list_to_string([HList|TList], H, M,T,Str) -> list_to_string(TList,H,M,T,Str++M++to_list(HList)).


%% 删除列表指定的所有相同元素
lists_delete(K,[K|L]) -> 
	lists_delete(K,L); 
lists_delete(K,[H|L])->
	[H|lists_delete(K,L)];
lists_delete(_,[])->
	[].

%% 删除所有
lists_keydelete(K, N, L) when is_integer(N) andalso N > 0 ->
    lists_keydelete2(K, N, L).
lists_keydelete2(Key, N, [H|T]) when element(N, H) =:= Key -> 
	lists_keydelete2(Key, N, T);
lists_keydelete2(Key, N, [H|T]) ->
    [H|lists_keydelete2(Key, N, T)];
lists_keydelete2(_, _, []) -> 
	[].


%% 本函数打乱（随机排列单元的顺序）一个数组。 
lists_shuffle(List)-> 
	lists_shuffle(List,[]).
lists_shuffle([],RsList)-> 
	RsList;
lists_shuffle([H|List],RsList)->
	M	= ?MODULE:uniform(97),
	if  
		M > 47 -> lists_shuffle(List,[H|RsList]);
		?true  -> lists_shuffle(List,RsList ++ [H])
	end.

%% 返回：把List分若干个成长Len为List2组成的数组 
lists_split(List,Len)->	
	lists_split(List,[],Len).
lists_split(List,Rs,Len)->
	if
		Len =< length(List) ->
			{H,List2} = lists:split(Len, List),
			lists_split(List2,[H|Rs],Len);
		?true ->
			[List|Rs]
	end.

	

%% 合并两个列表
lists_merge(List, [H|T]) -> 
	lists_merge([H|List], T);
lists_merge(List, []) -> 
	List.

%% 获取列表元素的个数
%% 返回：[{Id,Num} | ...]
%% 例：lists_id_num([1,2,3,3,2]) -> [{1,1},{2,2},{3,2}]
lists_group(List) ->
	lists_group(List,[]).

lists_group([H|T],AccOld) ->
	Fun = fun(H1,{Acc,AccCount}) ->
				  case H1 of
					  H ->
						  {Acc,AccCount + 1};
					  _->
						  {[H1|Acc],AccCount}
				  end
		  end,
	{NewT,Count}	= lists:foldl(Fun,{[],1},T),
	lists_group(NewT,[{H,Count} | AccOld]);
lists_group([],Acc) ->
	Acc.

%% 获取两个列表的交集
lists_intersect(L1,L2) ->
	Le1 = length(L1),
	Le2 = length(L2),
	if
		Le1 >= Le2 ->
			lists_intersect2(L2,L1);
		?true ->
			lists_intersect2(L1,L2)
	end.
lists_intersect2(L1,L2) ->
	[E || E<-L1,lists:member(E, L2)].



lists_dic_get(Key)->
	case get(Key) of
		?undefined 	-> [];
		L 			-> L
	end.

lists_dic_put(Key,Data)->
	case get(Key) of
		?undefined 	-> 
			put(Key,[Data]);
		L 			-> 
			put(Key,[Data|L])
	end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 数据转换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 返回 Bin 
db_encode(Bin) when is_binary(Bin)->
	Bin0	= zlib:compress(Bin),
	{binary,  iolist_to_binary("0x"++util:bin_to_hex(Bin0))  };
db_encode(Data)->
	Bin1	= term_to_binary(Data),
	Bin0	= zlib:compress(Bin1),
	{binary,  iolist_to_binary("0x"++util:bin_to_hex(Bin0))  }.

%% 返回 Data
db_decode(Bin) when is_binary(Bin) ->
	Bin1	= zlib:uncompress(Bin),
	binary_to_term(Bin1);
db_decode(Data) -> Data.


%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
    % binary_to_list(list_to_binary(io_lib:format("~w", [Term]))).
	binary_to_list(term_to_bitstring(Term)).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
	case erl_scan:string(String ++ ".") of
		{?ok, Tokens, _} ->
			case erl_parse:parse_term(Tokens) of
				{?ok, Term} ->
					Term;
				_Err ->
					?null 
			end;
		_Error ->
			?null
	end.

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
    % erlang:list_to_bitstring(io_lib:format("~w", [Term])).
	iolist_to_binary(io_lib:write(Term)).

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(?undefined) ->
	?undefined;
bitstring_to_term(BitString) ->
    string_to_term(binary_to_list(BitString)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 时间日期
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_now() ->
	os:timestamp().

milliseconds() ->
	{_M, S, U}  = time_now(),
    1000 * S + trunc(U / 1000).

%% 1970年1月1日到现在的秒数
seconds() ->
	{MegaSecs2, Secs2, _MicroSecs2} = os:timestamp(),
	MegaSecs2 * 1000000 + Secs2.

% {H,I,S}
time() ->
	{_Date, Time} = calendar:now_to_local_time(time_now()),
	Time.

% {Y,M,D}
date()->
	{Date, _Time} = calendar:now_to_local_time(time_now()),
	Date.
	
% {{Y,M,D},{H,I,S}}
localtime() ->
	calendar:now_to_local_time(time_now()).

%% 今天是星期几
week() ->
	Date = ?MODULE:date(),
	calendar:day_of_the_week(Date).

%% Y年M月D日是星期几
week(Y,M,D) -> 
	Date = {Y,M,D},
	calendar:day_of_the_week(Date).

%% 今天属于本年的第几周
week_number() ->
	Date = ?MODULE:date(), 
	calendar:iso_week_number(Date).

%% 某年某月某日属于某年的第几周
week_number(Y, M, D) ->
	Date = {Y,M,D},
	calendar:iso_week_number(Date).

%% 得到现在日期
date_Ymd() ->
	{Y,M,D} = ?MODULE:date(),
	to_list(Y) ++ date_format(M) ++ date_format(D).

date_Ymd(Seconds) ->
	{{Y,M,D},{_H,_I,_S}} = seconds2localtime(Seconds),
	to_list(Y) ++ date_format(M) ++ date_format(D).

date_YmdE() ->
	{Y,M,D} = ?MODULE:date(),
	to_list(Y) ++ "-" ++ date_format(M) ++ "-" ++ date_format(D).

date_YmdE(Seconds) ->
	{{Y,M,D},{_H,_I,_S}} = seconds2localtime(Seconds),
	to_list(Y) ++ "-" ++ date_format(M) ++ "-" ++ date_format(D).



%% util:localtime().
date_YmdH(Seconds) ->
	{{Y,M,D},{H,_I,_S}} =  seconds2localtime(Seconds),
	to_list(Y) ++ date_format(M) ++ date_format(D) ++ date_format(H).
date_YmdH() ->
	{{Y,M,D},{H,_I,_S}} = ?MODULE:localtime(),
	to_list(Y) ++ date_format(M) ++ date_format(D) ++ date_format(H).

%% 每五分钟递增
date_YmdHis() ->
	{{Y,M,D}, {H,I,S}} = ?MODULE:localtime(),
	to_list(Y) ++ date_format(M) ++ date_format(D) ++ date_format(H) ++ date_format(I) ++ date_format(S).

%% 每五分钟递增
date_YmdHi5() ->
	{{Y,M,D},{H,I,_S}} = ?MODULE:localtime(),
	to_list(Y) ++ date_format(M) ++ date_format(D) ++ date_format(H) ++ date_format((I div 5) * 5).


date_format(D) ->
	case D < 10 of
		?true ->
			"0" ++ to_list(D);
		?false ->
			to_list(D)
	end.


%% 通过datetime获取时间戳 
%% util:datetime2timestamp(<<"2011-12-9 10:00:09">>).
%% util:datetime2timestamp("2011-12-9 10:00:09").
%% 返回：1285286400
datetime2timestamp(Datetime) when is_binary(Datetime) ->
	Datetime2 = binary_to_list(Datetime),
	datetime2timestamp(Datetime2);
datetime2timestamp(Datetime) when is_list(Datetime) ->
	case string:tokens(Datetime, " ") of
		[Date, Time] -> ?ok;
		[Date] -> Time = []
	end,			
	case string:tokens(Date, "-") of
		[Y1,M1,D1] ->
			Y = list_to_integer(Y1),
			M = list_to_integer(M1),
			D = list_to_integer(D1);
		_ ->
			Y = 1970, M = 1, D = 1
	end,
	case string:tokens(Time, ":") of
		[H1,I1,S1] ->
			H = list_to_integer(H1),
			I = list_to_integer(I1),
			S = list_to_integer(S1);
		[H1,I1] ->
			H = list_to_integer(H1),
			I = list_to_integer(I1),
			S = 0;
		[H1] ->
			H = list_to_integer(H1),
			I = 0,
			S = 0;
		_ ->
			H = 0,
			I = 0,
			S = 0
	end,
	datetime2timestamp(Y, M, D, H, I, S).
	
datetime2timestamp(Y, M, D, H, I, S) ->
	% ?INFO("----------------------- ~w~n",[{Y, M, D, H, I, S}]),
	UniversalTime = erlang:localtime_to_universaltime({{Y, M, D}, {H, I, S}}),
	Seconds 	  = calendar:datetime_to_gregorian_seconds(UniversalTime),
	TimeGMT 	  = 62167219200,
	Seconds - TimeGMT.

%% 根据1970年以来的秒数获得日期
seconds2localtime(Seconds) ->
	Seconds2 = util:to_integer(Seconds),
    DateTime = calendar:gregorian_seconds_to_datetime(Seconds2 + ?DIFF_SECONDS_0000_1900),
    calendar:universal_time_to_local_time(DateTime).

%% 自1970年以来的天数
date_to_gregorian_days(Date) ->
	calendar:date_to_gregorian_days(Date).
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

%% 明天
localtime_tomorrow() ->
	Seconds = seconds() + ?CONST_DAY_SECONDS,
	seconds2localtime(Seconds).

%% 查看date是否为昨天
%% Date :: {Y, M, D}
is_yesterday(Date) ->
	ToDays  = calendar:date_to_gregorian_days(?MODULE:date()),
	Days	= calendar:date_to_gregorian_days(Date),
	ToDays - Days =:= 1.

%% 判断是否同一天
is_same_date(Seconds1, Seconds2) ->
    {Date1, _Time1} = seconds2localtime(Seconds1),
    {Date2, _Time2} = seconds2localtime(Seconds2),
	Date1 =:= Date2.


%% 判断是否同一星期
is_same_week(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, Time1} = seconds2localtime(Seconds1),
    % 星期几
    Week1  = calendar:day_of_the_week(Year1, Month1, Day1),
    % 从午夜到现在的秒数
    Diff1  = calendar:time_to_seconds(Time1),
    Monday = Seconds1 - Diff1 - (Week1-1)*?CONST_DAY_SECONDS,
    Sunday = Seconds1 + (?CONST_DAY_SECONDS-Diff1) + (7-Week1)*?CONST_DAY_SECONDS,
    (Seconds2 >= Monday) andalso (Seconds2 < Sunday).

%% 获取当天0点和第二天0点
seconds_today_tomorrow(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds2localtime(Seconds),
    % 从午夜到现在的秒数
    Diff   = calendar:time_to_seconds(Time),
    % 获取当天0点
    Today  = Seconds - Diff,
    % 获取第二天0点
    NextDay = Seconds + (?CONST_DAY_SECONDS-Diff),
    {Today, NextDay}.

%% 获取从午夜到现在的秒数
second_today_current() ->
	{_, Time} = calendar:now_to_local_time(time_now()),
	NowSec 	  = calendar:time_to_seconds(Time),
	NowSec.


%% 计算相差的天数(用自然天)
days_diff(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _} = seconds2localtime(Seconds1),
    {{Year2, Month2, Day2}, _} = seconds2localtime(Seconds2),
    Days1 = calendar:date_to_gregorian_days(Year1, Month1, Day1),
    Days2 = calendar:date_to_gregorian_days(Year2, Month2, Day2),
	abs(Days2-Days1).

%% 计算相差的天数(用H：小时 0-23)
days_diff(Seconds1, Seconds2, H) ->
	{Date1, {H1, _M1, _S1}} = util:seconds2localtime(Seconds1),
	{Date2, {H2, _M2, _S2}} = util:seconds2localtime(Seconds2),
	DaysTem1 = calendar:date_to_gregorian_days(Date1),
	DaysTem2 = calendar:date_to_gregorian_days(Date2),
	Days1 = ?IF(H1 >= H, DaysTem1, DaysTem1 - 1),
	Days2 = ?IF(H2 >= H, DaysTem2, DaysTem2 - 1),
	abs(Days2 - Days1).

%% 计算相差的天数(用秒)
days_diff_second(Seconds1, Seconds2) ->
	DateSeconds = ?CONST_DAY_SECONDS,
	DifSeconds  = abs(Seconds2 - Seconds1),
	DifSeconds div DateSeconds.





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 系统加强
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 获取Tuple第N个元素
element2(N,Tuple)
  when is_tuple(Tuple) andalso N < size(Tuple)->
	element(N, Tuple);
element2(_N,_Tuple) ->
	{?error,	   bad_argument}.

%% 获取List第N个成员
%% 返回：{H,T}
nth2(N, L) ->
	nth2(N, L, []).
nth2(1, [H|T], Rs) -> 
	{H,         Rs ++ T};
nth2(N, [H|T], Rs) when N > 1 ->
    nth2(N - 1,	T, 	   [H|Rs]). 



%% Md5
md5(S) ->
	Md5= erlang:md5(S),
	bin_to_hex(Md5).
%% 二进制转16进制
bin_to_hex(Bin) ->
	List = binary_to_list(Bin),
	lists:flatten(list_to_hex(List)).
list_to_hex(L) -> 
	lists:map(fun(X) -> int_to_hex(X) end, L). 
int_to_hex(N) when N < 256 ->
	[hex(N div 16), hex(N rem 16)]. 
hex(N) when N < 10 -> 
	$0 + N;
hex(N) when N >= 10, N < 16 ->
	$a + (N-10).


%% list_to_existing_atom
list_to_atom(List)-> 
	try 
		erlang:list_to_existing_atom(List)
	catch _:_ ->
	 	erlang:list_to_atom(List)
	end.

%% 截取atom Len长度
sub_atom(Atom,Len)->
	?MODULE:list_to_atom(lists:sublist(atom_to_list(Atom),Len)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 功能扩展
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 获取元组中元素的位置
post_tuple(Mem, Tuple) ->
	TupleList = erlang:tuple_to_list(Tuple),
	post_list(Mem,TupleList).

%% 获取列表中元素的位置
post_list(Mem, TupleList) ->
	post_list(Mem,TupleList,1).

post_list(_Mem, [], _N) ->
	0;
post_list(Mem, [Mem|_], N) ->
	N;
post_list(Mem, [_|TupleList], N) ->
	post_list(Mem,TupleList,N + 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%% 获取IP
ip(Socket) ->	
	case inet:peername(Socket) of
		{?ok, {{Ip0,Ip1,Ip2,Ip3}, _Port}} ->
			util:to_list(Ip0) ++ "." ++ util:to_list(Ip1) ++ "." ++ util:to_list(Ip2) ++ "." ++ util:to_list(Ip3);
		_-> 
			"0.0.0.0"
	end.

%% 快速排序 
sort([]) ->
	[];
sort([H|T]) ->
	sort([X || X <-T, X < H]) ++ [H] ++ sort([X || X <- T, X >= H]).


%% 暂停(毫秒)
sleep(Msec) ->
	receive
		after Msec ->
				?true
	end.

sleep(Msec, Funs) ->
    receive
    	after Msec ->
				Funs()
    end.

%% 清空信箱
flush_buffer()->
	receive 
		_Any  -> flush_buffer()
	after 
			0 -> ?true
	end.

%% cpu核数
core_count() ->
	case get(schedulers) of
		?undefined 	->
			Cores = erlang:system_info(schedulers),
			put(schedulers, Cores),
			Cores;
		Cores ->
			Cores
	end.

%% 当前进程所运行在第几个核上
core_idx() ->
	case get(scheduler_id) of
		?undefined ->
			CoreIdx	= erlang:system_info(scheduler_id),
			put(scheduler_id,CoreIdx),
			CoreIdx;
		CoreIdx ->
			CoreIdx
	end.

%% 请求http
request_get(Url,Arguments)->
	case Arguments of
		[] ->
			Url2 = Url;
		_ ->
			Arguments2 = map(fun({K,V})->to_list(K)++"="++to_list(V) end, Arguments),
			Arguments3 = list_to_string(Arguments2, [], "&", []),
			case lists:member($?,Url) of
				?true ->
					Url2 = Url ++"&"++Arguments3;
				?false ->
					Url2 = Url ++"?"++Arguments3
			end
	end,
%  	?INFO("Url:~p",[Url2]),
	httpc:request(get, {Url2, []}, [], []).
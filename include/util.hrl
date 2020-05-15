-define(B(D),					    (erlweb_util:to_binary(D))/binary).

-define(TOU8B(Characters),			unicode:characters_to_binary(Characters)).
-define(TOI(Arg),					erlweb_util:to_integer(Arg)).
-define(TOB(Arg),					erlweb_util:to_binary(Arg)).
-define(TOA(Arg),					erlweb_util:to_atom(Arg)).
-define(TOL(Arg),					erlweb_util:to_list(Arg)).

-define(M2L(Arg),					maps:to_list(Arg)).
-define(MGET(K,M),					maps:get(K,M)).
-define(MGET(K,M,D),				maps:get(K,M,D)).

-define(PLGET(K,L),					proplists:get_value(K,L)).
-define(PLGET(K,L,D),				proplists:get_value(K,L,D)).

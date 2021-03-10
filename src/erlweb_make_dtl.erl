%% -*- coding: latin-1 -*-
-module(erlweb_make_dtl).

-export([
    start/0
]).

-include("erlweb.hrl").


%%%===================================================================
%%% API
%%%===================================================================

%% erl -pa deps/erlweb/ebin deps/erlydtl/ebin -s erlweb_make_dtl -s init stop -extra ./src/web/view
%% erl -pa deps/erlweb/ebin deps/erlydtl/ebin -s erlweb_make_dtl -s init stop -extra ./src/web/view ./ebin
%% erl -pa deps/erlweb/ebin deps/erlydtl/ebin -s erlweb_make_dtl -s init stop -extra ./src/web/view ./ebin  web_erlydtl_tag
start() ->
    case init:get_plain_arguments() of
        [] ->
            make("./src/web/view", "./ebin", undefined);
        [Dir] ->
            make(Dir, "./ebin", undefined);
        [Dir, OutDir] ->
            make(Dir, OutDir, undefined);
        [Dir, OutDir, CustomTag] ->
            make(Dir, OutDir, erlweb_util:to_atom(CustomTag))
    end.


%%%===================================================================
%%% Internal functions
%%%===================================================================

make(Dir, OutDir, CustomTags) ->
    CompileArgs = ?IF(CustomTags =:= undefined, [{out_dir, OutDir}], [{out_dir, OutDir}, {custom_tags_modules, [CustomTags]}]),
    {ok, FileList} = file:list_dir(Dir),
    Fun = fun
              (FileBaseName) ->
                  case FileBaseName of
                      "view_base.html" -> ok;
                      _ ->
                          FileName = Dir ++ "/" ++ FileBaseName,
                          case filelib:is_file(FileName) of
                              true ->
                                  case filename:extension(FileBaseName) of
                                      ".html" ->
                                          RootName	= filename:rootname(FileBaseName),
                                          RootNameA	= erlweb_util:to_atom(RootName),
                                          %?INFO("FileName : ~p RootNameA : ~p Opts : ~p~n", [FileName, RootNameA, Opts]),
                                          case erlydtl:compile_file(FileName, RootNameA, CompileArgs) of
                                              {ok, _} -> skip;
                                              error -> ?ERR("compile [~s] error", [FileBaseName]);
                                              {error, Errors, Warnings} ->
                                                  ?ERR("compile [~s] Errors:~p,Warnings:~p", [Errors, Warnings])
                                          end;
                                      _ -> skip
                                  end;
                              _ -> skip
                          end
                  end
          end,
    lists:foreach(Fun, FileList),
    ok.

# erlweb
erlweb by cowboy(2.0.0-pre.1), erlang(18.3)

[examples](https://github.com/mirahs/erlweb/tree/2.0.0-pre.1/examples)

如果出现: {[{reason,{badmatch,false}}, {mfa,{erlweb_handler,init,2}}, {stacktrace,[{cowboy_req,filter,2,[{file,"src/cowboy_req.erl"},{line,1265}]}, 找到deps/cowboy/src/cowboy_req.erl源文件第1265行 将true = maps:is_key(Key, Map)注释掉 %true = maps:is_key(Key, Map) 然后重新编译

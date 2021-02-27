#!/bin/bash
export PATH=/d/apps/erl9.2/bin:${PATH}

werl -pa ebin deps/*/ebin -boot start_sasl +P 1024000 -s hello &

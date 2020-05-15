#!/bin/bash
export PATH=/d/apps/erl9.2/bin:${PATH}

werl -pa ebin deps/*/ebin +P 1024000 -smp enable -s hello &

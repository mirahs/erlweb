#!/bin/bash
export PATH=/d/apps/erl7.3/bin:${PATH}

werl -pa ebin deps/*/ebin +P 1024000 -smp enable -s hello &

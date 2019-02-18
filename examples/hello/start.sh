#!/bin/bash
export PATH=/d/apps/erl10.2/bin:${PATH}


erl -pa ebin deps/*/ebin +P 1024000 -smp enable -s hello

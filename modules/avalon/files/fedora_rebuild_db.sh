#!/usr/bin/expect
 
set timeout 20

spawn "$env(FEDORA_HOME)/server/bin/fedora-rebuild.sh"
expect "Enter (1-3)"
send 2\r
expect "Enter (1-2)"
send 1\r
interact
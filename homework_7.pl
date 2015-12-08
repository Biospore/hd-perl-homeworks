#!/usr/bin/perl
use cmd;

cmd::bashcall(shift);
cmd::bashcall('cat cmd.pm');
cmd::bashcall('ls');
cmd::bashcall('ls -la');

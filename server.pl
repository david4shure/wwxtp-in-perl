#!/usr/bin/perl
use warnings;
use strict;
use Socket;
use autodie;
use v5.14;

my $port = 4114;
my $proto = getprotobyname('tcp');
socket(my $sock, AF_INET, SOCK_STREAM, $proto);
$SIG{__DIE__} = sub {close($sock); die($_[0])};
# this is a comment
my $listen_addr = INADDR_ANY;
say "bind...";
bind($sock, sockaddr_in($port, INADDR_ANY));
say "listen...";
listen($sock, SOMAXCONN);
say "waiting for a client then accept...";
accept(my $client_con, $sock);
say "recv()ing ...";
recv($client_con, my $buffer, 10000000, 0);
say "Client Message: $buffer ";
send($client_con, uc($buffer), 0);

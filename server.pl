#!/usr/bin/perl
use warnings;
use strict;
use Socket;
use autodie;
use v5.14;
use XML::LibXML;

sub error_response {
    my ($client_con, $mess) = @_;
    send($client_con, $mess, 0);
    die($mess);
}

my $port = 4114;
my $protocol = getprotobyname('tcp');
socket(my $sock, AF_INET, SOCK_STREAM, $protocol);
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
my $request = XML::LibXML->load_xml(string => $buffer);
$request->is_valid or error_response($client_con, "Your XML is not valid");
my @nodes = $request->getElementsByTagName("command");
@nodes == 1 or error_response($client_con, "You don't have the correct amount of <command> tags");
my $command = $nodes[0]->textContent;
$command eq 'RETRIEVE' or error_reponse($client_con, "This server only supports the 'RETRIEVE' command.");

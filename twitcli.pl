#!/usr/bin/perl
use warnings;
use strict;
use Term::ReadLine;
use Net::Twitter;
use Scalar::Util 'blessed';


my $term = Term::ReadLine->new('Twitcli app');
# my $prompt = "Enter Twitter username: ";
# my $OUT = $term->OUT || \*STDOUT;

my $consumer_key = '#your consumer key here';
my $consumer_secret = '#your consumer secret key';
my $access_token = '#your access token here';
my $access_token_secret = '#your access token secret here';

my $nt = Net::Twitter->new(
    traits => ['API::REST', 'OAuth'],
    consumer_key => $consumer_key,
    consumer_secret => $consumer_secret,
);

if ($access_token && $access_token_secret) {
  $nt->access_token($access_token);
  $nt->access_token_secret($access_token_secret);
}

unless ( $nt->authorized ) {
    # Not authed yet, so do it
   print "Authorize this app at ", $nt->get_authorization_url, " and enter the PIN#\n";

   my $pin = <STDIN>;
   chomp $pin;

   my ($access_token, $access_token_secret, $user_id, $screen_name) = $nt->request_access_token(verifier => $pin);
}

# my $result = $nt->update({ status => 'Testing from Twitcli, cli twitter client being developed by me'});

eval {
    my $statuses = $nt->friends_timeline({ count => 100 });
    for my $status ( @$statuses ) {
        print "$status->{created_at} <$status->{user}{screen_name}> $status->{text} \n";
    }
};


# while ( defined ($_ = $term->readline($prompt)) ) {
    # my $res = eval($_);
    #  warn $@ if $@;
    #  print $OUT $res, "\n" unless $@;
    # eval {
        # my $statuses = $nt->friends_timeline({ count => 100 });
        # for my $status ( @$statuses ) {
            # print "$status->{created_at} <$status->{user}{screen_name}> $status->{text} \n";
        # }
    # };
    # $term->addhistory($_) if /\S/;
# }

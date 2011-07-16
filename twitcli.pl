#!/usr/bin/perl
use warnings;
use strict;
use Term::ReadLine;
use Net::Twitter;
use Scalar::Util 'blessed';


my $term = Term::ReadLine->new('Twitcli app');
# my $prompt = "Enter Twitter username: ";
# my $OUT = $term->OUT || \*STDOUT;

my $consumer_key = 'DvzuC1tDRHqqTQuVQlZlg';
my $consumer_secret = 'af0ARNMHtYgaEVPNTXQS1wPtYCXC4Cf0IpWoNCqA4';
my $access_token = '125117278-VwGfrNyda3PtFiHqhaO2EdANBeu2ph6VL0JD7Fhf';
my $access_token_secret = 'YOkXcL6rL2yvD79J4MhsLALFxAXHvZdQEDhN9Nw0O1E';

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

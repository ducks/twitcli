#!/usr/bin/perl
use warnings;
use strict;
use Term::ReadLine;
use Net::Twitter;
use Scalar::Util 'blessed';
use File::HomeDir;
use YAML::XS;
use Data::Dumper;
use feature 'say';

my $home_dir = File::HomeDir->my_home;
my $term = Term::ReadLine->new('Twitcli app');
# my $prompt = "Enter Twitter username: ";
# my $OUT = $term->OUT || \*STDOUT;

my $consumer_key = 'DvzuC1tDRHqqTQuVQlZlg';
my $consumer_secret = 'af0ARNMHtYgaEVPNTXQS1wPtYCXC4Cf0IpWoNCqA4';



my $nt = Net::Twitter->new(
    traits => ['API::REST', 'OAuth'],
    consumer_key => $consumer_key,
    consumer_secret => $consumer_secret,
);

# check for file existence because otherwise the access tokens are not present - don't know if this is a best practice, need feedback
if (-e "$home_dir/.twitcli") {
  my $twitter_config = YAML::XS::LoadFile( "$home_dir/.twitcli" );
  # say Dumper($twitter_config);
  if ($twitter_config->{'twitter_access_token'} && $twitter_config->{'twitter_access_token_secret'}) {   
     $nt->access_token($twitter_config->{'twitter_access_token'});
     $nt->access_token_secret($twitter_config->{'twitter_access_token_secret'});
  }
}

unless ( $nt->authorized ) {
    # Not authed yet, so do it
   print "Authorize this app at ", $nt->get_authorization_url, " and enter the PIN #\n";
   my $pin = <STDIN>;
   chomp $pin;

   my ($access_token, $access_token_secret, $user_id, $screen_name) = $nt->request_access_token(verifier => $pin);

   YAML::XS::DumpFile( "$home_dir/.twitcli", { twitter_access_token => "$access_token", twitter_access_token_secret => "$access_token_secret" });
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

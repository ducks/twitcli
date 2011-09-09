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

my $command = '';

my $consumer_key = 'DvzuC1tDRHqqTQuVQlZlg';
my $consumer_secret = 'af0ARNMHtYgaEVPNTXQS1wPtYCXC4Cf0IpWoNCqA4';



my $nt = Net::Twitter->new(
    traits => ['API::REST', 'OAuth'],
    consumer_key => $consumer_key,
    consumer_secret => $consumer_secret,
);

  my $term = new Term::ReadLine 'twitcli$';
  my $status_command = 'status';
  my $update_command = 'update';



# check for file existence because otherwise the access tokens are not present - don't know if this is a best practice, need feedback
if (-e "$home_dir/.twitcli") {
  my $twitter_config = YAML::XS::LoadFile( "$home_dir/.twitcli" );
  if ($twitter_config->{'twitter_access_token'} && $twitter_config->{'twitter_access_token_secret'}) {   
     $nt->access_token($twitter_config->{'twitter_access_token'});
     $nt->access_token_secret($twitter_config->{'twitter_access_token_secret'});
  }
}

unless ( $nt->authorized ) {
    # Not authed yet, so do it
   print "Authorize this app at ", $nt->get_authorization_url, " and enter the PIN # ";
   my $pin = <STDIN>;
   chomp $pin;

   my ($access_token, $access_token_secret, $user_id, $screen_name) = $nt->request_access_token(verifier => $pin);

   YAML::XS::DumpFile( "$home_dir/.twitcli", { twitter_access_token => "$access_token", twitter_access_token_secret => "$access_token_secret" });
}


show_friends_timeline();

# subroutine to show your friends status updates in a timeline
sub show_friends_timeline {
  my $statuses = $nt->friends_timeline({ count => 100 });
  for my $status ( reverse(@$statuses) ) {
    print "$status->{created_at} <$status->{user}{screen_name}> $status->{text} \n";
  }
  twitcli_command_prompt();
}

# subroutine to update your status
sub update_status {
    print "Enter status: ";
    my $status_update = <STDIN>;
    $nt->update($status_update);
    twitcli_command_prompt();
}

# subroutine to show the twitcli command line prompt
sub twitcli_command_prompt {
  my $username = $nt->user_timeline();
  print "$username->[0]{user}{screen_name}\@twitcli\$ ";
  my $command = <STDIN>;

  if ( $command == 'update' ) {
    show_friends_timeline();
  }  
  
  if ( $command == 'status' ) {
    update_status();
  }
}

#!/usr/bin/perl

use strict;
use warnings;

use Curses;
use Curses::UI;
use Encode;
use Net::Twitter;
use Scalar::Util 'blessed';
use File::HomeDir;
use YAML::XS;

initscr();




getmaxyx(my $row, my $col);

my $home_dir = File::HomeDir->my_home;
my $consumer_key = 'DvzuC1tDRHqqTQuVQlZlg';
my $consumer_secret = 'af0ARNMHtYgaEVPNTXQS1wPtYCXC4Cf0IpWoNCqA4';

my $nt = Net::Twitter->new(
  traits => ['API::REST', 'OAuth', 'InflateObjects'],
  consumer_key => $consumer_key,
  consumer_secret => $consumer_secret
);

if (-e "$home_dir/.twitcli") {
  my $twitter_config = YAML::XS::LoadFile( "$home_dir/.twitcli" );
  if ($twitter_config->{'twitter_access_token'} && $twitter_config->{'twitter_access_token_secret'}) {   
     $nt->access_token($twitter_config->{'twitter_access_token'});
     $nt->access_token_secret($twitter_config->{'twitter_access_token_secret'});
  }
}

my $menu_height = $row - 1;
my $menu_width = $col / 2;
my $menu_start_x = $col / 2;
my $menu_start_y = 0;

my $info_height = $row - 1;
my $info_width = $col / 2;
my $info_start_x = 0;
my $info_start_y = 0;

my $menu_win = create_window($menu_height, $menu_width, $menu_start_y, $menu_start_x);
my $info_win = create_window($info_height, $info_width, $info_start_y, $info_start_x);


# wprintw($info_win, &show_friends_timeline());
print &$menu_win;
print &$info_win;
# wfreshw($info_win);
# $menu_win->addstr( 0, 0, 'heyoh');
# my $cui = new Curses::UI(
  # -color_support => 1
# );

# my $window = $cui->add(
  # 'main_window',
  # 'Window'
# );

# my $timeline_container = $window->add(
  # 'timeline_container',
  # 'Container'
# );

# my $timeline_viewer = $timeline_container->add(
  # 'timeline_viewer',
  # 'TextViewer',
  # -text => &show_friends_timeline()
# );

&show_friends_timeline();
# my $timeline_container = $window->add(
  # 'timeline_container',
  # 'Container',
  # -text => &show_friends_timeline()
# );
# $menu_win->addstr(0, 0, "hello world, bitch");
# $menu_win->refresh();
# $menu_win->addstr(0, 0, 'hey');
# box( $menu_win, 0, 0);

# printw("Type a character to see it in bold\n");
# $ch = getch();

# if ($ch == KEY_F(1)) {
#  printw("F1 Key pressed");
# }
# else {
#  printw("The pressed key is ");
#  attron(A_BOLD);
#  printw($ch);
#  attroff(A_BOLD);
# }


# getmaxyx($row, $col);
# addstr($row / 2, ($col - length($mesg)) / 2, $mesg);
# addstr($row - 2, 0, "This screen has $row rows and $col columns\n");


refresh();
# getch();
endwin();

sub create_window {
  my $local_window = newwin(shift, shift, shift, shift);
  box($local_window, 0, 0);
  refresh($local_window);
  return $local_window;
}

sub show_friends_timeline {
  # eval {
    my $statuses = $nt->friends_timeline({ count => 10 });
    for my $status ( @$statuses ) {
      my $twitter_posts =  "$status->{created_at} $status->{user}{screen_name} $status->{text}\r";
    }
    wprintw($info_win, $twitter_posts);
  # };
  # if ( my $err = $@ ) {
   # warn $err->error;  
  # }
}



#!/usr/bin/perl
use strict;
use warnings;
do 'commands/helper.pl';

our $message_dir = '/home/henzell/henzell/dat/messages';

sub cleanse_nick
{
  my $nick = lc(shift);
  $nick =~ y/a-z0-9_//cd;
  return $nick;
}

sub message_count
{
  my $nick = cleanse_nick(shift);
  open my $handle, '<', "$message_dir/$nick" or return 0;
  binmode $handle, ':utf8';
  my @messages = <$handle>;
  return scalar @messages;
}

sub message_handle
{
  my ($nick, $mode, $error) = @_;
  $nick = cleanse_nick($nick);
  open my $handle, $mode, "$message_dir/$nick" or do
  {
    print "$error\n";
    exit;
  };
  binmode $handle, ':utf8';
  return $handle;
}

sub message_clear
{
  my $nick = cleanse_nick(shift);
  system("rm '$message_dir/$nick'");
}

sub message_notify
{
  my $nick = cleanse_nick(shift);
  my $reset = shift;

  if ($reset)
  {
    chmod 0666, "$message_dir/$nick";
    return;
  }

  # if the message file has +x set, then don't notify
  return 0 if -x "$message_dir/$nick";
  chmod 0777, "$message_dir/$nick";
  return 1;
}

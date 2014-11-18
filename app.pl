#!/usr/bin/env perl
use Mojolicious::Lite;
use MyLib::Controller;
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);
use POSIX qw(strftime);


get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello, I am here!');
};

get '/test' => sub {
  my $c = shift;
  $c->render(json => {foo => [1, 'test', 3]});
};

$\ = "\n";
post '/log' => sub {
  my $c = shift;

  my @time = localtime;
  my $log = strftime "%Y-%m-%d", @time;

  open my $fh, ">>", "$log.log";
  print $fh encode_json({
    datetime => strftime("%Y-%m-%dT%H:%M:%S", @time)
    ,headers => $c->req->headers->{headers}
    ,body => $c->req->json 
  });
  close $fh;
  $c->render(json => {res=> 'Ok'});
};
app->controller_class('MyLib::Controller');
app->start;

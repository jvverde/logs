#!/usr/bin/env perl
use Mojolicious::Lite;
use MyLib::Controller;
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);
use POSIX qw(strftime);

options '*' => sub {
  my $self = shift;
  $self->respond_to(any => { data => '', status => 200 });
};

get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello, I am here!');
};

get '/test' => sub {
  my $c = shift;
  $c->render(json => {foo => [1, 'test ols222', 3]});
};

$\ = "\n";

post '/log' => sub {
  my $c = shift;

  my @time = localtime;
  my $log = strftime "%Y-%m-%d", @time;

  open my $fh, ">>", "./data/$log.log";
  print $fh encode_json({
    datetime => strftime("%Y-%m-%dT%H:%M:%S", @time)
    ,headers => $c->req->headers->{headers}
    ,body => $c->req->json 
  });
  close $fh;
  $c->render(json => {res=> 'Ok'});
};

get '/log/:filename/:number' => {
  number => 0
  , filename => strftime "%Y-%m-%d", localtime
} => sub{
  my $c = shift;
  my $log = $c->param('filename');
  open my $fh, "<", "./data/$log.log";
  my @lines = <$fh>;
  close $fh;
  my $n = $c->param('number') || 0;
  $c->render(text => ($lines[$n] || '{}'), format => 'json');
};

app->controller_class('MyLib::Controller');
app->plugin( 'Mojolicious::Plugin::CORS' );
app->start;

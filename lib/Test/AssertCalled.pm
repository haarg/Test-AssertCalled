package Test::AssertCalled;
use strict;
use warnings;
use B;

use base qw(Test::Builder::Module);

our @asserters;

sub import {
  my $caller = caller;
  my %assert = (
    package => $caller,
  );
  my $asserter = $assert{asserter} = sub () {
    my ($pack, $file, $line) = caller;
    $assert{called}{$file}{$line}++;
  };
  push @asserters, \%assert;
  no strict 'refs';
  my $glob = \*{"${caller}::assert_called"};
  $assert{glob} = $glob;
  *$glob = $asserter;
  return;
}

END {
  my $builder;
  for my $asserter (@asserters) {
    $builder ||= __PACKAGE__->builder;
    my $calls = () = map { values $_ } values %{ $asserter->{called} };
    my $locations = B::svref_2object($asserter->{glob})->REFCNT - 2;
    $builder->ok($locations == $calls, "every assert location called in $asserter->{package}")
      or $builder->diag("Found $calls calls for $locations asserts existing");
  }
}

1;


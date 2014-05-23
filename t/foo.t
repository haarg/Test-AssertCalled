use strict;
use warnings;
use Test::More;

use Test::AssertCalled;

assert_called;
assert_called;
assert_called;
assert_called;
assert_called;
assert_called;
assert_called;
assert_called;
sub foo {
  assert_called;
  assert_called;
  assert_called;
}
foo();
ok 1;

done_testing;

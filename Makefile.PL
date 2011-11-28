use inc::Module::Install;
name 'Plack-Middleware-Static-I18N';
all_from 'lib/Plack/Middleware/Static/I18N.pm';

requires 'Plack';
requires 'I18N::AcceptLanguage';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

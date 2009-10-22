
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'PostScript-File',
  NAME      => 'PostScript::File',
  AUTHOR    => "Christopher\ Willmot\ \<chris\@willmot\.co\.uk\>\,\ Christopher\ J\.\ Madsen\ \<perl\@cjmweb\.net\>",
  ABSTRACT  => "Base\ class\ for\ creating\ Adobe\ PostScript\ files",
  VERSION   => '1.04',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "File::Spec" => '0',
    "File::Temp" => '0',
    "Sys::Hostname" => '0',
  },
  test => {TESTS => 't/*.t'}
);


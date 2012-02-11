
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Class for creating Adobe PostScript files",
  "AUTHOR" => "Christopher J. Madsen <perl\@cjmweb.net>",
  "BUILD_REQUIRES" => {
    "FindBin" => 0,
    "List::Util" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "PostScript-File",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "PostScript::File",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Encode" => "2.21",
    "Exporter" => "5.57",
    "File::Spec" => 0,
    "Scalar::Util" => 0,
    "Sys::Hostname" => 0
  },
  "VERSION" => "2.20",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);





use strict;
use warnings;

 BEGIN { require 5.8.0; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'PostScript::File',
                       'DISTNAME' => 'PostScript-File',
                       'AUTHOR' => 'Christopher J. Madsen <perl@cjmweb.net>',
                       'ABSTRACT' => 'Base class for creating Adobe PostScript files',
                       'EXE_FILES' => [],
                       'VERSION' => '2.01',
                       'LICENSE' => 'perl',
                       'PREREQ_PM' => {
                                        'Scalar::Util' => '0',
                                        'ExtUtils::MakeMaker' => '6.11',
                                        'File::Spec' => '0',
                                        'Encode' => '2.21',
                                        'Carp' => '0',
                                        'Sys::Hostname' => '0'
                                      }
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);




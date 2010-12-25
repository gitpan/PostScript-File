#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2009 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 29 Oct 2009
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#=====================================================================
#
# This isn't really an example.  It's the program that generates the
# files in lib/PostScript/File/Metrics by loading the AFM files and
# dumping the results into modules.  You shouldn't need to run this
# yourself, but you could if for some reason your fonts don't match
# the metrics that are supplied with PostScript::File.
#---------------------------------------------------------------------

use 5.008;
use strict;
use warnings;

use autodie ':io';
use Data::Dumper;
use Path::Class;

use PostScript::File;
use PostScript::File::Metrics;
use PostScript::File::Metrics::Loader;

#=====================================================================
# Simple package for interpolating into strings:

{ package In_terpolation;

  sub TIEHASH { bless $_[1], $_[0] }
  sub FETCH   { $_[0]->($_[1]) }
} # end In_terpolation

our (%E, %D);
tie %E, 'In_terpolation', sub { $_[0] }; # eval
tie %D, 'In_terpolation', \&dump_term; # Data::Dumper

#=====================================================================
my $outDir = dir('lib');
die "where's $outDir\n" unless -d $outDir;

my @fonts = qw(
  Courier
  Courier-Bold
  Courier-BoldOblique
  Courier-Oblique
  Helvetica
  Helvetica-Bold
  Helvetica-BoldOblique
  Helvetica-Oblique
  Times-Bold
  Times-BoldItalic
  Times-Italic
  Times-Roman
); # end @fonts

my @encodings = qw( std cp1252 iso-8859-1 );

dump_font($_, \@encodings) for @fonts;
dump_font(Symbol => ['sym']);

#---------------------------------------------------------------------
sub dump_font
{
  my ($font, $encodings) = @_;

  # Load the AFM file and generate metrics for all encodings:
  PostScript::File::Metrics::Loader::load($font, $encodings);

  # Dump the encoding-independent information:
  my $info = dump_term($PostScript::File::Metrics::Info{$font});

  # Clean up the formatting a bit:
  $info =~ s{(?<='font_bbox' => \[)\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(?=\],)}
            { $1 $2 $3 $4 };

  # Now write out a module for each encoding:
  foreach my $encoding (@$encodings) {
    my $package = PostScript::File::Metrics::_get_package_name($font, $encoding);

    my $fn = $outDir->file(split /::/, "$package.pm");
    $fn->dir->mkpath(1);

    print "Writing $fn\n";
    open(my $out, '>', $fn);
    print $out <<"END HEADER";
# This file was generated by examples/generate_metrics.pl
#
# It is a data file for PostScript::File::Metrics, containing the
# metrics for $font in the $encoding encoding.
#---------------------------------------------------------------------
package $package;

our \$VERSION = '$PostScript::File::VERSION';
# This file is part of {{\$dist}} {{\$dist_version}} ({{\$date}})

\$PostScript::File::Metrics::Info{$D{$font}} ||= $info;

\$PostScript::File::Metrics::Metrics{$D{$font}}{$D{$encoding}} = [
END HEADER

    my $wx = $PostScript::File::Metrics::Metrics{$font}{$encoding};

    print $out '  ';
    for my $c (0..255) {
      print $out "\n  " if $c and not $c % 16;
      print $out "$wx->[$c],";
    } # end for $c

    print $out "\n];\n\n__END__\n\n=for Pod::Loom-sections NONE\n";

    close $out;
  } # end foreach $encoding in @$encodings
} # end dump_font

#---------------------------------------------------------------------
# Dump a single term using Data::Dumper:

sub dump_term
{
  my $d = Data::Dumper->new(\@_);

  my $term = $d->Indent(1)->Sortkeys(1)->Terse(1)->Dump;

  $term =~ s/\s+\z//;

  $term;
} # end dump_term
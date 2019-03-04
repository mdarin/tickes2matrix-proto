#!/usr/bin/perl -w
use warnings;
use strict;

my $fin;
my $fout;
open $fin, "<./tickers.csv";
open $fout, ">./table.mat";

my %tab;
my $lineno = 0;
grep { chomp;
	if (!$lineno) {
	# skip header
		$lineno++;
	} else {
	# read data
		$lineno++;
		my @rec = split ";", $_;
		#print $rec[0] . ";" . $rec[6] . "\n"; # TIKER;CLOSE
		unless (exists $tab{$rec[0]}) {
		# create array no first time and fill it in
			#print "CREATE " . $rec[0] . "\n";
			$tab{$rec[0]} = [()];
			push @{$tab{$rec[0]}}, $rec[6];
		} else {
		# fill in an array
			#print "INSERT " . $rec[0] . "\n";
			push @{$tab{$rec[0]}}, $rec[6];
		}
	}
} <$fin>;

# get the longest array(max length) as nrows value
# and count ncols value
my $nrows = 0;
my $ncols = 0;
while (my ($key,$value) = each %tab) {
	$ncols++;
	if ($nrows < @{$value}) {
		$nrows = @{$value};
	}
}

# print haead with ticker names
my $separator = "";
# print comment 
print "# ";
while (my ($key,$value) = each %tab) {
	print "$separator$key";
	$separator = ",";
}
print "\n";

# print matrix definition
print "rows,$nrows\n";
print "cols,$ncols\n";

# print matrix
# traverse table and clreate matrix ntickers x nrows
# make addition to zero for empty field of tickers that shorter than the longest length
foreach my $i (1..$nrows-1) {
    #print "iteration $i ";
	my $separator = "";
	while (my ($key,$value) = each %tab) {
		if (defined($value->[$i])) {
			print $separator . $value->[$i];
		} else {
		# addition to zero for empty fields
			print $separator . "0.0";
		}
		$separator = ",";
	}
	print "\n";
}

close $fin;
close $fout;


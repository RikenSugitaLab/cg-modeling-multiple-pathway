#!/usr/bin/perl
#
use strict;
use warnings;
my $opt={};
@{$opt->{keys}}=(
		"STEP","MUL_BASIN002","MUL_BASIN003","POTENTIAL_ENE",
		"MORPH","BASIN_ENE002","BASIN_ENE003","DRMS1","DRMS2");
$opt->{crit}=0.50;
$opt->{crit_state}=0.20;
for (my $if = 0 ;$if<scalar(@ARGV);$if++) {
	@{$opt->{title}}=();
	$opt->{infile}=$ARGV[$if];
	$opt->{outfile}=sprintf("%s.minlast",$opt->{infile});
	&readlog($opt);
	&writedata($opt);
	&checkdata($opt);
	my $char="DB";
	if ($opt->{single} == 1) {
		$char="SB";
	}
	my $char2 = "N/A";
	if ($opt->{exchange} == 1) {
		$char2=$opt->{exchange_step};
	}
	printf STDOUT "%30s : %2s %4s %4.2f %4.2f %4.2f\n",
		   $opt->{infile},$char,$char2,$opt->{basin_unf},
		   $opt->{last_drms1},$opt->{last_drms2};
}

sub checkdata {
	my ($opt)=@_;
	my $flag=0;
	$opt->{single}=0;
	$opt->{exchange}=0;
	my $init_basin1=1;
	my $init_basin2=0;
	my $end_basin1=1;
	my $end_basin2=0;
	$opt->{single}=0;
	$opt->{exchange}=0;
	$opt->{last_drms1}=$opt->{data}->{DRMS1}->[scalar(@{$opt->{data}->{STEP}})-1];
	$opt->{last_drms2}=$opt->{data}->{DRMS2}->[scalar(@{$opt->{data}->{STEP}})-1];
	for (my $it =0;$it<scalar(@{$opt->{data}->{STEP}});$it++) {
		if ($opt->{data}->{STEP}->[$it] != 0) {
			my $key1 = "MUL_BASIN002";
			my $key2 = "MUL_BASIN003";
			if ($flag==0) {
				$init_basin1=$opt->{data}->{$key1}->[$it];
				$init_basin2=$opt->{data}->{$key2}->[$it];
				if (abs($init_basin1-$init_basin2) < $opt->{crit}) {
					$opt->{single}=1;
				}
				$opt->{basin_unf}=$init_basin1;
				$flag=1;
			} else {
				$end_basin1=$opt->{data}->{$key1}->[$it];
				$end_basin2=$opt->{data}->{$key2}->[$it];
				if (abs($end_basin1-$init_basin1) > $opt->{crit}) {
					$opt->{exchange}=1;
					$opt->{exchange_step}=$opt->{data}->{STEP}->[$it];
					last;
				}
			}
		}
	}
}

sub writedata {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{outfile}) || die "Cannot open $opt->{outfile}\n";
	for (my $it =0;$it<scalar(@{$opt->{data}->{STEP}});$it++) {
		if ($opt->{data}->{STEP}->[$it] != 0) {
			for (my $ik =0;$ik<scalar(@{$opt->{keys}});$ik++) {
				my $key=$opt->{keys}->[$ik];
				printf OUTFILE " %8s",$opt->{data}->{$key}->[$it];
			}
			printf OUTFILE "\n";
		}
	}
	close(OUTFILE);
}

sub readlog {
	my ($opt)=@_;
	open(INFILE,$opt->{infile}) || die "Cannot open $opt->{infile}\n";
	my $flag=0;
	my $prev_step=-1;
	my $curr_step=$prev_step;
	my $str="";
	my $istep_column=-1;
	while(<INFILE>){
		if (/^\[STEP6\]/) {
			$flag=0;
			last;
		} elsif (/^\[STEP5\]/) {
			$flag=1;
		}
		if ($flag==1) {
			if (/^INFO: /) {
				my (@dum)=split(' ',$_);
				if (/STEP/) {
					for (my $i = 1;$i<scalar(@dum);$i++) {
						$opt->{title}->[$i]=$dum[$i];
						@{$opt->{data}->{$opt->{title}->[$i]}}=();
						if ($dum[$i] eq "STEP") {
							$istep_column = $i;
						}
					}
				} elsif (!/STEP/) {
					if ($istep_column > 0) {
						$curr_step=$dum[$istep_column];
					}
					if ($curr_step != $prev_step && $prev_step >= 1) {
						my (@dum2)=split(' ',$str);
						for (my $i = 1;$i<scalar(@dum2);$i++) {
							push(@{$opt->{data}->{$opt->{title}->[$i]}},$dum2[$i]);
						}
					} 
					$prev_step = $curr_step;
					$str = $_;
				}
			}
		}
	}
	close(INFILE);
}

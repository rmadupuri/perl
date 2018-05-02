use strict;
use warnings;
use LWP::Simple;

my $url = "https://www.uniprot.org/uniprot";
open(FH,"<$ARGV[0]") or die("can't find the input file");
open(FH1,">output.txt") or die();
print FH1 "UID\tResidue Number\tSequence\t-10\t-9\t-8\t-7\t-6\t-5\t-4\t-3\t-2\t-1\t0\t1\t2\t3\t4\t5\t6\t7\t8\t9\t10\n";
my %useq; 
while(<FH>)
{
	chomp($_);
	my @ar = split("\t",$_);
	my $uid = uc($ar[0]);
	if(exists($useq{$uid}))
	{
		my $end = length($useq{$uid}); #100
		my $start = 1;
		my $req = $ar[1];
		my $ndiff = $req - 10;
		my $final_nseq; my $final_pseq;
		if($ndiff < 1)
		{
			my $emp = $start - $ndiff;
			my $nseq = substr($useq{$uid},$start-1,$req-$start);
			$final_nseq = $emp.$nseq;
		}
		else
		{
			my $nseq = substr($useq{$uid},$ndiff-1,11);
			$final_nseq = $nseq;
		}

		my $pdiff = $req + 10;
		if($pdiff > $end)
		{
			my $emp = $pdiff - $end;
			my $pseq = substr($useq{$uid},$req,$end - $req);
			$final_pseq = $pseq. " " x $emp;
		}
		else
		{
			my $pseq = substr($useq{$uid},$req,10);
			$final_pseq = $pseq;
		}
		my $fi_seq = $final_nseq.$final_pseq;
		my @a1 = split("",$fi_seq);
		my $fi_seq2 = join("\t",@a1);
		$fi_seq =~ s/\s//g;
		print FH1 $uid."\t".$req."\t".$fi_seq."\t".$fi_seq2."\n";
	}
	else
	{
		my $final_nseq; my $final_pseq;
		my $fasta = get("$url/$uid.fasta");
		my @line = split("\n",$fasta);
		shift(@line);
		my $seq = join("",@line);
		$useq{$uid} = $seq;

		my $end = length($seq); #100
		my $start = 1;
		my $req = $ar[1];
		my $ndiff = $req - 10;
		if($ndiff < 1)
		{
			my $emp = $start - $ndiff;
			my $nseq = substr($useq{$uid},$start-1,$req-$start+1);
			$final_nseq = " " x $emp.$nseq;
		}
		else
		{
			my $nseq = substr($useq{$uid},$ndiff-1,11);
			$final_nseq = $nseq;
		}

		my $pdiff = $req + 10;
		if($pdiff > $end)
		{
			my $emp = $pdiff - $end;
			my $pseq = substr($useq{$uid},$req,$end - $req);
			$final_pseq = $pseq. " " x $emp;
			#print $uid."\t".$req."\t".$final_pseq."\n";
		}
		else
		{
			my $pseq = substr($useq{$uid},$req,10);
			$final_pseq = $pseq;
			#print $uid."\t".$req."\t".$final_pseq."\n";
		}
		my $fi_seq = $final_nseq.$final_pseq;
		my @a1 = split("",$fi_seq);
		my $fi_seq2 = join("\t",@a1);
		$fi_seq =~ s/\s//g;
		print FH1 $uid."\t".$req."\t".$fi_seq."\t".$fi_seq2."\n";
	}
}
close(FH);
close(FH1);
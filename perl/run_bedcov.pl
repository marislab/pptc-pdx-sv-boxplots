use Parallel::ForkManager;
use Data::Dumper;
use File::Slurp;

my @samples = read_file '/mnt/isilon/maris_lab/target_nbl_ngs/rathik/ATRX_exon_coverage/samples.txt';
my $bamdir = '/mnt/isilon/maris_lab/target_nbl_ngs/PPTC-PDX-genomics/bcm-processed/wes-bam';
my $ref = '/mnt/isilon/maris_lab/target_nbl_ngs/rathik/ATRX_exon_coverage/GRCh37.primary_assembly.genome.fa';
my $targets = '/mnt/isilon/maris_lab/target_nbl_ngs/rathik/ATRX_exon_coverage/ATRX_exons.bed';
my $outdir = '/mnt/isilon/maris_lab/target_nbl_ngs/rathik/ATRX_exon_coverage/results';

# start time
my $start_run = time();

# run parallel jobs
my $pm=new Parallel::ForkManager(10);

foreach (@samples)
{	
	$pm->start and next;

		chomp($_);
		$sample = $_;
		$sname = $sample;
		$sname =~ s/-human.bam|.hybrid_hg19.realigned.recal.bam/_coverage.txt/;
		print $sample,"\n";
		print $sname,"\n";
				
		my $bedcov = "samtools bedcov --reference $ref $targets $bamdir/$sample > $outdir/$sname";
		print $bedcov,"\n";
		system($bedcov);

	$pm->finish;
}

$pm->wait_all_children;

# end time
my $end_run = time();
my $run_time = $end_run - $start_run;
print "Job took $run_time seconds\n";

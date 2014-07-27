#!/usr/bin/perl -w
use strict;
use CGI;
use Config::IniFiles;
use DBI;
use HTML::Template;

## create our CGI and TMPL objects
my $cgi  = new CGI;
my $tmpl = HTML::Template->new(filename => './tmpl/search.tmpl');

#access the data using the 'param' method, passing the 'name' of the input
#element from the search.html to this cgi script
my $mrna_term = $cgi->param('mrna_search_term'); #mrna sequence
my $sirna_term = $cgi->param('sirna_search_term'); #sirna sequence
	if ($sirna_term =~ /.+T.+/){ #this if-loop converts T to U as the sequence is stored in this db with uracil 
		$sirna_term =~ s/T/U/gi;
	}
my $geneid_term = $cgi->param('geneid_search_term');
my $genename_term = $cgi->param('genename_search_term');
my $accid_term = $cgi->param('accid_search_term');

## set any variables
my $opts = {RaiseError => 1, PrintError => 1};
my $cfg = Config::IniFiles->new( -file => "./configfile.ini");
my $dsn = $cfg->val('Database', 'db');
my $user = $cfg->val('Username', 'user');
my $pass = $cfg->val('Password', 'pass');
my $dbh = DBI->connect($dsn, $user, $pass, $opts);

#defining the sql statement for search of target sequence, gene id, gene name and gene accession
my $target_qry = qq{
	SELECT s.sirna_id, s.mrna_target_sequence, s.sirna_sequence, g.gene_id, g.gene_name, d.gene_accession
	FROM sequences s
	JOIN targets t ON s.sirna_id=t.sirna_id
	JOIN genes g ON t.gene_id=g.gene_id
	JOIN dbxref d ON g.gene_id=d.gene_id
	WHERE s.sirna_sequence LIKE ?
	AND g.gene_id LIKE ?
	AND g.gene_name LIKE ?
	AND d.gene_accession LIKE ?
};

#telling the DBI to prepare the statement for use, then execute it
my $dsh = $dbh->prepare($target_qry);
$dsh->execute("%$sirna_term%", "%$geneid_term%", "%$genename_term%", "%$accid_term%");

##iterate through the results using statement handle
my @results;
my $count=0;
while (my $row = $dsh->fetchrow_hashref) {	#the fetchrow_hashref() places the data from each row into a hash reference
	push @results, {SIRNA_ID=>$$row{sirna_id}, MRNA_TARGET_SEQUENCE=>$$row{mrna_target_sequence}, SIRNA_SEQUENCE=>$$row{sirna_sequence}, GENE_ID=>$$row{gene_id}, GENE_NAME=>$$row{gene_name}, ACC_ID=>$$row{gene_accession}};
	$count++;
}

##Clean up - close dsh, it will be used again for the next statement
$dsh->finish();

#find overlap between query mrna sequence and database mrna sequences
#sql statement to retrieve all mrna sequences
my $mrna_qry = qq{
	SELECT DISTINCT mrna_target_sequence
	FROM sequences
};

#prepare and execute statement
$dsh = $dbh->prepare($mrna_qry);
$dsh->execute();

#fetch rows from the handle and compare against query mrna sequence
my @mrna_results;
my $mrna_count=0;
my $mrna_search; 

while (my $row = $dsh->fetchrow_hashref){
	my $subj = ($$row{mrna_target_sequence});
	if ($mrna_term =~ /.+U.+/){ #this if-loop converts U to T as the sequence is stored in this and other dbs, if the mrna sequence has thymine instead of uracil
		$mrna_term =~ s/U/T/gi;
	}
	my $qry = $mrna_term;
	my $overlap; 
	my $fiveprime;
	my $threeprime;
	if ($qry =~ m/([ATCGatcg]*)($subj)([ATCGatcg]*)/i){
		$mrna_count++;
		$overlap = $subj;
		$fiveprime = $1;
		$threeprime = $3;
		my $col1 = (length($overlap));
		my $col2 = "$fiveprime$subj$threeprime";
		my $col3 = "-"x(length($fiveprime));
		my $col4 = $subj;
		my $col5 = "-"x(length($threeprime));
		#sql statement to retrieve data on the matching siRNA sequence
		my $sirna_qry = qq{
			SELECT s.sirna_id, s.mrna_target_sequence, s.sirna_sequence, g.gene_id, g.gene_name, d.gene_accession
			FROM sequences s
			JOIN targets t ON s.sirna_id=t.sirna_id
			JOIN genes g ON t.gene_id=g.gene_id
			JOIN dbxref d ON g.gene_id=d.gene_id
			WHERE s.mrna_target_sequence LIKE ? 
		};
		my $dsh2 = $dbh->prepare($sirna_qry);
		$dsh2->execute("%$subj%");
		while (my $row = $dsh2->fetchrow_hashref) {	#the fetchrow_hashref() places the data from each row into a hash reference
			push @mrna_results, {LENGTH=>$col1, COL2=>$col2, COL3=>$col3, COL4=>$col4, COL5=>$col5, SIRNA_ID=>$$row{sirna_id}, MRNA_TARGET_SEQUENCE=>$$row{mrna_target_sequence}, SIRNA_SEQUENCE=>$$row{sirna_sequence}, GENE_ID=>$$row{gene_id}, GENE_NAME=>$$row{gene_name}, ACC_ID=>$$row{gene_accession}};
		}
		$dsh2->finish();
		}
		if ($qry =~ /[A-Z]+/i){
			if (@mrna_results){
				$mrna_search = "";
			}else{
				$mrna_search= "No siRNA targets found for that mRNA sequence";
			}
		}
}
	
##Clean up
$dsh->finish();
$dbh->disconnect();

## push data to the template.
$tmpl->param( PAGE_TITLE  => 'siRNA Database' );
$tmpl->param( RESULTS => \@results );
$tmpl->param( COUNT => $count);
$tmpl->param( MRNARESULTS => \@mrna_results );
$tmpl->param( MRNACOUNT => $mrna_count);
$tmpl->param( MRNASEARCH => $mrna_search);

## print the header and template
print $cgi->header('text/html');
print $tmpl->output

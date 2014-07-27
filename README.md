siRNAdb
=======

archived code for siRNA database search and alignment

*About*

Webpage to query known siRNA and identify siRNA targets on a mRNA sequence 
of interest

Source code:

/var/www/poberoi1/final.tar

*Detailed Usage*

This webpage allows users to search an siRNA database using one of the 
following criterion, or a combination:

1. siRNA sequence - this is the siRNA sequence for the guide strand. A user
could use this search function to see if their siRNA sequence is already
known or if it is known to target the mRNA they expect 
(Example: AAUGGUGGAGUAGAAGACAUG)

2. Gene ID - the unique gene identifiers used by NCBI databases. 
(Example: 40254822)

3. Gene Name - the name used for the targeted gene 
(Example: death-associated protein kinase 3, or, ATP-binding)

4. Accession ID - unique identifier for gene product such as mRNA or 
non-protein coding RNAs (Example: NM_181870)

An alternative way to search the siRNA database is by pasting in an mRNA 
sequence of interest, which will align known siRNA target sites to the
query mRNA sequence.
(Example: GCAUGCUCGUAGUCGUUUUGAGGCUCCACCUGCCGCAACGCGCGCAUCAUCGUACGG)

Begin typing in any of the search textboxes to pull up an autocomplete list 
with a few examples of search terms.

To see a list of the 1266 records in the database, hit search on the homepage 
without any search criteria.

Since RNA sequences are often saved in databases with thymine (T) instead of 
uracil (U), a user may enter an mRNA or siRNA sequence with either T or U 
to query the database.

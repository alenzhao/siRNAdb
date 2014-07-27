$(function() {
	var availableTags = [
		"TAGCTAACACAGCCAGTTCAAATGCCAGCAGTGTCCGTATACTT",
		"CATGGAATGAATTGTAGTCCAACTTAGAGATGAGAACTGGTTCTACACAT",
		"TGCTTGAAGCAGCTCTGGA",
		"GCATTCGTCCGGTTGCGCTGATTACACCATGAGTTTATCGCCACCGATTACAGGAGGGGATCAGTATATAC",
		"GUCUGUAAAGACCAAGGGAUGGAUCUGGGAUAUUAGGC",
	];
	$( "#mrna_search_term" ).autocomplete({
		source: availableTags
	});
});

$(function() {
	var availableTags = [
		"CUGAGGUUGGCUCCGACAU",
		"UUCUCGAGCCCAAGCUGCU",
		"GGAGGCAGAGGUGCUACUC",
		"ACCAACUCCUUUUUCAAUU",
		"TCTGCAACCACTGGATCTG",
	];
	$( "#sirna_search_term" ).autocomplete({
		source: availableTags
	});
});

$(function() {
	var availableTags = [
		"5174578",
		"29789005",
		"31543909",
		"4758563",
		"11641422",
	];
	$( "#geneid_search_term" ).autocomplete({
		source: availableTags
	});
});

$(function() {
	var availableTags = [
		"connector enhancer of kinase suppressor of Ras 1",
		"lysosomal multispanning membrane protein 5",
		"cyclin",
		"peptidase",
		"Rho guanine nucleotide exchange factor (GEF)",
	];
	$( "#genename_search_term" ).autocomplete({
		source: availableTags
	});
});

$(function() {
	var availableTags = [
		"NM_005465",
		"XM_376479",
		"NM_176795",
		"XR_000175",
		"NM_183001",
	];
	$( "#accid_search_term" ).autocomplete({
		source: availableTags
	});
});

program randomdo
	version 11.2

	#delimit ;

	syntax using/,
		seed(integer)
		dataset(str)
		unique(namelist)
		groups(integer)
		[sample(integer 0)
		orthog(namelist)
		replace];

	tempfile temp;
	mata: randomdo(
		"temp",
		"seed",
		"dataset",
		"unique",
		"groups",
		"sample",
		"orthog");
	quietly copy `temp' `"`using'"', `replace';

	#delimit cr
end

args(string scalar variables)
foreach var of varlist <%= variables %> {
	tabulate `var' treatment
}

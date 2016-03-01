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

version 11.2

local AsArray `"transmorphic matrix"'
local BaseWriter `"randomdo_base_writer"'
local BaseWriterC `"class randomdo_base_writer colvector"'
local BaseWriterM `"class randomdo_base_writer matrix"'
local BaseWriterR `"class randomdo_base_writer rowvector"'
local BaseWriterS `"class randomdo_base_writer scalar"'
local BaseWriterV `"class randomdo_base_writer vector"'
local BooleanC `"real colvector"'
local BooleanM `"real matrix"'
local BooleanR `"real rowvector"'
local BooleanS `"real scalar"'
local BooleanV `"real vector"'
local CC `"complex colvector"'
local CM `"complex matrix"'
local CR `"complex rowvector"'
local CS `"complex scalar"'
local CV `"complex vector"'
local Control `"randomdo_control"'
local ControlC `"class randomdo_control colvector"'
local ControlM `"class randomdo_control matrix"'
local ControlR `"class randomdo_control rowvector"'
local ControlS `"class randomdo_control scalar"'
local ControlV `"class randomdo_control vector"'
local False `"0"'
local FileHandleC `"real colvector"'
local FileHandleM `"real matrix"'
local FileHandleR `"real rowvector"'
local FileHandleS `"real scalar"'
local FileHandleV `"real vector"'
local LclNameC `"string colvector"'
local LclNameM `"string matrix"'
local LclNameR `"string rowvector"'
local LclNameS `"string scalar"'
local LclNameV `"string vector"'
local NC `"numeric colvector"'
local NM `"numeric matrix"'
local NR `"numeric rowvector"'
local NS `"numeric scalar"'
local NV `"numeric vector"'
local NameC `"string colvector"'
local NameM `"string matrix"'
local NameR `"string rowvector"'
local NameS `"string scalar"'
local NameV `"string vector"'
local RC `"real colvector"'
local RM `"real matrix"'
local RR `"real rowvector"'
local RS `"real scalar"'
local RV `"real vector"'
local RandomWriter `"randomdo_complete_writer"'
local RandomWriterC `"class randomdo_complete_writer colvector"'
local RandomWriterM `"class randomdo_complete_writer matrix"'
local RandomWriterR `"class randomdo_complete_writer rowvector"'
local RandomWriterS `"class randomdo_complete_writer scalar"'
local RandomWriterV `"class randomdo_complete_writer vector"'
local SC `"string colvector"'
local SM `"string matrix"'
local SR `"string rowvector"'
local SS `"string scalar"'
local SV `"string vector"'
local TC `"transmorphic colvector"'
local TM `"transmorphic matrix"'
local TR `"transmorphic rowvector"'
local TS `"transmorphic scalar"'
local TV `"transmorphic vector"'
local Tokenizer `"transmorphic matrix"'
local True `"1"'

// BaseWriter

*version 11.2

*matamac

mata:

class `BaseWriter' {
	public:
		virtual void write()
		virtual void put()
		virtual void write_orthog()
		virtual void write_randomize()
}

void `BaseWriter'::write(`SS' s) {
	pragma unused s
	_error("method not implemented")
}

void `BaseWriter'::put(|`SS' s) {
	pragma unused s
	_error("method not implemented")
}

void `BaseWriter'::write_orthog(string scalar variables) {
	pragma unused variables
	_error("method not implemented")
}

void `BaseWriter'::write_randomize() {
	_error("method not implemented")
}

end

// Control

*version 11.2

*matamac
*matainclude BaseWriter

mata:

class `Control' extends `BaseWriter' {
	public:
		virtual void write(), put()
		void init(), write_all()

	protected:
		`SS' filename, seed, dataset, unique, groups, sample, orthog
		`FileHandleS' fh
}

// Pseudo-constructor to receive template inputs
void `Control'::init(
	`SS' filename,
	`SS' seed,
	`SS' dataset,
	`SS' unique,
	`SS' groups,
	`SS' sample,
	`SS' orthog)
{
	this.filename = filename
	this.seed = seed
	this.dataset = dataset
	this.unique = unique
	this.groups = groups
	this.sample = sample
	this.orthog = orthog
}

// Main control logic
void `Control'::write_all()
{
	fh = fopen(filename, "w")

	write_randomize()
	if (orthog != "") {
		put()
		write_orthog(orthog)
	}

	fclose(fh)
}

// Override write() and put().

void `Control'::write(`SS' s)
	fwrite(fh, s)

void `Control'::put(|`SS' s)
	fput(fh, s)

end

// RandomWriter

*version 11.2

*matamac
*matainclude Control

mata:

class `RandomWriter' extends `Control' {
	public:
		virtual void write_orthog()
		virtual void write_randomize()
}

void `RandomWriter'::write_orthog(string scalar variables)
{
	write("foreach var of varlist ")
	write(variables)
	put(" {")
	put(char(9) + "tabulate \`var' treatment")
	put("}")
}

void `RandomWriter'::write_randomize()
{
	write("version ")
	write(strofreal(callersversion()))
	put()
	put()
	write("set seed ")
	write(seed)
	put()
	put()
	write(`"use ""')
	write(dataset)
	put(`"", clear"')
	put()
	if (sample != "") {
		write("sample ")
		write(sample)
		put(", count")
		put()
	}
	write("isid ")
	write(unique)
	put()
	write("sort ")
	write(unique)
	put()
	put()
	put("generate double u1 = runiform()")
	put("generate double u2 = runiform()")
	put()
	put("isid u1 u2")
	put("sort u1 u2")
	put()
	write("generate treatment = mod(_n - 1, ")
	write(groups)
	put(") + 1")
}

end

// randomdo

*version 11.2

*matamac
*matainclude RandomWriter

mata:

// Functional layer between -randomdo- and `RandomWriter'
void randomdo(
	`LclNameS' filename,
	`LclNameS' seed,
	`LclNameS' dataset,
	`LclNameS' unique,
	`LclNameS' groups,
	`LclNameS' sample,
	`LclNameS' orthog)
{
	`SS' sample_string
	`RandomWriterS' writer

	sample_string = st_local(sample)
	// Default value
	if (sample_string == "0")
		sample_string = ""

	writer.init(
		st_local(filename),
		st_local(seed),
		st_local(dataset),
		st_local(unique),
		st_local(groups),
		sample_string,
		st_local(orthog)
	)
	writer.write_all()
}

end

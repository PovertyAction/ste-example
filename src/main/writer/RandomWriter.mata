version 11.2

matamac
matainclude Control

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

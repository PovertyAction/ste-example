version 11.2

matamac
matainclude BaseWriter

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

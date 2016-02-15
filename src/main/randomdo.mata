version 11.2

matamac
matainclude RandomWriter

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

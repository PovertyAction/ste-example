program ste_randomdo
	version 11.2

	_find_project_root
	local writer "`r(path)'/src/main/writer"

	#delimit ;
	ste using `"`writer'/templates"',
		base(`"`writer'/BaseWriter.mata"')
		control(Control)
		complete(`"`writer'/RandomWriter.mata"')
	;
	#delimit cr
end

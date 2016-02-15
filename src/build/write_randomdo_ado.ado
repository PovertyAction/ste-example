program write_randomdo_ado
	version 11.2

	ste_randomdo

	_find_project_root
	#delimit ;
	writeado
		using `"`r(path)'/src/build/randomdo.ado"',
		stata(main/randomdo.do)
		mata(
			BaseWriter
			Control
			RandomWriter
			randomdo
		)
	;
	#delimit cr
end

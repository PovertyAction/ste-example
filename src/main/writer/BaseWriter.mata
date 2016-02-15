version 11.2

matamac

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

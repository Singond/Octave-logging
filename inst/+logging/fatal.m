function fatal(msg, varargin)
	logging.Logger.default().fatal(msg, varargin{:});
endfunction

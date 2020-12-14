function debug(msg, varargin)
	logging.Logger.default().debug(msg, varargin{:});
endfunction

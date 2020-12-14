function err(msg, varargin)
	logging.Logger.default().error(msg, varargin{:});
endfunction

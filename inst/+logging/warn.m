function warn(msg, varargin)
	logging.Logger.default().warn(msg, varargin{:});
endfunction

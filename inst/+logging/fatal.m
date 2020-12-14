function fatal(msg, varargin)
	logging.Logger.default().fatal(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.FATAL)
%! assert(strfind(evalc('logging.fatal("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.OFF)
%! assert(isempty(evalc('logging.fatal("MSG");')))
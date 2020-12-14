function trace(msg, varargin)
	logging.Logger.default().trace(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.TRACE)
%! assert(strfind(evalc('logging.trace("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.DEBUG)
%! assert(isempty(evalc('logging.trace("MSG");')))
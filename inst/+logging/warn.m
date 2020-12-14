function warn(msg, varargin)
	logging.Logger.default().warn(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.WARNING)
%! assert(strfind(evalc('logging.warn("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.ERROR)
%! assert(isempty(evalc('logging.warn("MSG");')))
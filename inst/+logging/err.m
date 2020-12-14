function err(msg, varargin)
	logging.Logger.default().error(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.ERROR)
%! assert(strfind(evalc('logging.err("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.FATAL)
%! assert(isempty(evalc('logging.err("MSG");')))
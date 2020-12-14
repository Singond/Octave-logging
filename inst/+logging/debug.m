function debug(msg, varargin)
	logging.Logger.default().debug(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.ALL)
%! assert(strfind(evalc('logging.debug("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.TRACE)
%! assert(strfind(evalc('logging.debug("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.DEBUG)
%! assert(strfind(evalc('logging.debug("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.INFO)
%! assert(isempty(evalc('logging.debug("MSG");')))
%!test
%! logging.setlevel(logging.Level.WARNING)
%! assert(isempty(evalc('logging.debug("MSG");')))
%!test
%! logging.setlevel(logging.Level.ERROR)
%! assert(isempty(evalc('logging.debug("MSG");')))
%!test
%! logging.setlevel(logging.Level.FATAL)
%! assert(isempty(evalc('logging.debug("MSG");')))
%!test
%! logging.setlevel(logging.Level.OFF)
%! assert(isempty(evalc('logging.debug("MSG");')))

%!test
%! logging.setlevel(logging.Level.DEBUG)
%! assert(strfind(evalc('logging.debug("Hello, %s");'), "Hello, %s"))
%!assert(strfind(evalc('logging.debug("Hello, %s", "world");'), "Hello, world"))
%!assert(strfind(evalc('logging.debug("%s, %s", "Hello", "world");'), "Hello, world"))
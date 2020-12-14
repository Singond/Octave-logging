function info(msg, varargin)
	logging.Logger.default().info(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.ALL)
%! assert(strfind(evalc('logging.info("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.TRACE)
%! assert(strfind(evalc('logging.info("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.DEBUG)
%! assert(strfind(evalc('logging.info("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.INFO)
%! assert(strfind(evalc('logging.info("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.WARNING)
%! assert(isempty(evalc('logging.info("MSG");')))
%!test
%! logging.setlevel(logging.Level.ERROR)
%! assert(isempty(evalc('logging.info("MSG");')))
%!test
%! logging.setlevel(logging.Level.FATAL)
%! assert(isempty(evalc('logging.info("MSG");')))
%!test
%! logging.setlevel(logging.Level.OFF)
%! assert(isempty(evalc('logging.info("MSG");')))

%!test
%! logging.setlevel(logging.Level.INFO)
%! assert(strfind(evalc('logging.info("Hello, %s");'), "Hello, %s"))
%!assert(strfind(evalc('logging.info("Hello, %s", "world");'), "Hello, world"))
%!assert(strfind(evalc('logging.info("%s, %s", "Hello", "world");'), "Hello, world"))

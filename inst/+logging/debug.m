## Copyright (C) 2020 Jan Slany
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
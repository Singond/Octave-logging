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

function err(msg, varargin)
	logging.Logger.default().error(msg, varargin{:});
endfunction

%!test
%! logging.setlevel(logging.Level.ERROR)
%! assert(strfind(evalc('logging.err("MSG");'), "MSG"))
%!test
%! logging.setlevel(logging.Level.FATAL)
%! assert(isempty(evalc('logging.err("MSG");')))
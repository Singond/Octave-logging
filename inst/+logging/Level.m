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

classdef Level
	properties (Constant = true)
		ALL = struct("value", 0, "name", "");
		TRACE = struct("value", 100, "name", "trace");
		DEBUG = struct("value", 200, "name", "debug");
		INFO = struct("value", 300, "name", "info");
		WARNING = struct("value", 400, "name", "warn");
		ERROR = struct("value", 500, "name", "error");
		FATAL = struct("value", 600, "name", "fatal");
		OFF = struct("value", Inf, "name", "");
	endproperties
endclassdef
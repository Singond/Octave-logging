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

classdef Logger < handle
	properties (Access = private)
		loglevel = logging.Level.INFO;
		destination = stdout();
		destinationprivate = false;
		category = "";
		## Number of inner stack frames to be always hidden
		## when determining category name from calling functions.
		## By default, the stack frames to be hidden are:
		##   - callername
		##   - @<anonymous>
		##   - Logger.logmsg
		##   - Logger.(trace|debug|info|warn|err|fatal)
		categoryskipframes = 4;
		format;
		printargsidx;
	endproperties

	methods
		function self = Logger()
			self.setcategory("callername");
			self.setformat("%p [%c]: %m");
		endfunction

		function delete(self)
			self.cleandestination();
		endfunction

		function trace(self, msg, varargin)
			self.logmsg(logging.Level.TRACE, msg, varargin{:});
		endfunction

		function debug(self, msg, varargin)
			self.logmsg(logging.Level.DEBUG, msg, varargin{:});
		endfunction

		function info(self, msg, varargin)
			self.logmsg(logging.Level.INFO, msg, varargin{:});
		endfunction

		function warn(self, msg, varargin)
			self.logmsg(logging.Level.WARNING, msg, varargin{:});
		endfunction

		function error(self, msg, varargin)
			self.logmsg(logging.Level.ERROR, msg, varargin{:});
		endfunction

		function fatal(self, msg, varargin)
			self.logmsg(logging.Level.FATAL, msg, varargin{:});
		endfunction

		function setlevel(self, level)
			if (!isstruct(level) || !isscalar(level))
				error("Logger.setlevel: LEVEL must be a struct");
			endif
			self.loglevel = level;
		endfunction

		function setdestination(self, dest)
			## Clean up previous destination
			self.cleandestination();
			## Set new value
			olddest = [];
			if (is_valid_file_id(dest))
				olddest
				self.destination = dest;
				self.destinationprivate = false;
			elseif (ischar(dest))
				self.destination = fopen(dest, "w+");
				self.destinationprivate = true;
			else
				error("Logger.setdestination: DEST must be either a file handle or a filename");
			endif
		endfunction

		function setcategory(self, category, opt)
			if (nargin < 2)
				error("Logger.setcategory: need at least one arrgument");
			elseif (strcmp(category, "callername"))
				if (nargin == 2 || nargin == 3)
					if (nargin == 2)
						opt = 1;
					elseif (!isnumeric(opt) || !isscalar(opt) || opt < 1)
						error("Logger.setcategory: LVL must be a positive integer");
					endif
					## Number of inner stack frames to skip in addition
					## to those specified by user in 'opt'.
					skipframes = self.categoryskipframes;
					category = @() logging.Logger.callername(opt + skipframes);
				else
					error("Logger.setcategory: 'callername' needs zero or one argument");
				endif
			elseif (!ischar(category) && !is_function_handle(category))
				error("Logger.setcategory: CATEGORY must be a string or a function handle");
			endif
			self.category = category;
		endfunction

		function setformat(self, format)
			[s, e, te, m, t, nm, sp] = regexp(format,
				"%\-?[0-9]*\\.?[0-9]*([pcm])");
			## t is a (1D?) cell array of cell arrays.
			## The outer cell array has one element for each match.
			## Each element is a (1D?) cell array containing
			## one element for each matching group.
			## The value of the element is the matched text of the group.
			assert(size(t) == size(te));
			## The value specifier is the 1st matching group in the regex
			groupn = 1;
			idxs = [];
			for match = [t; te]
				## Now 'match' is a cell array containing the matching groups
				## (a cell array) and their extents (a numeric matrix).
				grouptext = match{1}{groupn};
				groupextent = match{2}(groupn,:);
				if (strcmp(grouptext, "p"))
					## Log level (p for "priority"? used as in Log4J)
					idx = 1;
				elseif (strcmp(grouptext, "c"))
					## Log category
					idx = 2;
				elseif (strcmp(grouptext, "m"))
					## Log message
					idx = 3;
				endif
				idxs = [idxs idx];
				format(groupextent(2)) = "s";
			endfor
			self.printargsidx = idxs;
			## Add newline, because fprintf does not do so.
			self.format = [format "\n"];
		endfunction
	endmethods

	methods (Access = private)
		function logmsg(self, level, msg, varargin)
			## Obtain category name
			if (ischar(self.category))
				category = self.category;
			elseif (is_function_handle(self.category))
				category = self.category();
			else
				category = "";
			endif

			if (level.value >= self.loglevel.value)
				if (!isempty(varargin))
					msg = sprintf(msg, varargin{:});
				endif
				printargs = {level.name, category, msg};
				fprintf(self.format, printargs{self.printargsidx});
			endif
		endfunction

		function cleandestination(self)
			if (self.destinationprivate
					&& is_valid_file_id(self.destinationprivate))
				fclose(self.destination);
			endif
		endfunction
	endmethods

	methods (Static = true)
		function lgr = default()
			persistent logger;
			if (isempty(logger))
				logger = logging.Logger();
				## Skip one more frame, because the default logger
				## is expected to be always called from the wrapper
				## functions logging.debug() etc.
				logger.categoryskipframes += 1;
				## Needs to be called after changing categoryskipframes
				logger.setcategory("callername");
			endif
			lgr = logger;
		endfunction
	endmethods

	methods (Static = true, Access = private)
		function name = callername(levels)
			stack = dbstack();
			if (length(dbstack) >= levels)
				name = stack(levels).name;
			else
				name = "";
			endif
		endfunction
	endmethods
endclassdef
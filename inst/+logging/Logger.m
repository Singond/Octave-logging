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
	endproperties

	methods
		function self = Logger()
			self.setcategory("callername");
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
			if (!isnumeric(level) || !isscalar(level))
				error("Logger.setlevel: LEVEL must be a single number");
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

			if (level >= self.loglevel)
				if (!isempty(varargin))
					msg = sprintf(msg, varargin{:});
				endif
				if (!isempty(category))
					msg = [category ": " msg];
				endif
				fdisp(self.destination, msg);
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
classdef Logger < handle
	properties (Access = private)
		loglevel = logging.Level.INFO;
		destination = stdout();
		destinationprivate = false;
		sf = 3;
	endproperties

	methods
		function self = Logger()
			## Do nothing
		endfunction

		function delete(self)
			self.cleandestination();
		endfunction

		function trace(self, msg, varargin)
			self.logmsg(logging.Level.TRACE, self.sf, msg, varargin{:});
		endfunction

		function debug(self, msg, varargin)
			self.logmsg(logging.Level.DEBUG, self.sf, msg, varargin{:});
		endfunction

		function info(self, msg, varargin)
			self.logmsg(logging.Level.INFO, self.sf, msg, varargin{:});
		endfunction

		function warn(self, msg, varargin)
			self.logmsg(logging.Level.WARNING, self.sf, msg, varargin{:});
		endfunction

		function error(self, msg, varargin)
			self.logmsg(logging.Level.ERROR, self.sf, msg, varargin{:});
		endfunction

		function fatal(self, msg, varargin)
			self.logmsg(logging.Level.FATAL, self.sf, msg, varargin{:});
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
	endmethods

	methods (Access = private)
		function logmsg(self, level, sf, msg, varargin)
			## Obtain category name
			stack = dbstack();
			if (length(dbstack) >= sf)
				category = stack(sf).name;
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
			endif
			lgr = logger;
		endfunction
	endmethods
endclassdef
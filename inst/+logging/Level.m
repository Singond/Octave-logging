classdef Level
	properties (Constant = true)
		ALL = 0;
		TRACE = 100;
		DEBUG = 200;
		INFO = 300;
		WARNING = 400;
		ERROR = 500;
		FATAL = 600;
		OFF = Inf;
	endproperties
endclassdef
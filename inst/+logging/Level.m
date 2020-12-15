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
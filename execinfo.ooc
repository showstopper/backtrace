include /usr/include/execinfo

backtrace: extern func (__Array: Void**, __Size: Int) -> Int
backtraceSymbols: extern(backtrace_symbols) func (__Array: const Void**, __Size: Int) -> Char**
backtraceSymbolsFd: extern(backtrace_symbols_fd) func (__Array: const Void**, __Size: Int, __Fd: Int)


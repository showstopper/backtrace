//use coredumper // google-coredumper, to create own core-dumps

// quick 'n' (very) dirty covering
include signal
signal: extern func(Int, Pointer)
SIGSEGV: extern Int

import os/[Process,Terminal,Time,unistd] // For fancy output + gdb
import structs/ArrayList
//import coredumper
import execinfo // For writing the backtrace
getchar: extern func -> Int

doDump: static Bool = false // Create our own dump?
btLength: static Int = 20 // Number of entries printed by backtrace

handler: func(a: Int) {

    //if (doDump)
    //    WriteCoreDump("bt.core") // We have to save the app's state asap || Change naming
    
    Terminal setFgColor(Color red) // Fancy output
    "A serious and unrecoverable error (=Segmentation fault) occured. " print()
    if (doDump)
        "Core dump written." println() // Pt. 2 so the message makes sense
    
    // Partly stolen from the manpage example
    buffer: Pointer*[btLength]
    strings: String*
    len := backtrace(buffer as Pointer*, btLength); // rock complains without the type-casting
    strings = backtraceSymbols(buffer as Pointer*, len)
    if (strings) { // On error, strings points to `null`
        "\n[backtrace]" println()
        Terminal reset()
        for (i in 0..len) {
            strings[i] as String println()
        }
    }
    free(strings) // space was allocated by backtrace[Symbols]
    
    Terminal setFgColor(Color red)
    "\nInvoke gdb? [yn]" println()
    Terminal reset() 
    c := getchar() 
    match (c) {
        case 'y' => {
            Terminal setFgColor(Color green)
            "To generate a core dump, type 'generate-core-file' in the gdb-prompt" println()
            Terminal reset()
            Process new(["gdb", "--pid=%d" format( getpid() ), "-q"]) execute()
        }
        case 'n' => "Never mind, shutting down." println(); exit(0)
        case     => exit(0)
    }    
}

setBacktraceLength: func { btLength = 20 }
enableCoreDump: func { 
    
    // Version without google-coredumper:
    // Following snippet does the same as `ulimit -c unlimited`
    // But: When invoking our own signal handler, no core dump is written
    // Alternative 1: Don't register a handler function, use setrlimit (s. below)
    //  => The dump is automatically created
    //  ==> But nothing is printed
    // Alternative 2: Use google's coredumper     
    //  => We create our own dump & let our handler function print awesome things
    //  ==> But the library is a "heavy" dependency (.a file's ~ 200k)
    // Alternative 3: Use gdb to generate the dump 
    //  => gdb creates our core-dump and the handler would still work
    //  => The user can decide if to create a core dump
    //  ==> The user has to be aware of this (cli-argument for gdb to create core-dump?) 
    
    //a: RLimitStruct
    //a rlimCur = RLIM_INFINITY
    //a rlimMax = RLIM_INFINITY
    //setrlimit(RLIMIT_CORE, a&)
    doDump = true 
}

enableBacktracing: func {
    f: Pointer = handler // ugly workaround, rock passes Closure-struct otherwise
    signal(SIGSEGV,f)
}

test: func(a: ArrayList<Int>) { a add(41) } // Our segfaulting example

main: func {
    enableBacktracing()
    //enableCoreDump()
    test(null)
}


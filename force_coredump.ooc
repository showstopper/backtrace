import resource
import structs/ArrayList

test: func(a: ArrayList<Int>) { a add(42) }
enableCoreDumping: func {
    a: RLimitStruct
    a rlimCur = RLIM_INFINITY
    a rlimMax = RLIM_INFINITY
    setrlimit(RLIMIT_CORE, a&)
}

main: func {
    enableCoreDumping()   
    test(null)
}

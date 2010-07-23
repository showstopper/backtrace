include sys/resource

RLimitStruct: cover from struct rlimit{
    rlimCur: extern(rlim_cur) UInt
    rlimMax: extern(rlim_max) UInt
}

RLIM_INFINITY: extern Int
RLIMIT_CORE: extern Int

setrlimit: extern func(Int, RLimitStruct*)
//a: RLimitStruct
    //a rlimCur = RLIM_INFINITY
    //a rlimMax = RLIM_INFINITY
    //setrlimit(RLIMIT_CORE, a&)


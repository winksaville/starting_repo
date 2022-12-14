#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

# Use `cargo asm --lib starting_repo` to see list of functions
gen_lib_asm () {
    #cargo asm --rust --lib "starting_repo::$1" > asm/$1.txt
    cargo asm --lib "starting_repo::$1" > asm/$1.txt
}

# Use `cargo asm --bin starting_repo` to see list of functions
gen_bin_asm () {
    #cargo asm --rust --bin starting_repo "starting_repo::$1" > asm/$1.txt
    cargo asm --bin starting_repo "starting_repo::$1" > asm/$1.txt
}

# Use `cargo asm --bench iai` to see list of functions
gen_iai_asm() {
    #cargo asm --rust --bench iai "iai::iai_wrappers::$1" > asm/$1.txt
    cargo asm --bench iai "iai::iai_wrappers::$1" > asm/$1.txt
}

# Use `cargo asm --bench crit` to see list of functions
gen_crit_asm() {
    #cargo asm --rust --bench crit "crit::$1" > asm/$1.txt
    cargo asm --bench crit "crit::$1" > asm/$1.txt
}

gen_lib_asm "add"
gen_bin_asm "main"

gen_iai_asm "iai_add"

# If I look for "crit::":
#    $ cargo asm --bench crit | rg 'crit::'
#        Finished release [optimized] target(s) in 0.02s
#    "core::ptr::drop_in_place<core::iter::adapters::map::map_fold<&u64,f64,(),<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}},core::iter::traits::iterator::Iterator::for_each::call<f64,<alloc::vec::Vec<f64> as alloc::vec::spec_extend::SpecExtend<f64,core::iter::adapters::map::Map<core::slice::iter::Iter<u64>,<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}}>>>::spec_extend::{{closure}}>::{{closure}}>::{{closure}}>" [12]
#    "crit::main" [1690]
#
# I only find the two routines, "core::ptr...." and "crit::main". "core::ptr...." disassembles to two instructions:
#    $ cargo asm --bench crit "core::ptr::drop_in_place<core::iter::adapters::map::map_fold<&u64,f64,(),<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}},core::iter::traits::iterator::Iterator::for_each::call<f64,<alloc::vec::Vec<f64> as alloc::vec::spec_extend::SpecExtend<f64,core::iter::adapters::map::Map<core::slice::iter::Iter<u64>,<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}}>>>::spec_extend::{{closure}}>::{{closure}}>::{{closure}}>"
#        Finished release [optimized] target(s) in 0.02s
#    .section ".text.core::ptr::drop_in_place<core::iter::adapters::map::map_fold<&u64,f64,(),<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}},core::iter::traits::iterator::Iterator::for_each::call<f64,<alloc::vec::Vec<f64> as alloc::vec::spec_extend::SpecExtend<f64,core::iter::adapters::map::Map<core::slice::iter::Iter<u64>,<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}}>>>::spec_extend::{{closure}}>::{{closure}}>::{{closure}}>","ax",@progbits
#    	.p2align	4, 0x90
#    	.type	core::ptr::drop_in_place<core::iter::adapters::map::map_fold<&u64,f64,(),<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}},core::iter::traits::iterator::Iterator::for_each::call<f64,<alloc::vec::Vec<f64> as alloc::vec::spec_extend::SpecExtend<f64,core::iter::adapters::map::Map<core::slice::iter::Iter<u64>,<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}}>>>::spec_extend::{{closure}}>::{{closure}}>::{{closure}}>,@function
#    core::ptr::drop_in_place<core::iter::adapters::map::map_fold<&u64,f64,(),<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}},core::iter::traits::iterator::Iterator::for_each::call<f64,<alloc::vec::Vec<f64> as alloc::vec::spec_extend::SpecExtend<f64,core::iter::adapters::map::Map<core::slice::iter::Iter<u64>,<criterion::routine::Function<criterion::measurement::WallTime,criterion::benchmark_group::BenchmarkGroup<criterion::measurement::WallTime>::bench_function<criterion::benchmark_group::BenchmarkId,crit::crit_add::{{closure}}>::{{closure}},()> as criterion::routine::Routine<criterion::measurement::WallTime,()>>::bench::{{closure}}>>>::spec_extend::{{closure}}>::{{closure}}>::{{closure}}>:
#  
#    	.cfi_startproc
#    	mov qword ptr [rdi], rsi
#  
#    	ret
#
# And "crit::main" is large and it does not contain any references to "crit_add"
#    $ cargo asm --bench crit "crit::main" | rg crit_add
#        Finished release [optimized] target(s) in 0.02s
#
# But if I add `--rust` I see the "criterion_group!" macro
#    $ cargo asm --rust --bench crit "crit::main" | rg "crit_add"
#        Finished release [optimized] target(s) in 0.02s
#    		criterion_group!(benches, crit_add,);
#
# So I'm not using `gen_crit_asm`.

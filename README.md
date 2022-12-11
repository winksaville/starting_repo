# Starting rust repo with benches and asm-output

A starting repo for Rust projects where
benches and asm-output are desired.

## Run:

```
$ cargo run
   Compiling starting_repo v0.1.0 (/home/wink/prgs/rust/myrepos/starting_repo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.19s
     Running `target/debug/starting_repo`
6
$ cargo run --release
    Finished release [optimized] target(s) in 0.01s
     Running `target/release/starting_repo`
6
```

## Benchmarks:

I can get very different results in the `iai` benchmarks using
`cargo bench` compared to `taskset -c 0 cargo bench`.

For instance:

`cargo bench`:
```
bench_iai_add
  Instructions:                  22
```

`taskset -c 0 cargo bench`:
```
bench_iai_add
  Instructions:                   0 (-100.0000%)
```

Compile:
```
$ cargo clean
$ cargo bench --no-run
   Compiling autocfg v1.1.0
   Compiling proc-macro2 v1.0.47
   ..
   Compiling tinytemplate v1.2.1
   Compiling criterion v0.4.0
    Finished bench [optimized] target(s) in 22.43s
  Executable benches src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)
  Executable benches src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)
  Executable benches/bench_crit.rs (target/release/deps/bench_crit-2a33bdb312ecd887)
  Executable benches/bench_iai.rs (target/release/deps/bench_iai-d6a3fa34f5e6b40e)
```

`cargo bench`:
```
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/bench_crit.rs (target/release/deps/bench_crit-2a33bdb312ecd887)
add                     time:   [1.1402 ns 1.1405 ns 1.1408 ns]
Found 9 outliers among 100 measurements (9.00%)
  5 (5.00%) high mild
  4 (4.00%) high severe

     Running benches/bench_iai.rs (target/release/deps/bench_iai-d6a3fa34f5e6b40e)
bench_iai_add
  Instructions:                  22
  L1 Accesses:                   35
  L2 Accesses:                    1
  RAM Accesses:                   2
  Estimated Cycles:             110
```

`taskset -c 0 cargo bench`:
```
$ taskset -c 0 cargo bench
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/bench_crit.rs (target/release/deps/bench_crit-2a33bdb312ecd887)
add                     time:   [1.0911 ns 1.0914 ns 1.0917 ns]
                        change: [-4.3348% -4.3007% -4.2636%] (p = 0.00 < 0.05)
                        Performance has improved.
Found 9 outliers among 100 measurements (9.00%)
  4 (4.00%) high mild
  5 (5.00%) high severe

     Running benches/bench_iai.rs (target/release/deps/bench_iai-d6a3fa34f5e6b40e)
bench_iai_add
  Instructions:                   0 (-100.0000%)
  L1 Accesses:                    0 (-100.0000%)
  L2 Accesses:                    1 (No change)
  RAM Accesses:                   2 (No change)
  Estimated Cycles:              75 (-31.81818%)
```

If I look at the "asm" code there are 2 instructions in the `add` function:
```
$ cat -n asm/add.txt 
     1  .section .text.starting_repo::add,"ax",@progbits
     2          .globl  starting_repo::add
     3          .p2align        4, 0x90
     4          .type   starting_repo::add,@function
     5  starting_repo::add:
     6
     7          .cfi_startproc
     8          lea rax, [rdi + rsi]
     9          ret
    10
    11          .size   starting_repo::add, .Lfunc_end0-starting_repo::add
```

And `8` instructions in the `bench_iai_add` function:
```
$ cat -n asm/bench_iai_add.txt 
     1  .section .text.bench_iai::iai_wrappers::bench_iai_add,"ax",@progbits
     2          .p2align        4, 0x90
     3          .type   bench_iai::iai_wrappers::bench_iai_add,@function
     4  bench_iai::iai_wrappers::bench_iai_add:
     5
     6          .cfi_startproc
     7          push rax
     8          .cfi_def_cfa_offset 16
     9
    10          mov edi, 2
    11          mov esi, 2
    12          call qword ptr [rip + starting_repo::add@GOTPCREL]
    13          mov qword ptr [rsp], rax
    14
    15          mov rax, qword ptr [rsp]
    16
    17          pop rax
    18          .cfi_def_cfa_offset 8
    19          ret
    20
    21          .size   bench_iai::iai_wrappers::bench_iai_add, .Lfunc_end5-bench_iai::iai_wrappers::bench_iai_add
```

So a plausible number of instructions is `10` not `22` or `0`.


## Asm code

The assembler code can be found at [/asm](/asm)
and is generated with [`./gen_asm.sh`](/gen_asm.sh).



## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.

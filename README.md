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
iai_add
  Instructions:                   8
```

`taskset -c 0 cargo bench`:
```
iai_add
  Instructions:                  22 (+175.0000%)
```

```
$ cargo bench --no-run
...
   Compiling tinytemplate v1.2.1
   Compiling criterion v0.4.0
    Finished bench [optimized] target(s) in 22.15s
  Executable benches src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)
  Executable benches src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)
  Executable benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
  Executable benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
wink@3900x 22-12-12T18:19:22.093Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo bench
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
crit_add                time:   [1.0868 ns 1.0880 ns 1.0896 ns]
Found 13 outliers among 100 measurements (13.00%)
  6 (6.00%) high mild
  7 (7.00%) high severe

     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                   8
  L1 Accesses:                   13
  L2 Accesses:                    1
  RAM Accesses:                   2
  Estimated Cycles:              88

wink@3900x 22-12-12T18:19:50.954Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ taskset -c 0 cargo bench
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
crit_add                time:   [1.0937 ns 1.0944 ns 1.0954 ns]
                        change: [+0.4918% +0.6701% +0.8654%] (p = 0.00 < 0.05)
                        Change within noise threshold.
Found 12 outliers among 100 measurements (12.00%)
  7 (7.00%) high mild
  5 (5.00%) high severe

     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                  22 (+175.0000%)
  L1 Accesses:                   35 (+169.2308%)
  L2 Accesses:                    1 (No change)
  RAM Accesses:                   2 (No change)
  Estimated Cycles:             110 (+25.00000%)

wink@3900x 22-12-12T18:20:12.195Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
```

But I then closed IDE and the terminal started and rebooted
and started over with `cargo clean`. And now we have different results:

`cargo bench`:
```
iai_add
  Instructions:                  22
```

`taskset -c 0 cargo bench`:
```
iai_add
  Instructions:                   0 (-100.0000%)
```

Here is the complete output:
```
wink@3900x 22-12-12T18:24:39.743Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo clean
wink@3900x 22-12-12T18:24:44.862Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo bench --no-run
...
   Compiling tinytemplate v1.2.1
   Compiling criterion v0.4.0
    Finished bench [optimized] target(s) in 22.18s
  Executable benches src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)
  Executable benches src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)
  Executable benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
  Executable benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
wink@3900x 22-12-12T18:25:14.276Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo bench
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
crit_add                time:   [1.0850 ns 1.0852 ns 1.0856 ns]
Found 12 outliers among 100 measurements (12.00%)
  1 (1.00%) low mild
  3 (3.00%) high mild
  8 (8.00%) high severe

     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                  22
  L1 Accesses:                   35
  L2 Accesses:                    1
  RAM Accesses:                   2
  Estimated Cycles:             110

wink@3900x 22-12-12T18:25:40.480Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ taskset -c 0 cargo bench
    Finished bench [optimized] target(s) in 0.03s
     Running unittests src/lib.rs (target/release/deps/starting_repo-4b1b0b7ec0e6c1bc)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/starting_repo-3ab7a8d6ce58c4d8)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/crit.rs (target/release/deps/crit-6f4e4ad7e11db919)
crit_add                time:   [1.0920 ns 1.0924 ns 1.0929 ns]
                        change: [+0.5885% +0.6284% +0.6668%] (p = 0.00 < 0.05)
                        Change within noise threshold.
Found 2 outliers among 100 measurements (2.00%)
  2 (2.00%) high mild

     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                   0 (-100.0000%)
  L1 Accesses:                    3 (-91.42857%)
  L2 Accesses:                    0 (-100.0000%)
  RAM Accesses:                   0 (-100.0000%)
  Estimated Cycles:               3 (-97.27273%)

wink@3900x 22-12-12T18:26:04.701Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ taskset -c 0 cargo bench --bench iai
    Finished bench [optimized] target(s) in 0.02s
     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                   0 (No change)
  L1 Accesses:                    3 (No change)
  L2 Accesses:                    0 (No change)
  RAM Accesses:                   0 (No change)
  Estimated Cycles:               3 (No change)

wink@3900x 22-12-12T18:26:28.749Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ taskset -c 0 cargo bench --bench iai
    Finished bench [optimized] target(s) in 0.02s
     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                   0 (No change)
  L1 Accesses:                    3 (No change)
  L2 Accesses:                    0 (No change)
  RAM Accesses:                   0 (No change)
  Estimated Cycles:               3 (No change)

wink@3900x 22-12-12T18:26:30.662Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ taskset -c 0 cargo bench --bench iai
    Finished bench [optimized] target(s) in 0.02s
     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                   0 (No change)
  L1 Accesses:                    3 (No change)
  L2 Accesses:                    0 (No change)
  RAM Accesses:                   0 (No change)
  Estimated Cycles:               3 (No change)

wink@3900x 22-12-12T18:26:32.077Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo bench --bench iai
    Finished bench [optimized] target(s) in 0.02s
     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                  22 (  +inf%)
  L1 Accesses:                   35 (+1066.667%)
  L2 Accesses:                    1 (  +inf%)
  RAM Accesses:                   2 (  +inf%)
  Estimated Cycles:             110 (+3566.667%)

wink@3900x 22-12-12T18:26:36.860Z:~/prgs/rust/myrepos/starting_repo (rename-benches)
$ cargo bench --bench iai
    Finished bench [optimized] target(s) in 0.02s
     Running benches/iai.rs (target/release/deps/iai-73c5eda9b6c909cb)
iai_add
  Instructions:                  22 (No change)
  L1 Accesses:                   35 (No change)
  L2 Accesses:                    1 (No change)
  RAM Accesses:                   2 (No change)
  Estimated Cycles:             110 (No change)

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
$ cat -n asm/iai_add.txt 
     1  .section .text.iai::iai_wrappers::iai_add,"ax",@progbits
     2          .p2align        4, 0x90
     3          .type   iai::iai_wrappers::iai_add,@function
     4  iai::iai_wrappers::iai_add:
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
    21          .size   iai::iai_wrappers::iai_add, .Lfunc_end5-iai::iai_wrappers::iai_add
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

use criterion::{criterion_group, criterion_main, Criterion};
use starting_repo::add;
use std::hint::black_box;

#[allow(unused)]
fn crit_add(c: &mut Criterion) {
    c.bench_function("crit_add", |b| {
        b.iter(|| black_box(add(2, 2)));
    });
}

criterion_group!(benches, crit_add,);
criterion_main!(benches);

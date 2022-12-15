use starting_repo::add;
use std::hint::black_box;

fn iai_add() {
    black_box(add(2, 2));
}

iai::main!(iai_add,);

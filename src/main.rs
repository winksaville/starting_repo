use starting_repo::add;

fn main() {
    let r = add(3, 3);
    assert_eq!(r, 6);
    println!("{r}");
}

use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};

fn main() {
    let stdout = Command::new(env!("MMSG_PATH"))
        .args(["watch", "keymode"])
        .stdout(Stdio::piped())
        .spawn().expect("Failed to start mmsg.")
        .stdout.expect("Failed to capture stdout.");

    BufReader::new(stdout).lines()
        .map_while(Result::ok)
        .filter_map(|line| line.split("\"").nth(3).map(String::from))
        .for_each(|word| println!("{}", word));
}

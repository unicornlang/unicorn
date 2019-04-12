extern crate pest;
#[macro_use]
extern crate pest_derive;
use std::fs;
use pest::Parser;

#[derive(Parser)]
#[grammar = "unicorn.pest"]
pub struct UnicornParser;

fn main() {
    let contents = fs::read_to_string("test.u")
        .expect("Something went wrong reading the file");
    let successful_parse = UnicornParser::parse(Rule::program, &contents).expect("could not parse");
    println!("{:?}", successful_parse.as_str());

}

use std::fs;

fn swap(char: &mut u8) {
    *char = if *char == b'.' { b'#' } else { b'.' }
}

fn base_value(lines: &[Vec<u8>], smudged_line: usize) -> Option<i32> {
    for i in 0..lines.len() - 1 {
        for delta in 0..lines.len() {
            if i < delta || i + 1 + delta >= lines.len() {
                if i + 1 > delta + smudged_line || i + delta < smudged_line {
                    break;
                }
                return Some(i as i32 + 1);
            }
            if lines[i - delta] != lines[i + delta + 1] {
                break;
            }
        }
    }
    None
}

#[derive(Debug)]
struct Pattern {
    lines: Vec<Vec<u8>>,
    columns: Vec<Vec<u8>>,
}

impl Pattern {
    fn value(&mut self) -> i32 {
        for i in 0..self.lines.len() {
            for j in 0..self.columns.len() {
                swap(&mut self.lines[i][j]);
                if let Some(v) = base_value(&self.lines, i) {
                    return v * 100
                }
                swap(&mut self.lines[i][j]);
            }
        }
        for i in 0..self.columns.len() {
            for j in 0..self.lines.len() {
                swap(&mut self.columns[i][j]);
                if let Some(v) = base_value(&self.lines, i) {
                    return v
                }
                swap(&mut self.columns[i][j]);
            }
        }
        panic!("no reflection found!");
    }
}

fn parse(source: &str) -> Vec<Pattern> {
    let mut ret: Vec<Pattern> = Vec::new();
    for block in source.split("\n\n") {
        let lines: Vec<Vec<u8>> = block.lines().map(|l| l.bytes().collect()).collect();
        if lines.is_empty() {
            break;
        }
        let columns: Vec<Vec<u8>> = (0..lines[0].len())
            .map(|i| lines.iter().map(|line| line[i]).collect())
            .collect();
        ret.push(Pattern { lines, columns });
    }
    ret
}

fn main() -> std::io::Result<()> {
    //let f = "test_input.txt";
    let f = "input.txt";
    let input: String = fs::read_to_string(f)?;
    let mut patterns = parse(&input);
    let sum: i32 = patterns.iter_mut().map(|p| p.value()).sum();
    println!("{sum}");
    Ok(())
}

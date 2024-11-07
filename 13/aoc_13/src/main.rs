use std::fs;

fn swap(char: &mut u8) {
    if *char == b'.' {
        *char = b'#'
    } else {
        *char = b'.'
    }
}

fn base_value(lines: &Vec<Vec<u8>>, smudged_line: i32) -> Option<i32> {
    for i in 0..lines.len() as i32 - 1 {
        for delta in 0..lines.len() as i32 {
            //dbg!(i, delta);
            if i - delta < 0 || i + 1 + delta >= lines.len() as i32 {
                if i - delta + 1 > smudged_line || i + delta < smudged_line {
                    break;
                }
                return Some(i + 1);
            }
            if lines[(i - delta) as usize] != lines[(i + delta + 1) as usize] {
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
                match base_value(&self.lines, i as i32) {
                    Some(v) => return v * 100,
                    None => (),
                }
                swap(&mut self.lines[i][j]);
            }
        }
        for i in 0..self.columns.len() {
            for j in 0..self.lines.len() {
                swap(&mut self.columns[i][j]);
                match base_value(&self.columns, i as i32) {
                    Some(v) => {
                        //dbg!(i, j);
                        return v;
                    }
                    None => (),
                }
                swap(&mut self.columns[i][j]);
            }
        }
        panic!("no reflection found!");
    }
}

fn parse(source: &str) -> Vec<Pattern> {
    let mut ret: Vec<Pattern> = Vec::new();
    let mut buffer_lines: Vec<Vec<u8>> = Vec::new();
    let mut buffer_cols: Vec<Vec<u8>> = Vec::new();
    let mut last_char = b' ';
    let mut row_number = 0;
    let mut col_number = 0;

    for char in source.bytes() {
        if char == b'\n' {
            row_number += 1;
            col_number = 0;
            if last_char == b'\n' {
                ret.push(Pattern {
                    // TODO: use take or mem::swap?
                    lines: buffer_lines.clone(),
                    columns: buffer_cols.clone(),
                });
                buffer_lines = Vec::new();
                buffer_cols = Vec::new();
                row_number = 0;
            } else {
                last_char = b'\n';
            }
        } else {
            if col_number == 0 {
                buffer_lines.push(Vec::new());
            }
            if row_number == 0 {
                buffer_cols.push(Vec::new());
            }
            buffer_lines[row_number].push(char);
            buffer_cols[col_number].push(char);
            last_char = char;
            col_number += 1;
        }
    }
    ret
}

fn main() -> std::io::Result<()> {
    //let f = "test_input.txt";
    let f = "input.txt";
    let input: String = fs::read_to_string(f)?;
    let mut patterns = parse(&input);
    //println!("{}", patterns[1].value());
    let sum :i32 = patterns.iter_mut().map(|p| p.value()).sum();
    println!("{sum}");
    Ok(())
}

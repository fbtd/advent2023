use std::error::Error;
use std::fmt;
use std::fs;
use std::path::Path;

enum SlotKind {
    Free,
    RoundRock,
    CubeRock,
}

struct Dish {
    columns: Vec<Vec<SlotKind>>,
}

impl Dish {
    fn new(str: &str) -> Self {
        let mut columns: Vec<Vec<SlotKind>> = Vec::new();
        let mut is_first_line: bool = true;

        for line in str.lines() {
            if line == "" {
                break;
            }
            for (i, char) in line.chars().enumerate() {
                let slot = match char {
                    '.' => SlotKind::Free,
                    'O' => SlotKind::RoundRock,
                    '#' => SlotKind::CubeRock,
                    _ => panic!("unexpected character found"),
                };
                if is_first_line {
                    let column: Vec<SlotKind> = vec![slot];
                    columns.push(column);
                } else {
                    columns[i].push(slot);
                }
            }
            is_first_line = false;
        }
        Dish { columns }
    }

}

impl fmt::Display for Dish {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut column_str = String::new();
        for (i, column) in self.columns.iter().enumerate() {
            for slot in column {
                match slot {
                    SlotKind::Free => column_str.push_str("."),
                    SlotKind::RoundRock => column_str.push_str("O"),
                    SlotKind::CubeRock => column_str.push_str("#"),
                }
            }
            write!(f, "{}: {}\n", i, column_str);
            column_str = String::new();
        }
        Ok(())
    }
}

fn calculate_weight(column: &Vec<SlotKind>) -> i32 {
    let len = column.len();
    let mut weight: i32 = 0;
    let mut i = 0;
    let mut free_slots = 0;
    while i < len {
        match column[i] {
            SlotKind::Free => {
                free_slots += 1;
            }
            SlotKind::RoundRock => {
                weight += (len - i + free_slots) as i32;
            }
            SlotKind::CubeRock => {
                free_slots = 0;
            }
        }
        i += 1;
    }
    weight
}

fn main() -> Result<(), Box<dyn Error>> {
    let input_file = std::env::args().nth(1).expect("No input file");
    let input_string = fs::read_to_string(&input_file)?;
    let dish = Dish::new(&input_string);
    println!("{dish}");
    let total_weight = &dish
        .columns
        .iter()
        .map(|c| calculate_weight(c))
        .sum::<i32>();
    println!("{total_weight}");
    Ok(())
}

use std::error::Error;
use std::fmt;
use std::fs;
use std::path::Path;

#[derive(PartialEq)]
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

////////////
// PART 2 //
////////////

struct FlatDish {
    slots: Vec<SlotKind>,
    height: usize,
    width: usize,
}

impl FlatDish {
    fn new(str: &str) -> Self {
        let mut slots: Vec<SlotKind> = Vec::new();
        let mut is_first_line: bool = true;
        let mut height: usize = 2;
        let mut width: usize = 2;

        slots.insert(0, SlotKind::CubeRock);
        slots.insert(0, SlotKind::CubeRock);
        slots.insert(0, SlotKind::CubeRock);
        for c in str.chars() {
            let slot = match c {
                '.' => SlotKind::Free,
                'O' => SlotKind::RoundRock,
                '#' => SlotKind::CubeRock,
                '\n' => {
                    is_first_line = false;
                    height += 1;
                    slots.push(SlotKind::CubeRock);
                    SlotKind::CubeRock
                }
                _ => panic!("unexpected character found"),
            };
            slots.push(slot);
            if is_first_line {
                width += 1;
                slots.insert(0, SlotKind::CubeRock);
            }
        }
        for _ in 0..width - 1 {
            slots.push(SlotKind::CubeRock);
        }

        FlatDish {
            slots,
            width,
            height,
        }
    }

    fn spin(&mut self) {
        let deltas = [
            self.height as i32 * -1, // NORTH
            -1,                      // WEST
            self.height as i32,      // SOUTH
            1,                       // EAST
        ];
        let mut something_moved: bool = true;
        for delta in deltas.iter() {
            something_moved = true;
            while something_moved {
                something_moved = false;
                for i in 0..self.height * self.width {
                    if i < self.width
                        || i > self.width * (self.height - 1)
                        || i % self.width == 0
                        || (i + 1) % self.width == 0
                    {
                        continue;
                    }
                    let prev_i = i as i32 + delta;
                    let prev = &self.slots[prev_i as usize];
                    let this = &self.slots[i];
                    if *prev == SlotKind::Free && *this == SlotKind::RoundRock {
                        self.slots.swap(prev_i as usize, i);
                        something_moved = true;
                    }
                }
            }
        }
    }

    fn total_weight(&self) -> i32 {
        let mut weight: i32 = 0;
        for i in 0..self.height * self.width {
            if self.slots[i] == SlotKind::RoundRock {
                weight += self.height as i32 - 1 - (i as i32 / (self.width as i32));
            }
        }
        weight
    }
}

impl fmt::Display for FlatDish {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut s = String::new();
        s.push_str("\n");
        for (i, slot) in self.slots.iter().enumerate() {
            match slot {
                SlotKind::Free => s.push_str("."),
                SlotKind::RoundRock => s.push_str("O"),
                SlotKind::CubeRock => s.push_str("#"),
            }
            if i % self.width == self.width - 1 {
                s.push_str("\n");
            }
        }
        write!(f, "({}x{}): {}", self.width, self.height, s)
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let input_file = std::env::args().nth(1).expect("No input file");
    let input_string = fs::read_to_string(&input_file)?;

    // PART 1:
    //let dish = Dish::new(&input_string);
    //println!("{dish}");
    //let total_weight = &dish
    //    .columns
    //    .iter()
    //    .map(|c| calculate_weight(c))
    //    .sum::<i32>();
    //println!("{total_weight}");

    // PART 2:
    let mut flat_dish = FlatDish::new(&input_string);
    println!("{flat_dish}");
    for i in 0..1000000000 {
        flat_dish.spin();
        if i >= 10000-1 {
            println!("{},{}", i + 1, flat_dish.total_weight());
        }
        if i > 10100 {
            break;
        }
    }
    //println!("{flat_dish}");
    //println!("{}", flat_dish.total_weight());
    Ok(())
}

use std::io::stdin;

fn part1() -> u64 {
    let lines = stdin().lines();
    let mut numbers = vec![];
    let mut res = 0;

    for (line_num, line) in lines.enumerate() {
        let line = line.unwrap();
        let nums = line.split_whitespace();

        for (i, number) in nums.enumerate() {
            if let Ok(number) = number.parse::<u64>() {
                if line_num == 0 {
                    numbers.push(vec![number]);
                } else {
                    numbers[i].push(number);
                }
            } else {
                res += match number {
                    "+" => numbers[i].iter().fold(0, |x, a| x + a),
                    "*" => numbers[i].iter().fold(1, |x, a| x * a),
                    _ => panic!(""),
                }
            }
        }
    }

    res
}

fn part2() -> u64 {
    let lines = stdin()
        .lines()
        .map(|x| {
            x.unwrap()
                .as_bytes()
                .to_vec()
                .into_iter()
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    let mut res = 0;

    let mut current_start = 0;
    let last_line = lines.last().unwrap();

    while current_start < last_line.len() {
        assert!(last_line[current_start] != b' ');

        let next = last_line[current_start + 1..]
            .iter()
            .position(|x| *x != b' ')
            .unwrap_or(last_line.len() - current_start)
            + current_start
            + 1;

        let len = next - current_start - 1;
        let mut numbers = vec![0u64; len];

        for (i, pos) in (current_start..next - 1).rev().enumerate() {
            for line in 0..lines.len() - 1 {
                let chr = lines[line][pos];

                if chr != b' ' {
                    let digit = chr - b'0';

                    numbers[i] *= 10;
                    numbers[i] += digit as u64;
                }
            }
        }

        res += match last_line[current_start] {
            b'+' => numbers.iter().fold(0, |x, a| x + a),
            b'*' => numbers.iter().fold(1, |x, a| x * a),
            _ => panic!(""),
        };

        current_start = next;
    }

    res
}

fn main() {
    println!("{}", part2());
}

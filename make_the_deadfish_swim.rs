// For the kata, see https://www.codewars.com/kata/make-the-deadfish-swim
// To run the tests, use
// cargo script --test make_the_deadfish_swim.rs

fn parse(code: &str) -> Vec<i32> {
    let mut result: Vec<i32> = Vec::new();
    let mut value = 0;
    for command in code.chars() {
        match command {
            'o' => result.push(value),
            'i' => value += 1,
            'd' => value -= 1,
            's' => value *= value,
            _ => (),
        }
    }
    result
}

#[cfg(test)]
mod tests {
    use parse;
    #[test]
    fn sample_tests() {
        assert_eq!(parse(""), []);
        assert_eq!(parse("o"), [0]);
        assert_eq!(parse("io"), [1]);
        assert_eq!(parse("iioiio"), [2, 4]);
        assert_eq!(parse("do"), [-1]);
        assert_eq!(parse("iiiiso"), [16]);
        assert_eq!(parse("iiisdoso"), vec![8, 64]);
        assert_eq!(parse("iiisdosodddddiso"), vec![8, 64, 3600]);
        assert_eq!(parse("abc"), vec![]);
    }
}

struct Ingredient {
    prop: [i32; 5],
}

impl Ingredient {
    fn new(s: &str) -> Ingredient {
        let mut v = aoc::ints::<i32>(s);
        Ingredient {
            prop: [
                v.next().unwrap(),
                v.next().unwrap(),
                v.next().unwrap(),
                v.next().unwrap(),
                v.next().unwrap(),
            ],
        }
    }
    fn prop(&self, n: usize) -> i32 {
        self.prop[n]
    }
}

fn score(ingredients: &[Ingredient], amounts: &[usize]) -> (usize, usize) {
    let mut prod: usize = 1;
    for prop in 0..=3 {
        let mut s: i32 = 0;
        for (i, ing) in ingredients.iter().enumerate() {
            s += ing.prop(prop) * amounts[i] as i32;
        }
        if s < 0 {
            s = 0;
        }
        prod *= s as usize;
    }
    if prod == 0 {
        return (0, 0);
    }
    let mut cal: i32 = 0;
    for (i, ing) in ingredients.iter().enumerate() {
        cal += ing.prop(4) * amounts[i] as i32;
    }
    (prod, cal as usize)
}

fn best_recipe(ingredients: &[Ingredient]) -> (usize, usize) {
    let num = 100;
    let types = ingredients.len();
    let mut max1 = 0;
    let mut max2 = 0;
    for var in variations(types, num) {
        let (score, cal) = score(ingredients, &var);
        if max1 < score {
            max1 = score
        }
        if cal == 500 && max2 < score {
            max2 = score
        }
    }
    (max1, max2)
}

fn variations(k: usize, n: usize) -> Vec<Vec<usize>> {
    if k == 1 {
        return vec![vec![n]];
    }
    let mut res: Vec<Vec<usize>> = vec![];
    for i in 0..=n {
        let subres = variations(k - 1, n - i);
        for sr in subres {
            let mut r = sr.clone();
            r.push(i);
            res.push(r);
        }
    }
    res
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let ingredients: Vec<Ingredient> = inp.iter().map(|l| Ingredient::new(l)).collect();
        let (p1, p2) = best_recipe(&ingredients);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn works() {
        let butterscotch = Ingredient::new(
            "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
        );
        let cinnamon = Ingredient::new(
            "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3",
        );
        let ing: Vec<Ingredient> = vec![butterscotch, cinnamon];
        assert_eq!(score(&ing, &vec![44usize, 56]), (62842880, 520), "score");
        assert_eq!(best_recipe(&ing), (62842880, 57600000), "best");
    }
}

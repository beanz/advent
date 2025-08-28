use heapless::Vec;

#[derive(Debug, Copy, Clone)]
enum Attack {
    Bludgeon = 1,
    Cold = 2,
    Fire = 4,
    Radiate = 8,
    Slash = 16,
}

#[derive(Debug, PartialEq, Eq)]
enum Side {
    ImmuneSystem,
    Infection,
}

#[derive(Debug)]
struct Group {
    initial_units: u32,
    initial_hp: u32,
    units: u32,
    hp: u32,
    weak: u32,
    immune: u32,
    damage: u32,
    attack: Attack,
    initiative: u32,
    side: Side,
}

struct Game<'a> {
    groups: &'a mut Vec<Group, 20>,
    boost: u32,
}

impl<'a> Game<'a> {
    fn immune_system_count(&self) -> usize {
        let mut c = 0;
        for grp in &*self.groups {
            if grp.side == Side::ImmuneSystem && grp.hp > 0 {
                c += grp.units as usize;
            }
        }
        c
    }
    fn infection_count(&self) -> usize {
        let mut c = 0;
        for grp in &*self.groups {
            if grp.side == Side::Infection && grp.hp > 0 {
                c += grp.units as usize;
            }
        }
        c
    }
    fn reset(&mut self, boost: u32) {
        self.boost = boost;
        for i in 0..self.groups.len() {
            self.groups[i].hp = self.groups[i].initial_hp;
            self.groups[i].units = self.groups[i].initial_units;
        }
    }
    fn play(&mut self) -> (usize, usize) {
        let (mut c_immune, mut c_infect) = (1, 1);
        let mut progressing = true;
        while c_infect != 0 && c_immune != 0 && progressing {
            let mut target_order = Vec::<(usize, usize), 20>::new();
            self.target_selection(&mut target_order);
            progressing = self.attacks(&target_order);
            (c_immune, c_infect) = (self.immune_system_count(), self.infection_count());
        }
        (c_immune, c_infect)
    }
    fn target_selection(&self, target_order: &mut Vec<(usize, usize), 20>) {
        let mut order: Vec<usize, 20> = (0..self.groups.len()).collect();
        order.sort_by(|i, j| self.cmp_target_selection(*i, *j));
        let mut selected = 0;
        for attacker in &order {
            if !self.alive(*attacker) {
                continue;
            }
            let mut best_target = 99;
            let mut best_damage = 0;
            for target in &order {
                if self.groups[*target].side == self.groups[*attacker].side || !self.alive(*target)
                {
                    continue;
                }
                if selected & (1 << target) != 0 {
                    continue;
                }
                let damage = self.attack_damage(*attacker, *target);
                if damage > best_damage {
                    best_damage = damage;
                    best_target = *target;
                }
            }
            if best_target != 99 {
                target_order
                    .push((*attacker, best_target))
                    .expect("target_order full");
                selected |= 1 << best_target;
            }
        }
        target_order
            .sort_by(|(i, _), (j, _)| self.groups[*j].initiative.cmp(&self.groups[*i].initiative));
    }
    fn attack_damage(&self, attacker: usize, enemy: usize) -> u32 {
        let kind = self.groups[attacker].attack as u32;
        let mul = if self.groups[enemy].weak & kind != 0 {
            2
        } else if self.groups[enemy].immune & kind != 0 {
            0
        } else {
            1
        };
        self.power(attacker) * mul
    }
    fn attacks(&mut self, target_order: &Vec<(usize, usize), 20>) -> bool {
        let mut damage_done = false;
        for (attacker, target) in target_order {
            if !self.alive(*attacker) || !self.alive(*target) {
                continue;
            }
            let mut units = self.attack_damage(*attacker, *target) / self.groups[*target].hp;
            if units > self.groups[*target].units {
                units = self.groups[*target].units
            }
            if units > 0 {
                damage_done = true;
            }
            self.groups[*target].units -= units;
        }
        damage_done
    }
    fn power(&self, i: usize) -> u32 {
        let boost = if self.groups[i].side == Side::ImmuneSystem {
            self.boost
        } else {
            0
        };
        self.groups[i].units * (self.groups[i].damage + boost)
    }
    fn alive(&self, i: usize) -> bool {
        self.groups[i].units > 0
    }
    fn cmp_target_selection(&self, i: usize, j: usize) -> std::cmp::Ordering {
        match self.power(j).cmp(&self.power(i)) {
            std::cmp::Ordering::Equal => self.groups[j].initiative.cmp(&self.groups[i].initiative),
            x => x,
        }
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut groups = Vec::<Group, 20>::new();
    let mut i = 15;
    while i < inp.len() {
        let (j, units, hp, weak, immune, damage, attack, initiative) = read_group(inp, i);
        i = j;
        groups
            .push(Group {
                initial_units: units,
                initial_hp: hp,
                units,
                hp,
                weak,
                immune,
                damage,
                attack,
                initiative,
                side: Side::ImmuneSystem,
            })
            .expect("groups full");
        if inp[i] == b'\n' {
            i += 12;
            break;
        }
    }
    while i < inp.len() {
        let (j, units, hp, weak, immune, damage, attack, initiative) = read_group(inp, i);
        i = j;
        groups
            .push(Group {
                initial_units: units,
                initial_hp: hp,
                units,
                hp,
                weak,
                immune,
                damage,
                attack,
                initiative,
                side: Side::Infection,
            })
            .expect("groups full");
    }
    let mut g = Game {
        groups: &mut groups,
        boost: 0,
    };
    let (mut c_immune, mut c_infect) = g.play();
    let p1 = c_immune + c_infect;
    let mut upper = 16000;
    let mut lower = 0;
    loop {
        g.reset(upper);
        (c_immune, _) = g.play();
        if c_immune != 0 {
            break;
        }
        upper *= 2;
    }
    while upper - lower > 10 {
        let cur = (upper + lower) / 2;
        g.reset(cur);
        (c_immune, c_infect) = g.play();
        if c_immune != 0 && c_infect != 0 {
            upper += 3;
        } else if c_immune == 0 {
            lower = cur;
        } else {
            upper = cur;
        }
        if c_immune != 0 {
            break;
        }
    }
    for boost in lower..=upper {
        g.reset(boost);
        (c_immune, c_infect) = g.play();
        if c_immune != 0 && c_infect == 0 {
            break;
        }
    }
    (p1, c_immune)
}

fn read_group(inp: &[u8], i: usize) -> (usize, u32, u32, u32, u32, u32, Attack, u32) {
    let mut i = i;
    let (j, units) = aoc::read::uint::<u32>(inp, i);
    let (j, hp) = aoc::read::uint::<u32>(inp, j + 17);
    let mut weak = 0;
    let mut immune = 0;
    i = j + 12;
    if inp[i] == b'(' {
        i += 1;
        if inp[i] == b'w' {
            (i, weak) = read_attack(inp, i + 8);
            if inp[i] == b';' && inp[i + 2] == b'i' {
                (i, immune) = read_attack(inp, i + 12);
            }
        }
        if inp[i] == b'i' {
            (i, immune) = read_attack(inp, i + 10);
            if inp[i] == b';' && inp[i + 2] == b'w' {
                (i, weak) = read_attack(inp, i + 10);
            }
        }
        i += 2;
    }
    let (j, damage) = aoc::read::uint::<u32>(inp, i + 25);
    i = j + 1;
    let attack = match inp[i] {
        b'b' => Attack::Bludgeon,
        b'c' => Attack::Cold,
        b'f' => Attack::Fire,
        b'r' => Attack::Radiate,
        b's' => Attack::Slash,
        _ => unreachable!("invalid attack type"),
    };
    i = skip_word(inp, i);
    let (j, initiative) = aoc::read::uint::<u32>(inp, i + 22);
    (j + 1, units, hp, weak, immune, damage, attack, initiative)
}

fn read_attack(inp: &[u8], i: usize) -> (usize, u32) {
    let mut i = i;
    let mut attack = 0;
    while i < inp.len() {
        match inp[i] {
            b'b' => {
                i = skip_word(inp, i);
                attack |= Attack::Bludgeon as u32;
            }
            b'c' => {
                i = skip_word(inp, i);
                attack |= Attack::Cold as u32;
            }
            b'f' => {
                i = skip_word(inp, i);
                attack |= Attack::Fire as u32;
            }
            b'r' => {
                i = skip_word(inp, i);
                attack |= Attack::Radiate as u32;
            }
            b's' => {
                i = skip_word(inp, i);
                attack |= Attack::Slash as u32;
            }
            b',' => {
                i += 2;
            }
            b')' | b';' => {
                break;
            }
            _ => {
                aoc::inp_debug(inp, i);
                unreachable!("unexpected attack type");
            }
        }
    }
    (i, attack)
}

fn skip_word(inp: &[u8], i: usize) -> usize {
    let mut i = i;
    while i < inp.len() {
        match inp[i] {
            b'a'..=b'z' => {}
            b'A'..=b'Z' => {}
            b'0'..=b'1' => {}
            _ => break,
        }
        i += 1;
    }
    i
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/24/test.txt").expect("read error");
        assert_eq!(parts(&inp), (5216, 51));
        let inp = std::fs::read("../2018/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (25524, 4837));
        let inp = std::fs::read("../2018/24/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (26937, 4893));
    }
}

struct D100 {
    count: u32,
}

impl D100 {
    fn new() -> D100 {
        D100 { count: 0 }
    }
    fn roll(&mut self) -> u32 {
        let r = (self.count % 100) + 1;
        self.count += 1;
        r
    }
    fn count(&self) -> u32 {
        self.count
    }
}

fn part1(pp1: u8, pp2: u8) -> u32 {
    let mut s1 = 0;
    let mut s2 = 0;
    let mut p1 = (pp1 as u32) - 1;
    let mut p2 = (pp2 as u32) - 1;
    let mut dice = D100::new();
    loop {
        let r1 = dice.roll() + dice.roll() + dice.roll();
        p1 = (p1 + r1) % 10;
        s1 += p1 + 1;
        if s1 >= 1000 {
            return s2 * dice.count();
        }
        let r2 = dice.roll() + dice.roll() + dice.roll();
        p2 = (p2 + r2) % 10;
        s2 += p2 + 1;
        if s2 >= 1000 {
            return s1 * dice.count();
        }
    }
}

#[allow(dead_code)]
fn part2(pp1: u8, pp2: u8) -> usize {
    let ways: [usize; 7] = [1, 3, 6, 7, 6, 3, 1];
    let mut games: [usize; 21 * 21 * 11 * 11] = [0; 21 * 21 * 11 * 11];
    let mut wins: [usize; 21 * 21 * 11 * 11] = [0; 21 * 21 * 11 * 11];
    for total_score in (0..=40_usize).rev() {
        for s1 in (0..=20_usize).rev() {
            if s1 > total_score {
                continue;
            }
            let s2 = total_score - s1;
            if s2 > 20 {
                continue;
            }
            for p1 in 1..=10 {
                for p2 in 1..=10 {
                    let i = (((s1 * 21) + s2) * 11 + p1) * 11 + p2;
                    for r in 3..=9 {
                        let w = ways[r - 3];
                        let mut np1 = p1 + r;
                        if np1 > 10 {
                            np1 -= 10;
                        }
                        let ns1 = s1 + np1;
                        if ns1 >= 21 {
                            games[i] += w;
                            wins[i] += w;
                        } else {
                            let ii = ((((s2 * 21) + ns1) * 11 + p2) * 11) + np1;
                            games[i] += w * games[ii];
                            wins[i] += w * (games[ii] - wins[ii]);
                        }
                    }
                }
            }
        }
    }
    // for i in 0..121 {
    //     let w1 = wins[i];
    //     let w2 = games[i] - wins[i];
    //     if w1 > w2 {
    //         println!("{}, // {}", w1, i);
    //     } else {
    //         println!("{}, // {}", w2, i);
    //     }
    // }
    let ri = (pp1 as usize) * 11 + (pp2 as usize); // score terms are both 0
    let w1 = wins[ri];
    let w2 = games[ri] - wins[ri];
    if w1 > w2 {
        w1
    } else {
        w2
    }
}

fn u8s(inp: &[u8]) -> Vec<u8> {
    let mut r: Vec<u8> = vec![];
    let mut n: u8 = 0;
    let mut is_num: bool = false;
    for ch in inp {
        match ch {
            48..=57 => {
                // 0 - 9
                is_num = true;
                n = n * 10 + (ch - 48);
            }
            _ => {
                if is_num {
                    r.push(n);
                    n = 0;
                    is_num = false;
                }
            }
        }
    }
    if is_num {
        r.push(n);
    }
    r
}

fn part2lookup(pp1: u8, pp2: u8) -> usize {
    const LOOKUP: [usize; 121] = [
        0,                // 0
        0,                // 1
        0,                // 2
        0,                // 3
        0,                // 4
        0,                // 5
        0,                // 6
        0,                // 7
        0,                // 8
        0,                // 9
        0,                // 10
        0,                // 11
        32491093007709,   // 12
        27674034218179,   // 13
        48868319769358,   // 14
        97774467368562,   // 15
        138508043837521,  // 16
        157253621231420,  // 17
        141740702114011,  // 18
        115864149937553,  // 19
        85048040806299,   // 20
        57328067654557,   // 21
        0,                // 22
        27464148626406,   // 23
        24411161361207,   // 24
        45771240990345,   // 25
        93049942628388,   // 26
        131888061854776,  // 27
        149195946847792,  // 28
        133029050096658,  // 29
        106768284484217,  // 30
        76262326668116,   // 31
        49975322685009,   // 32
        0,                // 33
        51863007694527,   // 34
        45198749672670,   // 35
        93013662727308,   // 36
        193753136998081,  // 37
        275067741811212,  // 38
        309991007938181,  // 39
        273042027784929,  // 40
        214368059463212,  // 41
        147573255754448,  // 42
        92399285032143,   // 43
        0,                // 44
        110271560863819,  // 45
        91559198282731,   // 46
        193170338541590,  // 47
        404904579900696,  // 48
        575111835924670,  // 49
        647608359455719,  // 50
        568867175661958,  // 51
        444356092776315,  // 52
        303121579983974,  // 53
        187451244607486,  // 54
        0,                // 55
        156667189442502,  // 56
        129742452789556,  // 57
        274195599086465,  // 58
        575025114466224,  // 59
        816800855030343,  // 60
        919758187195363,  // 61
        807873766901514,  // 62
        630947104784464,  // 63
        430229563871565,  // 64
        265845890886828,  // 65
        0,                // 66
        175731756652760,  // 67
        146854918035875,  // 68
        309196008717909,  // 69
        647920021341197,  // 70
        920342039518611,  // 71
        1036584236547450, // 72
        911090395997650,  // 73
        712381680443927,  // 74
        486638407378784,  // 75
        301304993766094,  // 76
        0,                // 77
        152587196649184,  // 78
        131180774190079,  // 79
        272847859601291,  // 80
        570239341223618,  // 81
        809953813657517,  // 82
        912857726749764,  // 83
        803934725594806,  // 84
        630797200227453,  // 85
        433315766324816,  // 86
        270005289024391,  // 87
        0,                // 88
        116741133558209,  // 89
        105619718613031,  // 90
        214924284932572,  // 91
        446968027750017,  // 92
        634769613696613,  // 93
        716241959649754,  // 94
        632979211251440,  // 95
        499714329362294,  // 96
        346642902541848,  // 97
        218433063958910,  // 98
        0,                // 99
        83778196139157,   // 100
        75823864479001,   // 101
        148747830493442,  // 102
        306621346123766,  // 103
        435288918824107,  // 104
        492043106122795,  // 105
        437256456198320,  // 106
        348577682881276,  // 107
        245605000281051,  // 108
        157595953724471,  // 109
        0,                // 110
        56852759190649,   // 111
        49982165861983,   // 112
        93726416205179,   // 113
        190897246590017,  // 114
        270803396243039,  // 115
        306719685234774,  // 116
        274291038026362,  // 117
        221109915584112,  // 118
        158631174219251,  // 119
        104001566545663,  // 120
    ];
    LOOKUP[(pp1 as usize) * 11 + pp2 as usize]
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let nums = u8s(&inp);
        let p1 = part1(nums[1], nums[3]);
        let p2 = part2lookup(nums[1], nums[3]);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[test]
fn part1_works() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part1(&ex), 150, "part 1 test");
}

#[test]
fn part2_works() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part2(&ex), 900, "part 2 test");
}
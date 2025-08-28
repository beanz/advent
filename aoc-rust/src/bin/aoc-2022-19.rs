use std::collections::VecDeque;

const ORE: usize = 0;
const CLAY: usize = 1;
const OBSIDIAN: usize = 2;
const GEODE: usize = 3;

#[derive(Debug)]
struct Search {
    t: u8,
    score: usize,
    inv: [u8; 4],
    robots: [u8; 4],
}

#[derive(Debug, Clone, Copy, Default)]
struct Blueprint {
    ore_ore: u8,
    clay_ore: u8,
    obs_ore: u8,
    obs_clay: u8,
    geo_ore: u8,
    geo_obs: u8,
    max_ore: u8,
}

impl Blueprint {
    fn solve(&self, max_time: u8) -> usize {
        let mut todo = VecDeque::with_capacity(35000);
        todo.push_front(Search {
            t: max_time,
            score: 0,
            inv: [0; 4],
            robots: [1, 0, 0, 0],
        });
        let mut max = 0;
        let mut max_guess = 0;
        let prune_len = if max_time == 24 { 200 } else { 8000 };
        let mut prune_time: isize = max_time as isize - 1;
        while let Some(cur) = todo.pop_front() {
            if cur.t == prune_time as u8 {
                prune_time -= 1;
                if todo.len() > prune_len * 2 {
                    todo.make_contiguous().sort_by(|a, b| b.score.cmp(&a.score));
                    todo.truncate(prune_len);
                }
            }
            if cur.inv[GEODE] > max {
                max = cur.inv[GEODE];
            }
            if cur.t == 0 {
                continue;
            }
            let ct = cur.t as usize;
            let min_poss_geodes = (cur.inv[GEODE] as usize) + ct * (cur.robots[GEODE] as usize);
            let max_poss_geodes = min_poss_geodes + ((ct - 1) * (ct - 1) + ct - 1) / 2;
            if max_poss_geodes < max_guess {
                continue;
            }
            if min_poss_geodes > max_guess {
                max_guess = min_poss_geodes;
            }
            let (no, nc, nob, ng) = (
                cur.inv[ORE] + cur.robots[ORE],
                cur.inv[CLAY] + cur.robots[CLAY],
                cur.inv[OBSIDIAN] + cur.robots[OBSIDIAN],
                cur.inv[GEODE] + cur.robots[GEODE],
            );
            let nscore = (((((ng as usize) * 100 + (cur.robots[GEODE] as usize)) * 100
                + (nob as usize))
                * 100
                + (cur.robots[OBSIDIAN]) as usize)
                * 100
                + (nc as usize))
                * 100
                + (no as usize);
            todo.push_back(Search {
                t: cur.t - 1,
                score: nscore,
                inv: [no, nc, nob, ng],
                robots: [
                    cur.robots[ORE],
                    cur.robots[CLAY],
                    cur.robots[OBSIDIAN],
                    cur.robots[GEODE],
                ],
            });
            if cur.inv[ORE] >= self.geo_ore && cur.inv[OBSIDIAN] >= self.geo_obs {
                todo.push_back(Search {
                    t: cur.t - 1,
                    score: nscore,
                    inv: [no - self.geo_ore, nc, nob - self.geo_obs, ng],
                    robots: [
                        cur.robots[ORE],
                        cur.robots[CLAY],
                        cur.robots[OBSIDIAN],
                        cur.robots[GEODE] + 1,
                    ],
                });
            }
            if cur.robots[OBSIDIAN] < self.geo_obs
                && cur.inv[ORE] >= self.obs_ore
                && cur.inv[CLAY] >= self.obs_clay
            {
                todo.push_back(Search {
                    t: cur.t - 1,
                    score: nscore,
                    inv: [no - self.obs_ore, nc - self.obs_clay, nob, ng],
                    robots: [
                        cur.robots[ORE],
                        cur.robots[CLAY],
                        cur.robots[OBSIDIAN] + 1,
                        cur.robots[GEODE],
                    ],
                });
            }
            if cur.robots[CLAY] < self.obs_clay && cur.inv[ORE] >= self.clay_ore {
                todo.push_back(Search {
                    t: cur.t - 1,
                    score: nscore,
                    inv: [no - self.clay_ore, nc, nob, ng],
                    robots: [
                        cur.robots[ORE],
                        cur.robots[CLAY] + 1,
                        cur.robots[OBSIDIAN],
                        cur.robots[GEODE],
                    ],
                });
            }
            if cur.robots[ORE] < self.max_ore && cur.inv[ORE] >= self.ore_ore {
                todo.push_back(Search {
                    t: cur.t - 1,
                    score: nscore,
                    inv: [no - self.ore_ore, nc, nob, ng],
                    robots: [
                        cur.robots[ORE] + 1,
                        cur.robots[CLAY],
                        cur.robots[OBSIDIAN],
                        cur.robots[GEODE],
                    ],
                });
            }
        }
        max as usize
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut bp: [Blueprint; 30] = [Blueprint::default(); 30];
    let mut k = 0;
    let mut i = 0;
    while i < inp.len() {
        let (mut j, _) = aoc::read::uint::<usize>(inp, i + 10);
        (j, bp[k].ore_ore) = aoc::read::uint::<u8>(inp, j + 23);
        (j, bp[k].clay_ore) = aoc::read::uint::<u8>(inp, j + 28);
        (j, bp[k].obs_ore) = aoc::read::uint::<u8>(inp, j + 32);
        (j, bp[k].obs_clay) = aoc::read::uint::<u8>(inp, j + 9);
        (j, bp[k].geo_ore) = aoc::read::uint::<u8>(inp, j + 30);
        (j, bp[k].geo_obs) = aoc::read::uint::<u8>(inp, j + 9);
        bp[k].max_ore = bp[k]
            .ore_ore
            .max(bp[k].clay_ore.max(bp[k].obs_ore.max(bp[k].geo_ore)));
        k += 1;
        i = j + 11;
    }
    let mut p1 = 0;
    for (i, e) in bp.iter().enumerate().take(k) {
        p1 += (i + 1) * e.solve(24);
    }
    let mut p2 = 1;
    p2 *= bp[0].solve(32);
    p2 *= bp[1].solve(32);
    if k > 2 {
        p2 *= bp[2].solve(32);
    }
    (p1, p2)
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
        let inp = std::fs::read("../2022/19/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (33, 56 * 62));
        let inp = std::fs::read("../2022/19/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1565, 10672));
    }
}

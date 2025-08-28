use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    struct Block {
        size: u8,
        id: Option<u32>,
    }
    struct File {
        size: u8,
        idx: u32,
        id: u32,
    }
    struct Free {
        size: u8,
        idx: u32,
    }
    let mut blocks = SmallVec::<[Block; 32768]>::new();
    let mut file = SmallVec::<[File; 16384]>::new();
    let mut free = SmallVec::<[Free; 16384]>::new();
    let mut i = 0;
    for (j, ch) in inp.iter().enumerate().take(inp.len() - 1) {
        let size = ch - b'0';
        if j % 2 == 0 {
            blocks.push(Block {
                size,
                id: Some((j / 2) as u32),
            });
            file.push(File {
                size,
                idx: i,
                id: (j / 2) as u32,
            });
        } else if size != 0 {
            blocks.push(Block { size, id: None });
            free.push(Free { size, idx: i });
        }
        i += size as u32;
    }
    let mut p1 = 0;
    let mut j = 0;
    let mut head = 0;
    let mut tail = blocks.len() - 1;
    while head <= tail {
        let mut v = blocks[head].id;
        if v.is_none() {
            if blocks[tail].id.is_none() {
                tail -= 1;
                continue;
            }
            v = blocks[tail].id;
            blocks[tail].size -= 1;
            if blocks[tail].size == 0 {
                tail -= 1;
            }
        }
        p1 += (j * v.unwrap()) as usize;
        blocks[head].size -= 1;
        if blocks[head].size == 0 {
            head += 1;
        }
        j += 1;
    }
    let mut p2 = 0;
    let mut first_free: [usize; 10] = [0; 10];
    let mut i = file.len() - 1;
    loop {
        let size = file[i].size as usize;
        if size == 0 {
            i -= 1;
            continue;
        }
        let mut j = first_free[size];
        while j < free.len() && file[i].idx > free[j].idx {
            if file[i].size > free[j].size {
                j += 1;
                continue;
            }
            first_free[size] = j;
            file[i].idx = free[j].idx;
            free[j].idx += file[i].size as u32;
            free[j].size -= file[i].size;
            break;
        }
        for k in 0..size {
            p2 += (file[i].idx as usize + k) * (file[i].id as usize);
        }
        if i == 0 {
            break;
        }
        i -= 1;
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
        aoc::test::auto("../2024/09/", parts);
    }
}

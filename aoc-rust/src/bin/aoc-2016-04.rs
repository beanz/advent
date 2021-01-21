use itertools::Itertools;

fn room_record(room: &str) -> (&str, usize, &str) {
    let mut sp = room.rsplitn(2, '[');
    let mut check = sp.next().unwrap();
    check = &check[0..check.len() - 1];
    let mut sp2 = sp.next().unwrap().rsplitn(2, '-');
    let sector_id = sp2.next().unwrap().parse::<usize>().unwrap();
    let name = sp2.next().unwrap();
    (name, sector_id, check)
}

#[test]
fn room_record_works() {
    let room = "rsvxltspi-sfnigx-wxsveki-984[sixve]".to_string();
    let (name, sector_id, check) = room_record(&room);
    assert_eq!(name, "rsvxltspi-sfnigx-wxsveki", "room record name");
    assert_eq!(sector_id, 984, "room record sector id");
    assert_eq!(check, "sixve", "room record checksum");
}

fn valid(room: &str) -> usize {
    let (name, sector_id, check) = room_record(room);
    let mut occurs: Vec<(usize, char)> = name
        .chars()
        .unique()
        .filter(|ch| *ch != '-')
        .map(|ch| (name.matches(ch).count(), ch))
        .collect();
    occurs.sort_by(|a, b| {
        if a.0 == b.0 {
            a.1.cmp(&b.1)
        } else {
            b.0.cmp(&a.0)
        }
    });
    let act: String = occurs.iter().take(5).map(|(_, ch)| *ch).collect();
    if act != check {
        return 0;
    }
    sector_id
}

#[test]
fn valid_works() {
    let valid_room = "rsvxltspi-sfnigx-wxsveki-984[sixve]";
    assert_eq!(valid(&valid_room), 984, "valid room");
    let invalid_room = "totally-real-room-200[decoy]";
    assert_eq!(valid(&invalid_room), 0, "invalid room");
}

fn part1(inp: &[String]) -> usize {
    inp.iter().map(|x| valid(&x)).sum()
}

#[test]
fn part1_works() {
    let rooms = vec![
        "aaaaa-bbb-z-y-x-123[abxyz]".to_string(),
        "a-b-c-d-e-f-g-h-987[abcde]".to_string(),
        "not-a-real-room-404[oarel]".to_string(),
        "totally-real-room-200[decoy]".to_string(),
    ];
    assert_eq!(part1(&rooms), 1514, "part 1 examples");
}

fn rotate(r: String, id: usize) -> String {
    r.chars()
        .map(|ch| {
            if ch == '-' {
                ' '
            } else {
                (b'a' + (((ch as u8 - b'a') as usize + id) % 26) as u8) as char
            }
        })
        .collect()
}

#[test]
fn rotate_works() {
    let cipher = "rsvxltspi-sfnigx-wxsveki".to_string();
    assert_eq!(
        rotate(cipher, 984),
        "northpole object storage",
        "rotated room"
    );
}

fn decrypt(room: &str) -> (String, usize) {
    let (name, sector_id, _) = room_record(room);
    (rotate(name.to_string(), sector_id), sector_id)
}

#[test]
fn decrypt_works() {
    let room = "rsvxltspi-sfnigx-wxsveki-984[sixve]".to_string();
    assert_eq!(
        decrypt(&room),
        ("northpole object storage".to_string(), 984),
        "decrypted room"
    );
}

fn part2(inp: &[String]) -> usize {
    inp.iter()
        .map(|x| decrypt(&x))
        .find(|(name, _)| name.contains("north"))
        .expect("Failed to find decrypted room")
        .1
}

#[test]
fn part2_works() {
    let room = "rsvxltspi-sfnigx-wxsveki-984[sixve]".to_string();
    assert_eq!(part2(&vec![room]), 984, "part 2");
}

fn main() {
    let lines = aoc::input_lines();
    println!("Part 1: {}", part1(&lines));
    println!("Part 2: {}", part2(&lines));
}

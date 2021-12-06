auto input_file = cast(immutable ubyte[])import("input.txt");
auto test1_file = cast(immutable ubyte[])import("test1.txt");

ulong fish(const ubyte[] inp, ulong days) {
  ulong[9] f = [0,0,0,0,0,0,0,0,0];
  foreach (const ubyte ch; inp) {
    if (ch < '0') {
      continue;
    }
    f[ch-48] += 1;
  }
  ulong z = 0;
  foreach (d; 0..days) {
    f[(z + 7) % 9] += f[z];
    z = (z + 1) % 9;
  }
  ulong c = 0;
  foreach (fc; f) {
    c += fc;
  }
  return c;
}

void main() {
  import std.stdio : writefln;
  writefln("Part 1: %d", fish(input_file, 80));
  writefln("Part 2: %d", fish(input_file, 256));
}

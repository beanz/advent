#include <stdio.h>
#include <stdlib.h>

//#define D(X) printf("%d: a=%d b=%d c=%d d=%d e=%d f=%d g=%d h=%d\n", X, a, b, c, d, e, f, g, h)
#define D(X) 

int main(int argc, char**argv)
{
  int a = 0, b = 0, c = 0, h = 0;
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <initial-value-of-a>\n", argv[0]);
    exit(1);
  }
  a = strtol(argv[1], NULL, 10);

  if (a == 0) {
  L0:  /*  0 set b 99 */ D(0);
    b = c = 99;
  L1:  /*  1 set c b */ D(1);
  L2:  /*  2 jnz a 2 */ D(2);
    printf("mul called %d times\n", (99-2)*(99-2));
  } else {
  L3:  /*  3 jnz 1 5 */ D(3);
  L4:  /*  4 mul b 100 */ D(4);
  L5:  /*  5 sub b -100000 */ D(5);
  L6:  /*  6 set c b */ D(6);
  L7:  /*  7 sub c -17000 */ D(7);
    b = c = 109900;
    c += 17000;
  }
  do {
  L8:  /*  8 set f 1 */ D(8);
  L9:  /*  9 set d 2 */ D(9);
    int d = 2;
    do {
      if ((b%d) == 0) { h++; break; }
    L10: /* 10 set e 2 */ D(10);
    L11: /* 11 set g d */ D(11);
    L12: /* 12 mul g e */ D(12);
    L13: /* 13 sub g b */ D(13);
    L14: /* 14 jnz g 2 */ D(14);
    L15: /* 15 set f 0 */ D(15);
    L16: /* 16 sub e -1 */ D(16);
    L17: /* 17 set g e */ D(17);
    L18: /* 18 sub g b */ D(18);
    L19: /* 19 jnz g -8 */ D(19);
    L20: /* 20 sub d -1 */ D(20);
      d += 1;
    L21: /* 21 set g d */ D(21);
    L22: /* 22 sub g b */ D(22);
    L23: /* 23 jnz g -13 */ D(23);
    } while (d < b);
  L24: /* 24 jnz f 2 */ D(24);
  L25: /* 25 sub h -1 */ D(25);
  L26: /* 26 set g b */ D(26);
  L27: /* 27 sub g c */ D(27);
  L28: /* 28 jnz g 2 */ D(28);
  L29: /* 29 jnz 1 3 */ D(29);
  L30: /* 30 sub b -17 */ D(30);
    b += 17;
    //fprintf(stderr, "b=%d/%d\r", b, c);
  L31: /* 31 jnz 1 -23 */ D(31);
  } while (b <= c);
 L32:
  printf("h=%d\n", h);
  exit(0);
}

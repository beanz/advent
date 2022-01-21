#ifndef INPUT_HPP
#define INPUT_HPP

#include <chrono>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

bool is_test() {
  return (std::getenv("AoC_TEST") != NULL);
}

std::pair<unsigned char *, unsigned int> getfile(const char *name) {
  struct stat st;
  stat(name, &st);
  size_t file_size = st.st_size;

  auto f = open(name, O_RDONLY);
  unsigned char* file_buf = (unsigned char*)mmap(0, file_size, PROT_READ, MAP_FILE|MAP_PRIVATE, f, 0);
  // leaked! munmap(file_buf, file_size);
  return std::make_pair(file_buf, (unsigned int)file_size);
}

std::pair<unsigned char *, unsigned int> input(int argc, char **argv) {
  if (argc < 2) {
    return std::make_pair(input_txt, input_txt_len);
  }
  return getfile(argv[1]);
}

void benchme(int argc, char **argv, unsigned int input_txt_len, unsigned char* input_txt,
             void (*fn)(unsigned int inp_len, unsigned char* inp, bool bench)) {
  unsigned char *inp;
  unsigned int inp_len;
  auto ipair = input(argc, argv);
  inp = ipair.first;
  inp_len = ipair.second;

  auto is_bench = (std::getenv("AoC_BENCH") != NULL);
  auto start = std::chrono::high_resolution_clock::now();

  unsigned int iterations = 0;
  while (true) {
    (*fn)(inp_len, inp, is_bench);
    iterations++;
    if (!is_bench) {
      break;
    }
    auto finish = std::chrono::high_resolution_clock::now();
    auto elapsed =
        std::chrono::duration_cast<std::chrono::nanoseconds>(finish-start).count();
    if (elapsed > 2000000000) {
      cout << "bench " << iterations << " iterations in " << elapsed << "ns: "
	   << double(elapsed)/double(iterations) << "ns\n";
      break;
    }
  }
}

vector<string> lines(unsigned int inp_len, unsigned char *inp) {
  vector<string> ls;
  unsigned int j = 0;
  for (unsigned int i = 0; i < inp_len; i++) {
    if (inp[i] == '\n') {
      inp[i] = 0;
      ls.push_back(std::string((char*)&(inp[j])));
      j = i+1;
    }
  }
  return ls;
}

vector<unsigned int> uints(unsigned int inp_len, unsigned char *inp) {
  vector<unsigned int> ints;
  unsigned int n = 0;
  bool num = false;
  for (unsigned int i = 0; i < inp_len; i++) {
     if ('0' <= inp[i] && inp[i] <= '9') {
	num = true;
	n = 10*n + (inp[i] - '0');
     } else {
	if (num) {
          ints.push_back(n);
        }
        n = 0;
        num = false;
     }
  }
  return ints;
}

vector<unsigned long> ulongs(unsigned int inp_len, unsigned char *inp) {
  vector<unsigned long> res;
  unsigned long n = 0;
  bool num = false;
  for (unsigned int i = 0; i < inp_len; i++) {
     if ('0' <= inp[i] && inp[i] <= '9') {
	num = true;
	n = 10*n + (inp[i] - '0');
     } else {
	if (num) {
          res.push_back(n);
	  n = 0;
        }
	num = false;
     }
  }
  return res;
}

vector<int> ints(unsigned int inp_len, unsigned char *inp) {
  vector<int> ints;
  int n = 0;
  int m = 1;
  bool num = false;
  for (unsigned int i = 0; i < inp_len; i++) {
     if ('0' <= inp[i] && inp[i] <= '9') {
	num = true;
	n = 10*n + (inp[i] - '0');
     } else if (inp[i] == '-') {
       m = -1;
     } else {
	if (num) {
          ints.push_back(n*m);
        }
        n = 0;
        m = 1;
	num = false;
     }
  }
  return ints;
}

vector<long> longs(unsigned int inp_len, unsigned char *inp) {
  vector<long> ints;
  long n = 0;
  int m = 1;
  bool num = false;
  for (unsigned int i = 0; i < inp_len; i++) {
     if ('0' <= inp[i] && inp[i] <= '9') {
	num = true;
	n = 10*n + (inp[i] - '0');
     } else if (inp[i] == '-') {
       m = -1;
     } else {
	if (num) {
          ints.push_back(n*m);
        }
        n = 0;
        m = 1;
	num = false;
     }
  }
  return ints;
}


unsigned int scanUint(unsigned char *s, size_t* i, size_t len) {
  unsigned int n = 0;
  for (;*i < len; (*i)++) {
    if ('0' <= s[*i] && s[*i] <= '9') {
      n = 10*n + (unsigned int)(s[*i]-'0');
    } else {
      break;
    }
  }
  return n;
}

#include <fstream>
#include <vector>

std::vector<std::string> readlines(std::string file) {
  std::ifstream inf(file);
  std::vector<std::string> lines;
  std::string l;
  while (getline(inf, l)) {
    lines.push_back(l);
  }
  return lines;
}

std::vector<long> readints(std::string file) {
  std::ifstream inf(file);
  std::vector<long> prog;
  long x;
  while ((inf >> x) && inf.ignore()) {
    prog.push_back(x);
  }
  return prog;
}

#endif

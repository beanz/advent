#ifndef INPUT_HPP
#define INPUT_HPP

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

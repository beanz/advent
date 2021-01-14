#include <stdio.h>
#include <iostream>
#include <ctime>
#include <vector>
#include <deque>
#include <map>
#include <algorithm>
#include <limits>
#include <assert.h>
#include <sstream>
#include "input.hpp"
#include "intcode.hpp"
#include "assert.hpp"

using namespace std;

auto part1(vector<long> prog) {
  IntCode* ic = new IntCode(&prog);
  vector<string> bad;
  bad.push_back("infinite loop");
  bad.push_back("giant electromagnet");
  bad.push_back("photons");
  bad.push_back("escape pod");
  bad.push_back("molten lava");
  string s = "";
  size_t lastIndex = 0;
  vector<string> inv;
  string lastDir = "";
  while (true) {
    auto rc = ic->run();
    if (rc == 0 || rc == 2) {
      s += ic->outputString();
      size_t found = s.find(" on the keypad", lastIndex);
      if (found != string::npos) {
        return s.substr(found-9, 8);
      }
      found = s.find("eject", lastIndex);
      if (found != string::npos) {
        //cout << "found exit\n";
        if (inv.size() == 8) {
          for (size_t c = 1; c < 255; c++) {
            for (size_t i = 0; i < 8; i++) {
              ic->addInput("drop " + inv[i] + "\n");
            }
            for (size_t i = 0; i < 8; i++) {
              if (((1 << i) & c) != 0) {
                ic->addInput("take " + inv[i] + "\n");
              }
            }
            ic->addInput(lastDir + "\n");
          }
        }
      }
      size_t prompt = s.find("Command?", lastIndex);
      if (prompt == string::npos) {
        continue;
      }
      //cout << s.substr(lastIndex, string::npos) << "\n";
      found = s.find("Items here:", lastIndex);
      if (found != string::npos) {
        //cout << "found items\n";
        found += 12;
        while (s[found] == '-') {
          size_t ei = s.find('\n', found);
          if (ei != string::npos) {
            string item = s.substr(found+2, ei-(found+2));
            bool good = true;
            for (auto b : bad) {
              if (b == item) {
                good = false;
              }
            }
            if (good) {
              //cout << "found '" << item << "'\n";
              ic->addInput("take " + item + "\n");
              inv.push_back(item);
            }
            found = ei+1;
          }
        }
      }
      found = s.find("Doors here lead", lastIndex);
      if (found != string::npos) {
        //cout << "found doors\n";
        vector<string> dirs;
        if (s.find("north", found) != string::npos) {
          dirs.push_back("north");
        }
        if (s.find("south", found) != string::npos) {
          dirs.push_back("south");
        }
        if (s.find("east", found) != string::npos) {
          dirs.push_back("east");
        }
        if (s.find("west", found) != string::npos) {
          dirs.push_back("west");
        }
        //cout << "found doors " << dirs.size() << "\n";
        string dir = dirs[rand() % dirs.size()];
        //cout << "sending " << dir << "\n";
        lastDir = dir;
        ic->addInput(dir + "\n");
      }
      lastIndex = prompt+9;
    }
  }
  return string("");
}

int main(int argc, char *argv[]) {
  string file = "input.txt";
  if (argc > 1) {
    file = argv[1];
  }
  vector<long> prog = readints(file);
  if (getenv("AoC_TEST")) {
    //AIEQ((new Donut(readlines("test1a.txt")))->part1(), 23);
  }
  std::srand(std::time(0));
  string p1 = part1(prog);
  cout << "Part 1: " << p1 << "\n";
}

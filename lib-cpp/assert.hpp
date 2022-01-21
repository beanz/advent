#ifndef ASSERT_HPP
#define ASSERT_HPP

#define AIEQ(act,exp) { int a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }
#define ALEQ(act,exp) { long a = act; if (a != exp) { throw std::runtime_error("assert: " + std::to_string(a) + " should equal " + std::to_string(exp)); } }
#define ASEQ(act,exp) { if (act != exp) { throw std::runtime_error("assert: " + act + " should equal " + exp); } }

#endif

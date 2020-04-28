#pragma once
#ifndef TESTOROSSO_H__
#define TESTOROSSO_H__

#include <string_view>
#include <vector>

#define TEST_FUNC(name)                                                        \
    void                 name();                                               \
    testorosso::TestFunc test##name(#name, __FILE__);                          \
    void                 name()

namespace testorosso {

class VirtualFunc;
inline std::vector<VirtualFunc *> funcs;

class VirtualFunc {
public:
    VirtualFunc() noexcept { funcs.push_back(this); }
    virtual void operator()() = 0;
};

template<class F>
class TestFunc : public VirtualFunc {
public:
    TestFunc(F func) noexcept : func(func) {}
    void operator()() override { func(); }

private:
    std::string_view name, file;
    F                func;
};

template <class F>
TestFunc<F> makeTest(F&& f) {
    return TestFunc<F>(std::forward<F>(f));
}

}

#endif // TESTOROSSO_H__

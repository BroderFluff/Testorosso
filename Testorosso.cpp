#include <iostream>
#include "Testorosso.h"

int main(int argc, char *argv[]) {
    try {
        for (auto it: testorosso::funcs) {
            (*it).operator()();
        }
    } catch (std::exception &e) {
        std::cerr << e.what() << std::endl;
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

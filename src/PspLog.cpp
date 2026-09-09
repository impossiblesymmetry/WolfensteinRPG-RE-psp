#include "PspLog.h"

#include <cstdarg>
#include <cstdio>

#ifdef WOLFENSTEIN_PSP
namespace {
FILE* logFile = nullptr;
}
#endif

namespace PspLog {
void open() {
#ifdef WOLFENSTEIN_PSP
    logFile = std::fopen("./WolfensteinRPG.log", "w");
#endif
    write("WolfensteinRPG PSP log started\n");
}

void close() {
#ifdef WOLFENSTEIN_PSP
    if (logFile != nullptr) {
        std::fflush(logFile);
        std::fclose(logFile);
        logFile = nullptr;
    }
#endif
}

void write(const char* format, ...) {
    va_list args;
    va_start(args, format);
#ifdef WOLFENSTEIN_PSP
    if (logFile != nullptr) {
        std::vfprintf(logFile, format, args);
        std::fflush(logFile);
    }
#else
    std::vfprintf(stderr, format, args);
    std::fflush(stderr);
#endif
    va_end(args);
}

void stage(const char* name) {
    write("[stage] %s\n", name);
}
}

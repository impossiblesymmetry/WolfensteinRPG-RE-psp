#include "PspLog.h"

#include <cstdarg>
#include <cstdio>

#ifndef WOLFENSTEIN_BUILD_ID
#define WOLFENSTEIN_BUILD_ID "desktop"
#endif

#ifdef WOLFENSTEIN_PSP
#include <pspsysmem.h>

namespace {
FILE* logFile = nullptr;
}
#endif

namespace PspLog {
void open() {
#ifdef WOLFENSTEIN_PSP
#if WOLFENSTEIN_PSP_LOG
    logFile = std::fopen("./WolfensteinRPG.log", "w");
#endif
#if WOLFENSTEIN_PSP_LOG
    write("WolfensteinRPG PSP build=%s log started\n", WOLFENSTEIN_BUILD_ID);
#endif
#else
    write("WolfensteinRPG PSP build=%s log started\n", WOLFENSTEIN_BUILD_ID);
#endif
}

void close() {
#ifdef WOLFENSTEIN_PSP
#if WOLFENSTEIN_PSP_LOG
    if (logFile != nullptr) {
        std::fflush(logFile);
        std::fclose(logFile);
        logFile = nullptr;
    }
#endif
#endif
}

void write(const char* format, ...) {
    va_list args;
    va_start(args, format);
#ifdef WOLFENSTEIN_PSP
#if WOLFENSTEIN_PSP_LOG
    if (logFile != nullptr) {
        std::vfprintf(logFile, format, args);
        std::fflush(logFile);
    }
#endif
#else
    std::vfprintf(stderr, format, args);
    std::fflush(stderr);
#endif
    va_end(args);
}

void stage(const char* name) {
    write("[stage] %s\n", name);
}

void memory(const char* where) {
#ifdef WOLFENSTEIN_PSP
    write("memory %s: totalFree=%u maxFree=%u\n",
        where,
        (unsigned)sceKernelTotalFreeMemSize(),
        (unsigned)sceKernelMaxFreeMemSize());
#else
    (void)where;
#endif
}
}

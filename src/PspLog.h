#ifndef WOLFENSTEIN_PSP_LOG_H
#define WOLFENSTEIN_PSP_LOG_H

namespace PspLog {
void open();
void close();
void write(const char* format, ...);
void stage(const char* name);
void memory(const char* where);
}

#endif

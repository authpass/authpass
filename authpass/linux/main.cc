#include <sys/prctl.h>
#include <sys/resource.h>

#include "my_application.h"

int main(int argc, char** argv) {
  // A crash while a database is unlocked would otherwise write its decrypted
  // contents to disk. A core dump holds the whole address space, and the
  // decrypted database lives in the Dart heap, so there is no narrower region
  // to exclude instead.
  //
  // This is the part that holds. The kernel tests the dumpable flag before it
  // decides where a dump goes, so it covers a plain core file, a handler piped
  // from /proc/sys/kernel/core_pattern, and a socket destination alike. It
  // also stops another process of this user attaching with PTRACE_ATTACH,
  // which would reach the same secrets by another route. The cost is that a
  // release build can no longer be attached to with a debugger.
  if (prctl(PR_SET_DUMPABLE, 0, 0, 0, 0) != 0) {
    g_warning("Unable to mark the process as not dumpable.");
  }

  // Only reached as a fallback, if the call above failed. One byte rather than
  // zero on purpose: zero stops a dump written straight to a file, but is
  // ignored outright when the dump is piped to a handler, and the dump then
  // proceeds with no limit at all. A limit of exactly one byte is refused on
  // both paths.
  struct rlimit one_byte = {1, 1};
  if (setrlimit(RLIMIT_CORE, &one_byte) != 0) {
    g_warning("Unable to limit the core file size.");
  }

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}

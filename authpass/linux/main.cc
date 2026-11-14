#include <sys/resource.h>

#include "my_application.h"

int main(int argc, char** argv) {
  // Never write a core file: a crash while a database is unlocked would
  // otherwise leave its decrypted contents on disk.
  struct rlimit no_core = {0, 0};
  if (setrlimit(RLIMIT_CORE, &no_core) != 0) {
    g_warning("Unable to disable core dumps.");
  }

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
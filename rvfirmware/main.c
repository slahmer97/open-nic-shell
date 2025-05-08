#include "snic.h"
#include <stdint.h>
int main(void) {

  for (uint32_t i = 0; i < 16; ++i) {
    PMEM_PTR[i] = i;
  }
  for (uint32_t i = 0; i < 24; ++i) {
    TEST_PTR[i] = PMEM_PTR[i] + 2;
  }
  while (1) {
    __asm__ volatile("wfi");
  }
  return 0;
}

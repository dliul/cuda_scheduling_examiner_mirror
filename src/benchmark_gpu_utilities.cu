// This file contains the implementation of the library defined by
// benchmark_gpu_utilities.h.
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "benchmark_gpu_utilities.h"

int InternalCUDAErrorCheck(cudaError_t result, const char *fn,
  const char *file, int line) {
  if (result == cudaSuccess) return 1;
  printf("CUDA error %d in %s, line %d (%s)\n", (int) result, file, line, fn);
  return 0;
}

cudaError_t CreateCUDAStreamWithPriority(int stream_priority,
    cudaStream_t *stream) {
  cudaError_t result;
  int lowest_priority, highest_priority;
  result = cudaDeviceGetStreamPriorityRange(&lowest_priority,
    &highest_priority);
  if (result != cudaSuccess) return result;
  // Low priorities are higher numbers than high priorities.
  if ((stream_priority > lowest_priority) || (stream_priority <
    highest_priority)) {
    return cudaStreamCreate(stream);
  }
  return cudaStreamCreateWithPriority(stream, cudaStreamNonBlocking,
    stream_priority);
}

double CurrentSeconds(void) {
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC_RAW, &ts) != 0) {
    printf("Error getting time.\n");
    exit(1);
  }
  return ((double) ts.tv_sec) + (((double) ts.tv_nsec) / 1e9);
}

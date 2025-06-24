# Define preferred paths for MPI and RCCL installations (ensure /lib/libmpi.so and /lib/librccl.so exist in both install paths)
MPI_INSTALL_DIR=/path/to/mpi
RCCL_INSTALL_DIR=/path/to/rccl

# If HIP is not installed in /opt/rocm, add `HIP_HOME=/path/to/hip` to the cmake parameters.  

build_rccl_tests() {
    if [ ! -d rccl-tests ]; then
        git clone https://github.com/ROCm/rccl-tests
        cd rccl-tests
        make MPI=1 MPI_HOME=${MPI_INSTALL_DIR} NCCL_HOME=${RCCL_INSTALL_DIR} -j
    fi
}

# Build RCCL tests

build_rccl_tests
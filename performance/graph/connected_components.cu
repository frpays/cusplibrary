#include <cusp/csr_matrix.h>
#include <cusp/print.h>

#include <cusp/gallery/poisson.h>
#include <cusp/graph/connected_components.h>
#include <cusp/io/matrix_market.h>

#include "../timer.h"

template<typename MemorySpace, typename MatrixType>
void SCC(const MatrixType& G)
{
    typedef typename MatrixType::index_type IndexType;
    typedef cusp::csr_matrix<IndexType,IndexType,MemorySpace> GraphType;

    GraphType G_scc(G);
    cusp::array1d<IndexType,MemorySpace> components(G.num_rows);
    
    timer t;
    size_t num_components = cusp::graph::connected_components(G_scc, components);
    std::cout << "SCC time : " << t.milliseconds_elapsed() << " (ms)." << std::endl;
    std::cout << "Number of components : " << num_components << std::endl;
}

int main(int argc, char*argv[])
{
    srand(time(NULL));

    typedef int   IndexType;
    typedef float ValueType;
    typedef cusp::host_memory MemorySpace;

    cusp::csr_matrix<IndexType, ValueType, MemorySpace> A;
    size_t size = 1024;

    if (argc == 1)
    {
        // no input file was specified, generate an example
        std::cout << "Generated matrix (poisson5pt) ";
        cusp::gallery::poisson5pt(A, size, size);
    }
    else if (argc == 2)
    {
        // an input file was specified, read it from disk
        cusp::io::read_matrix_market_file(A, argv[1]);
        std::cout << "Read matrix (" << argv[1] << ") ";
    }

    std::cout << "with shape ("  << A.num_rows << "," << A.num_cols << ") and "
              << A.num_entries << " entries" << "\n\n";

    std::cout << " Device ";
    SCC<cusp::device_memory>(A);

    std::cout << " Host ";
    SCC<cusp::host_memory>(A);

    return EXIT_SUCCESS;
}


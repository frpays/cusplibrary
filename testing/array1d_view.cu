#include <unittest/unittest.h>

#include <cusp/array1d.h>

#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/zip_iterator.h>

template <typename MemorySpace>
void TestArray1dView(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef typename Array::const_iterator           ConstIterator;

  // view to container
  {
    typedef cusp::array1d_view<Iterator> View;

    Array A(4);
    A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40;

    View V(A.begin(), A.end());

    ASSERT_EQUAL(V.size(),     4);
    ASSERT_EQUAL(V.capacity(), 4);
    ASSERT_EQUAL(V[0], 10);
    ASSERT_EQUAL(V[1], 20);
    ASSERT_EQUAL(V[2], 30);
    ASSERT_EQUAL(V[3], 40);
    ASSERT_EQUAL_QUIET(V.begin(), A.begin());
    ASSERT_EQUAL_QUIET(V.end(),   A.end());

    V[1] = 17;

    ASSERT_EQUAL(V[1], 17);
    ASSERT_EQUAL(A[1], 17);
    
    View W(A.begin(), A.end());
    ASSERT_EQUAL(W.size(),     4);
    ASSERT_EQUAL(W.capacity(), 4);
    ASSERT_EQUAL_QUIET(W.begin(), A.begin());
    ASSERT_EQUAL_QUIET(W.end(),   A.end());
  }
  
  // view to const container
  {
    typedef cusp::array1d_view<ConstIterator> View;

    const Array A(4, 10);

    View V(A.begin(), A.end());

    ASSERT_EQUAL(V.size(),     4);
    ASSERT_EQUAL(V.capacity(), 4);
    ASSERT_EQUAL(V[0], 10);
    ASSERT_EQUAL(V[1], 10);
    ASSERT_EQUAL(V[2], 10);
    ASSERT_EQUAL(V[3], 10);
    ASSERT_EQUAL_QUIET(V.begin(), A.begin());
    ASSERT_EQUAL_QUIET(V.end(),   A.end());
    
    View W(A.begin(), A.end());
    ASSERT_EQUAL(W.size(),     4);
    ASSERT_EQUAL(W.capacity(), 4);
    ASSERT_EQUAL_QUIET(W.begin(), A.begin());
    ASSERT_EQUAL_QUIET(W.end(),   A.end());
  }

  // const view to container
  {
    typedef const cusp::array1d_view<Iterator> View;

    Array A(4);
    A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40;

    View V(A);

    ASSERT_EQUAL(V.size(),     4);
    ASSERT_EQUAL(V.capacity(), 4);
    ASSERT_EQUAL(V[0], 10);
    ASSERT_EQUAL(V[1], 20);
    ASSERT_EQUAL(V[2], 30);
    ASSERT_EQUAL(V[3], 40);
    ASSERT_EQUAL_QUIET(V.begin(), A.begin());
    ASSERT_EQUAL_QUIET(V.end(),   A.end());

    V[1] = 17;

    ASSERT_EQUAL(V[1], 17);
    ASSERT_EQUAL(A[1], 17);
    
    View W(A.begin(), A.end());
    ASSERT_EQUAL(W.size(),     4);
    ASSERT_EQUAL(W.capacity(), 4);
    ASSERT_EQUAL_QUIET(W.begin(), A.begin());
    ASSERT_EQUAL_QUIET(W.end(),   A.end());
  }

  // const view to const container
  {
    typedef const cusp::array1d_view<ConstIterator> View;

    const Array A(4, 10);

    View V(A);

    ASSERT_EQUAL(V.size(),     4);
    ASSERT_EQUAL(V.capacity(), 4);
    ASSERT_EQUAL(V[0], 10);
    ASSERT_EQUAL(V[1], 10);
    ASSERT_EQUAL(V[2], 10);
    ASSERT_EQUAL(V[3], 10);
    ASSERT_EQUAL_QUIET(V.begin(), A.begin());
    ASSERT_EQUAL_QUIET(V.end(),   A.end());
    
    View W(A.begin(), A.end());
    ASSERT_EQUAL(W.size(),     4);
    ASSERT_EQUAL(W.capacity(), 4);
    ASSERT_EQUAL_QUIET(W.begin(), A.begin());
    ASSERT_EQUAL_QUIET(W.end(),   A.end());
  }

}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dView);


template <typename MemorySpace>
void TestMakeArray1dView(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(4);
  A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40;

  View V = cusp::make_array1d_view(A);

  ASSERT_EQUAL(V.size(),     4);
  ASSERT_EQUAL(V.capacity(), 4);
  ASSERT_EQUAL(V[0], 10);
  ASSERT_EQUAL(V[1], 20);
  ASSERT_EQUAL(V[2], 30);
  ASSERT_EQUAL(V[3], 40);
  ASSERT_EQUAL_QUIET(V.begin(), A.begin());
  ASSERT_EQUAL_QUIET(V.end(),   A.end());

  V[1] = 17;

  ASSERT_EQUAL(V[1], 17);
  ASSERT_EQUAL(A[1], 17);
}
DECLARE_HOST_DEVICE_UNITTEST(TestMakeArray1dView);


template <typename MemorySpace>
void TestArray1dViewAssignment(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(4);
  Array B(8);

  View V(A.begin(), A.end());

  ASSERT_EQUAL(V.size(),     4);
  ASSERT_EQUAL(V.capacity(), 4);
  ASSERT_EQUAL_QUIET(V.begin(), A.begin());
  ASSERT_EQUAL_QUIET(V.end(),   A.end());

  V = A;
  
  ASSERT_EQUAL(V.size(),     4);
  ASSERT_EQUAL(V.capacity(), 4);
  ASSERT_EQUAL_QUIET(V.begin(), A.begin());
  ASSERT_EQUAL_QUIET(V.end(),   A.end());
  
  V = B;
  
  ASSERT_EQUAL(V.size(),     8);
  ASSERT_EQUAL(V.capacity(), 8);
  ASSERT_EQUAL_QUIET(V.begin(), B.begin());
  ASSERT_EQUAL_QUIET(V.end(),   B.end());

  const View W = V;
  
  ASSERT_EQUAL(W.size(),     8);
  ASSERT_EQUAL(W.capacity(), 8);
  ASSERT_EQUAL_QUIET(W.begin(), B.begin());
  ASSERT_EQUAL_QUIET(W.end(),   B.end());
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewAssignment);


template <typename MemorySpace>
void TestArray1dViewResize(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(4);
  A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40;

  View V(A.begin(), A.end());

  V.resize(3);

  ASSERT_EQUAL(V.size(),     3);
  ASSERT_EQUAL(V.capacity(), 4);
  ASSERT_EQUAL_QUIET(V.begin(), A.begin());
  ASSERT_EQUAL_QUIET(V.end(),   A.begin() + 3);

  V.resize(2);
  
  ASSERT_EQUAL(V.size(),     2);
  ASSERT_EQUAL(V.capacity(), 4);
  ASSERT_EQUAL_QUIET(V.begin(), A.begin());
  ASSERT_EQUAL_QUIET(V.end(),   A.begin() + 2);
  
  ASSERT_THROWS(V.resize(5), cusp::not_implemented_exception);
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewResize);


template <typename MemorySpace>
void TestArray1dViewSize(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(4);

  View V(A.begin(), A.end());

  ASSERT_EQUAL(V.size(), 4);

  V.resize(2);

  ASSERT_EQUAL(V.size(), 2);

  View W = V;
  
  ASSERT_EQUAL(V.size(), 2);

  V = A;
  
  ASSERT_EQUAL(V.size(), 4);
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewSize);


template <typename MemorySpace>
void TestArray1dViewCapacity(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(4);

  View V(A.begin(), A.end());

  ASSERT_EQUAL(V.size(),     4);
  ASSERT_EQUAL(V.capacity(), 4);

  A.resize(2);

  V = A;
  
  ASSERT_EQUAL(V.size(),     2);
  ASSERT_EQUAL(V.capacity(), 4);
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewCapacity);


template <typename MemorySpace>
void TestArray1dViewCountingIterator(void)
{
  typedef thrust::counting_iterator<int> Iterator;

  cusp::array1d_view<Iterator> V(Iterator(5), Iterator(9));

  ASSERT_EQUAL(V.size(), 4);
  ASSERT_EQUAL(V[0], 5);
  ASSERT_EQUAL(V[3], 8);
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewCountingIterator);


template <typename MemorySpace>
void TestArray1dViewZipIterator(void)
{
  cusp::array1d<int, MemorySpace> A(4);
  cusp::array1d<int, MemorySpace> B(4);
  A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40;
  B[0] = 50; B[1] = 60; B[2] = 70; B[3] = 80;

  typedef typename cusp::array1d<int, MemorySpace>::iterator Iterator;
  typedef typename thrust::tuple<Iterator,Iterator>          IteratorTuple;
  typedef typename thrust::zip_iterator<IteratorTuple>       ZipIterator;
  
  ZipIterator begin = thrust::make_zip_iterator(thrust::make_tuple(A.begin(), B.begin()));

  cusp::array1d_view<ZipIterator> V(begin, begin + 4);

  ASSERT_EQUAL(V.size(), 4);
  ASSERT_EQUAL_QUIET(V[0], thrust::make_tuple(10,50));
  ASSERT_EQUAL_QUIET(V[3], thrust::make_tuple(40,80));
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewZipIterator);


template <typename MemorySpace>
void TestArray1dViewEquality(void)
{
  typedef typename cusp::array1d<int, MemorySpace> Array;
  typedef typename Array::iterator                 Iterator;
  typedef cusp::array1d_view<Iterator>             View;

  Array A(2);
  A[0] = 10;
  A[1] = 20;
  
  Array B(3);
  B[0] = 10;
  B[1] = 20;
  B[2] = 30;

  View V(A);
  View W(B);

  ASSERT_EQUAL_QUIET(A == V, true);
  ASSERT_EQUAL_QUIET(V == A, true);
  ASSERT_EQUAL_QUIET(V == V, true);
  ASSERT_EQUAL_QUIET(A != V, false);
  ASSERT_EQUAL_QUIET(V != A, false);
  ASSERT_EQUAL_QUIET(V != V, false);

  ASSERT_EQUAL_QUIET(V == B, false);
  ASSERT_EQUAL_QUIET(B == V, false);
  ASSERT_EQUAL_QUIET(V == W, false);
  ASSERT_EQUAL_QUIET(W == V, false);
  ASSERT_EQUAL_QUIET(V != B, true);
  ASSERT_EQUAL_QUIET(B != V, true);
  ASSERT_EQUAL_QUIET(V != W, true);
  ASSERT_EQUAL_QUIET(W != V, true);

  W.resize(2);
  
  ASSERT_EQUAL_QUIET(V == W, true);
  ASSERT_EQUAL_QUIET(V != W, false);
}
DECLARE_HOST_DEVICE_UNITTEST(TestArray1dViewEquality);

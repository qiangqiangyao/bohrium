FROM quay.io/pypa/manylinux1_x86_64:latest
MAINTAINER Mads R. B. Kristensen <madsbk@gmail.com>

# cmake 2.8 is installed but need a link
RUN ln -s /usr/bin/cmake28 /usr/bin/cmake

# The build root
RUN mkdir /b
WORKDIR /b

# Install gcc7 (/opt/gcc7)
RUN wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.2.0/gcc-7.2.0.tar.gz
RUN tar -xzf gcc-7.2.0.tar.gz
WORKDIR gcc-7.2.0
RUN ./contrib/download_prerequisites
RUN mkdir -p /b/gcc_build
WORKDIR /b/gcc_build
RUN /b/gcc-7.2.0/configure --prefix /opt/gcc7 --enable-languages=c --disable-bootstrap
RUN make -j4
RUN make install
ENV PATH /opt/gcc7/bin:$PATH
ENV LD_LIBRARY_PATH "/opt/gcc7/lib64:$LD_LIBRARY_PATH"

# Install Boost with -fPIC (system-wide)
RUN wget --no-check-certificate  https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.gz
RUN tar -xzf boost_1_63_0.tar.gz
WORKDIR boost_1_63_0
RUN ./bootstrap.sh --without-libraries=python --without-libraries=mpi --with-icu
RUN ./b2 -q variant=release debug-symbols=off threading=multi runtime-link=shared  link=static,shared toolset=gcc cxxflags="-fPIC" --layout=system  install
WORKDIR /b

# Install SWIG (system-wide)
RUN yum install -y pcre pcre-devel
RUN wget --no-check-certificate https://sourceforge.net/projects/swig/files/swig/swig-3.0.12/swig-3.0.12.tar.gz
RUN tar -xzf swig-3.0.12.tar.gz
WORKDIR swig-3.0.12
RUN ./configure
RUN make -j4
RUN make install
WORKDIR /b

# Use Python 2.7 for the reset of the installation
ENV PATH /opt/python/cp27-cp27mu/bin/:$PATH

# Install Python dependencies
RUN PATH=/opt/python/cp27-cp27mu/bin:$PATH pip install numpy cython scipy
RUN PATH=/opt/python/cp27-cp27mu/bin:$PATH pip install 'subprocess32==3.5.0rc1'
RUN PATH=/opt/python/cp27-cp27mu/bin:$PATH pip install matplotlib netCDF4
RUN PATH=/opt/python/cp36-cp36m/bin:$PATH  pip install numpy cython scipy matplotlib netCDF4

# Install AMD SDK for OpenCL (/opt/AMDAPPSDK-2.9-1)
RUN yum install -y redhat-lsb
RUN mkdir -p amd_src
ADD AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 amd_src
ENV OPENCL_HOME /opt/AMDAPPSDK-2.9-1
ENV OPENCL_LIBPATH /opt/AMDAPPSDK-2.9-1/lib/x86_64
RUN sh amd_src/AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh -- -s -a yes > /dev/null
ENV OpenCL_LIBPATH "/opt/AMDAPPSDK-2.9-1/lib/x86_64/"
ENV OpenCL_INCPATH "/opt/AMDAPPSDK-2.9-1/include"
ENV LD_LIBRARY_PATH "$OpenCL_LIBPATH:$LD_LIBRARY_PATH"
WORKDIR /b

# Install BLAS/LAPACK extmethod dependencies
RUN yum install -y atlas-devel-3.8.3-1.el5.x86_64
RUN yum install -y openblas-devel-0.2.18-5.el5.x86_64

# Install OpenCV 3
WORKDIR /b
RUN wget --no-check-certificate https://github.com/opencv/opencv/archive/3.2.0.zip
RUN unzip 3.2.0
RUN mkdir -p opencv-3.2.0/build
WORKDIR opencv-3.2.0/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_LAPACK=OFF -DBUILD_SHARED_LIBS=NO -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" -DCMAKE_SHARED_LINKER_FLAGS="-static-libgcc -static-libstdc++"
RUN make install -j4
RUN ldconfig

# Install deploy dependencies
RUN PATH=/opt/python/cp27-cp27mu/bin:$PATH pip install twine

## Clean up
WORKDIR /
RUN rm -Rf /b
RUN yum clean all



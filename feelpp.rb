require 'formula'

# We remove the use of submodules as it makes the checkout step
# fails if we don't have access to them but keep the ones in contrib
class GitNoSubmoduleDownloadStrategy < GitDownloadStrategy
  def initialize name, resource
    super
  end
  def update_submodules
    safe_system 'git', 'submodule', '--quiet', 'deinit', '-f', '--all'
    safe_system 'git', 'submodule', '--quiet', 'update', '--init', 'contrib'
  end
end

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.101.1/feelpp-0.101.1.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :using => GitNoSubmoduleDownloadStrategy, :branch => 'develop'
  version '0.101.1'
  sha256 '70418fb0ce9f5069190fcc1677615663dbca71cea39e2b858356476a9e8627cf'


  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'cmake' => :build
  depends_on 'cln'
  depends_on 'bson'
  depends_on 'mongoc'
  depends_on 'eigen'
  depends_on 'hdf5' => ['with-mpi']
  depends_on 'gmsh' => :recommended #feel++ can download and install it
  depends_on 'scalapack'
  depends_on 'petsc'
  depends_on 'slepc' => :recommended
  depends_on 'boost' => ['c++11']
  depends_on 'boost-mpi' => ['c++11']
  depends_on 'boost-python' => ['c++11']  
  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended
  depends_on 'doxygen' => :optional

  def install
    # had to keep application for mesh_partitioner
    args=std_cmake_args+ ['-DFEELPP_ENABLE_TESTS=OFF', '-Wno-dev']


    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "..", *args
      system "cd", "contrib", "&&", "make", "install", "-j#{ENV.make_jobs}"
      system "cd", "feel", "&&", "make", "install", "-j#{ENV.make_jobs}"
      system "cd", "applications/mesh", "&&", "make", "install", "-j#{ENV.make_jobs}"
      system "make", "install-feelpp-lib", "-j#{ENV.make_jobs}"
    end
  end

  # create a CMakeLists.txt and a test.cpp initializing the environment
  # and try to compile it
  test do
    (testpath/"CMakeLists.txt").write <<-EOS.undent
      if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR} )
        find_package(Feel++
                PATHS $ENV{FEELPP_DIR}/share/feelpp/feel/cmake/modules
                      /usr/share/feelpp/feel/cmake/modules
                      /usr/local/share/feelpp/feel/cmake/modules
                      /opt/share/feelpp/feel/cmake/modules
                      )
        if(NOT FEELPP_FOUND)
          message(FATAL_ERROR "Feel++ was not found on your system. Make sure to install it and specify the FEELPP_DIR to reference the installation directory.")
        endif()
      endif()
      feelpp_add_application(test_homebrew SRCS test.cpp )
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
      #include <feel/feelcore/environment.hpp>
      using namespace Feel;
      int main(int argc, char** argv)
      {
        Environment env( _argc=argc, _argv=argv);
        return 0;
      }
    EOS
    system "cmake", "."
    system 'make', 'feelpp_test_homebrew'
  end
end

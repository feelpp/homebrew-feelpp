require 'formula'

# We remove the use of submodules as it makes the checkout step
# fails if we don't have access to them
class GitNoSubmoduleDownloadStrategy < GitDownloadStrategy
      def submodules?; false; end
end

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.101.1/feelpp-0.101.1.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :branch => 'develop'
  version '0.101.1'
  sha256 '70418fb0ce9f5069190fcc1677615663dbca71cea39e2b858356476a9e8627cf'


  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'libtool'
  depends_on 'cmake' => :build
  depends_on 'cln'
  depends_on 'eigen'
  depends_on 'gmsh' => :recommended #feel++ can download and install it
  depends_on 'scalapack'
  depends_on 'petsc'
  depends_on 'slepc' => :recommended
  depends_on 'boost' #=> ['without-single', 'without-static', 'with-mpi', 'c++11']
  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended
  depends_on 'doxygen' => :optional

  def install
    # Quick Fix for petsc version
    #system "sed -i.bak \"s/set(PETSC_VERSIONS /set(PETSC_VERSIONS 3.5.3_3 /g\" cmake/modules/FindPETSc.cmake"
    args=std_cmake_args+ ['-DFEELPP_ENABLE_TESTS=OFF',
                          '-DFEELPP_ENABLE_APPLICATIONS=OFF']


    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "..", *args
      system "make", "quickstart"
      system "make", "install"
    end
  end

  test do
    system "make", "check"
  end
end

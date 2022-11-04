require 'formula'

# We remove the use of submodules as it makes the checkout step
# fails if we don't have access to them but keep the ones in contrib
class GitNoSubmoduleDownloadStrategy < GitDownloadStrategy
  def initialize name, resource
    super
  end
  def update_submodules
    safe_system 'git', 'submodule', '--quiet', 'deinit', '-f', '--all'
    safe_system 'git', 'submodule', '--quiet', 'update', '--init', '--recursive'
  end
end

class Feelpp < Formula
  homepage 'http://docs.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.104.0-beta.1/feelpp-0.104.0-beta.1.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :using => GitNoSubmoduleDownloadStrategy, :branch => 'develop'
  version '0.110.0-rc.2'
  sha256 '70418fb0ce9f5069190fcc1677615663dbca71cea39e2b858356476a9e8627cf'

  # on M1 cln must be compiled from source and HEAD/installed like this: brew install --build-from-source cln --HEAD
  depends_on 'cmake' => :build
  depends_on 'cln'
  depends_on 'mongo-c'
  depends_on 'eigen'
  depends_on 'hdf5' => ['with-mpi']
  depends_on 'gmsh' => :recommended #feel++ can download and install it
  depends_on 'scalapack'
  depends_on 'petsc'
#  depends_on 'slepc' => :recommended
  depends_on 'boost' => ['c++17']
  depends_on 'boost-mpi' => ['c++17']
#  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended
  depends_on 'doxygen' => :optional

  def install
    system "cmake","--preset","feelpp"
    system "cmake","--build","--preset","feelpp"
    system "cmake","--build","--preset","feelpp","install"
  end

  # create a CMakeLists.txt and a test.cpp initializing the environment
  # and try to compile it
  test do
#    system 'ctest', '--preset','feelpp','qs'
  end
end

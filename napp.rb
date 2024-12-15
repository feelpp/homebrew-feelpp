class Napp < Formula
    desc "NAPP: C++ implementation of named arguments for functions"
    homepage "https://github.com/vincentchabannes/napp" # Replace with the official homepage URL
    url "https://github.com/vincentchabannes/napp/archive/refs/tags/v0.3.0.tar.gz" # Replace with actual tarball URL
#    sha256 "examplechecksum1234567890abcdef1234567890abcdef1234567890abcdef" # Replace with actual SHA256 checksum
    license "MIT" # Replace with the appropriate license
  
    depends_on "cmake" => :build
    depends_on "boost" # Example dependency; replace with actual dependencies
    depends_on "eigen" # Replace with dependencies specified in Spack package
  
    def install
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  
    test do
      # Basic test to ensure the package was installed correctly
      system "#{bin}/napp", "--help"
    end
  end
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

class FeelppCrb < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.101.1/feelpp-0.101.1.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :using => GitNoSubmoduleDownloadStrategy, :branch => 'develop'
  version '0.101.1'
  sha256 '70418fb0ce9f5069190fcc1677615663dbca71cea39e2b858356476a9e8627cf'


  depends_on 'feelpp' 

  def install
    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "../applications/crb", *args
      system "make", "-j#{ENV.make_jobs}","&&","make","install"
    end
  end

  test do
  end
end

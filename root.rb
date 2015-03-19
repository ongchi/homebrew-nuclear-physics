class Root < Formula
  homepage "http://root.cern.ch"
  version "5.34.26"
  sha1 "f9013c37c37946b79dce777d731ccb64e5b28bb8"
  url "ftp://root.cern.ch/root/root_v#{version}.source.tar.gz"
  mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"

  option "with-gdml", "Build with GDML writer and reader support"
  option "with-roofit", "Build the libRooFit advanced fitting package"
  option "with-gsl", "Build the GSL library internally"

  depends_on 'cmake' => :build
  depends_on "openssl"
  depends_on "fftw" => :optional
  depends_on "qt" => [:optional, "with-qt3support"]
  depends_on "xrootd" => :optional
  depends_on :x11 => :optional
  depends_on :python => :recommended

  needs :cxx11

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    args = std_cmake_args.concat %W[
      ..
      -Dcxx11=ON
      -Dgnuinstall=ON
    ]
    args << '-DQT=ON' if build.with? 'qt'
    args << '-DFFTW3=ON' if build.with? 'fftw'
    args << '-Dbuiltin_gsl=ON' if build.with? 'gsl'
    args << '-DXROOTD=ON' if build.with? 'xrootd'
    args << '-DGDML=ON' if build.with? 'gdml'

    mkdir "root-build" do
      system "cmake", *args
      system "make", "install"
    end

    # needed to run test suite
    prefix.install "test"

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  test do
    system "make", "-C", "#{prefix}/test/", "hsimple"
    system "#{prefix}/test/hsimple"
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . $(brew --prefix root)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root`/libexec/thisroot.csh
    EOS
  end
end

require 'formula'

class G4py < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.cern.ch/support/source/geant4.10.01.tar.gz'
  sha1 'd888b992b789a0d0e0a1a13debc9a51dae5e3743'

  keg_only "Conflicts with geant in homebrew-science."

  depends_on 'cmake' => :build
  depends_on 'ongchi/nuclear-physics/geant4' => "with-gdml"
  depends_on 'boost-python'
  depends_on :python

  def install
    mkdir 'g4py-build' do
      args = %W[
               ../environments/g4py
               ]

      # CMake picks up the system's python dylib, even if we have a brewed one.
      args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"

      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end

    lib.install Dir["environments/g4py/lib/*"]
  end

  def caveats; <<-EOS.undent
    Environment variables are required at run time.

    For bash users:
      export PYTHONPATH=/usr/local/opt/g4py/lib:$PYTHONPATH
    For csh/tcsh users:
      setenv PYTHONPATH /usr/local/opt/g4py/lib:$PYTHONPATH
    EOS
  end
end

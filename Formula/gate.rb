class Gate < Formula
  desc "Geant4 Application for Emission Tomography: a simulation toolkit for PET and SPECT"
  homepage "http://www.opengatecollaboration.org"
  url "http://www.opengatecollaboration.org/sites/default/files/gate_v7.2.tar.gz"
  version "7.2"
  sha256 "e066699dbd0139462abcf3a0186b3e5fea7ad8a5b047a5ed38e2dc2821b08a1c"

  depends_on "cmake" => :build
  depends_on "ongchi/nuclear-physics/geant4" => ["with-qt5", "without-multithreaded"]
  depends_on "root"
  depends_on "qt5"

  def install
    mkdir 'gate-build' do
      system "cmake", "..",
        *std_cmake_args
      system "make", "install"
    end
  end
end

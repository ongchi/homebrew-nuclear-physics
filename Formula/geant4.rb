class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.02.p02.tar.gz"
  version "10.2.2"
  sha256 "702fb0f7a78d4bdf1e3f14508de26e4db5e2df6a21a8066a92b7e6ce21f4eb2d"

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"
  option "with-multithreaded", "Build with multithreading support"

  depends_on "cmake" => :run
  depends_on :x11
  depends_on "qt5" => :optional
  depends_on "xerces-c" if build.with? "gdml"

  resource "G4NEUTRONHPDATA" do
    url "http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4LEDATA" do
    url "http://geant4.cern.ch/support/source/G4EMLOW.6.48.tar.gz"
    sha256 "9815be88cbbcc4e8855b20244d586552a8b1819b8bf4e538c342b27c17dff1c7"
  end

  resource "G4LEVELGAMMADATA" do
    url "http://geant4.cern.ch/support/source/G4PhotonEvaporation.3.2.tar.gz"
    sha256 "35ed450a47aa610ce83c9095e17e43006e0da9557bf4433ac96ce19c730492d4"
  end

  resource "G4RADIOACTIVEDATA" do
    url "http://geant4.cern.ch/support/source/G4RadioactiveDecay.4.3.2.tar.gz"
    sha256 "43b558891f02b1f4796b913b89be607827995043cb678275c06a85e03b5b5c18"
  end

  resource "G4NEUTRONXSDATA" do
    url "http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PIIDATA" do
    url "http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4REALSURFACEDATA" do
    url "http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz"
    sha256 "3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1"
  end

  resource "G4SAIDXSDATA" do
    url "http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLADATA" do
    url "http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz"
    sha256 "99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014"
  end

  resource "G4ENSDFSTATEDATA" do
    url "http://geant4.cern.ch/support/source/G4ENSDFSTATE.1.2.3.tar.gz"
    sha256 "15fb26d08a24f620f21566b5cddb7e07f0b06140899b03932d6cf76925130b75"
  end

  def install
    (share/"Geant4-#{version}/data/G4NDL4.5").install resource("G4NEUTRONHPDATA")
    (share/"Geant4-#{version}/data/G4EMLOW6.48").install resource("G4LEDATA")
    (share/"Geant4-#{version}/data/PhotonEvaporation3.2").install resource("G4LEVELGAMMADATA")
    (share/"Geant4-#{version}/data/RadioactiveDecay4.3.2").install resource("G4RADIOACTIVEDATA")
    (share/"Geant4-#{version}/data/G4NEUTRONXS1.4").install resource("G4NEUTRONXSDATA")
    (share/"Geant4-#{version}/data/G4PII1.3").install resource("G4PIIDATA")
    (share/"Geant4-#{version}/data/RealSurface1.0").install resource("G4REALSURFACEDATA")
    (share/"Geant4-#{version}/data/G4SAIDDATA1.1").install resource("G4SAIDXSDATA")
    (share/"Geant4-#{version}/data/G4ABLA3.0").install resource("G4ABLADATA")
    (share/"Geant4-#{version}/data/G4ENSDFSTATE1.2.3").install resource("G4ENSDFSTATEDATA")

    mkdir "geant4-build" do
      args = %W[
               ..
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
               ]

      args << "-DGEANT4_USE_QT=ON" if build.with? "qt5"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end
end

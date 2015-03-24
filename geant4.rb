require 'formula'

class Geant4 < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.cern.ch/support/source/geant4.10.01.tar.gz'
  sha1 'd888b992b789a0d0e0a1a13debc9a51dae5e3743'

  keg_only "Conflicts with geant in homebrew-science."

  option 'with-g3tog4', 'Use G3toG4 Library'
  option 'with-gdml', 'Use GDML'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'clhep' => :optional
  depends_on 'qt' => :optional
  depends_on 'xerces-c' if build.with? 'gdml'

  resource 'G4NEUTRONHPDATA' do
    url 'http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz'
    sha256 'cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e'
  end

  resource 'G4LEDATA' do
    url 'http://geant4.cern.ch/support/source/G4EMLOW.6.41.tar.gz'
    sha256 '6d878b18bf5e748e9d0ea35ef67eebab16df80cc912402986a03a5e1935f4af2'
  end

  resource 'G4LEVELGAMMADATA' do
    url 'http://geant4.cern.ch/support/source/G4PhotonEvaporation.3.1.tar.gz'
    sha256 '276ac5f7b45ce96ae0927c7a3fff0942b7007cfe9339540fc22554fea433142e'
  end

  resource 'G4RADIOACTIVEDATA' do
    url 'http://geant4.cern.ch/support/source/G4RadioactiveDecay.4.2.tar.gz'
    sha256 'cf1946d9e2c222ec1311e7ed94a54a6646cf519b71299e2297a6be3c85ba3c82'
  end

  resource 'G4NEUTRONXSDATA' do
    url 'http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz'
    sha256 '57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd'
  end

  resource 'G4PIIDATA' do
    url 'http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz'
    sha256 '6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926'
  end

  resource 'G4REALSURFACEDATA' do
    url 'http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz'
    sha256 '3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1'
  end

  resource 'G4SAIDXSDATA' do
    url 'http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz'
    sha256 'a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f'
  end

  resource 'G4ABLADATA' do
    url 'http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz'
    sha256 '99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014'
  end

  def install
    (share/'Geant4-10.1.0/data/G4NDL4.5').install resource('G4NEUTRONHPDATA')
    (share/'Geant4-10.1.0/data/G4EMLOW6.41').install resource('G4LEDATA')
    (share/'Geant4-10.1.0/data/PhotonEvaporation3.1').install resource('G4LEVELGAMMADATA')
    (share/'Geant4-10.1.0/data/RadioactiveDecay4.2').install resource('G4RADIOACTIVEDATA')
    (share/'Geant4-10.1.0/data/G4NEUTRONXS1.4').install resource('G4NEUTRONXSDATA')
    (share/'Geant4-10.1.0/data/G4PII1.3').install resource('G4PIIDATA')
    (share/'Geant4-10.1.0/data/RealSurface1.0').install resource('G4REALSURFACEDATA')
    (share/'Geant4-10.1.0/data/G4SAIDDATA1.1').install resource('G4SAIDXSDATA')
    (share/'Geant4-10.1.0/data/G4ABLA3.0').install resource('G4ABLADATA')
    
    mkdir 'geant4-build' do
      args = %W[
               ../
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
               -DGEANT4_BUILD_EXAMPLE=ON
               ]

      args << '-DGEANT4_USE_QT=ON' if build.with? 'qt'
      args << '-DGEANT4_USE_G3TOG4=ON' if build.with? 'g3tog4'
      args << '-DGEANT4_USE_GDML=ON' if build.with? 'gdml'
      args << '-DGEANT4_USE_SYSTEM_CLHEP=ON' if build.with? 'clhep'
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    Environment variables are required at run time.

    For bash users:
      . $(brew --prefix geant4)/bin/geant4.sh
    For zsh users:
      pushd $(brew --prefix geant4)/bin >/dev/null; . ./geant4.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix geant4`/bin/geant4.csh
    EOS
  end
end

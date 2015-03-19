require 'formula'

class Geant4 < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.web.cern.ch/geant4/support/source/geant4.9.6.p04.tar.gz'
  version '9.6.p04'
  sha1 'f1cdab8cbbdf2397fbe4f12260055cf6c2f202d6'

  option 'with-g3tog4', 'Use G3toG4 Library'
  option 'with-gdml', 'Use GDML'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'clhep' => :optional
  depends_on 'qt' => :optional
  depends_on 'xerces-c' if build.with? 'gdml'

  resource 'G4NEUTRONHPDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4NDL.4.2.tar.gz'
    sha256 '173f60a506b9176d7ff531d6a5f6195dcec74df30ffafc09644f47f979bd641b'
  end

  resource 'G4LEDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4EMLOW.6.32_permissions.tar.gz'
    sha256 '738361fe9f1ce164aa22e460c1b68941457e4160b8da86dcba576e873c5cc293'
  end

  resource 'G4LEVELGAMMADATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4PhotonEvaporation.2.3.tar.gz'
    sha256 '60449df933794aa0ad3938886c8c023e3093ff59ad6c752923390d5c550f34cb'
  end

  resource 'G4RADIOACTIVEDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4RadioactiveDecay.3.6.tar.gz'
    sha256 '3502ed4be04d694115a3acf59d7a3593725a2d79f3adad0ffa135ff653f89d1d'
  end

  resource 'G4NEUTRONXSDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4NEUTRONXS.1.2.tar.gz'
    sha256 '9ce488505b4c3623e2d98209f708a30e3f213a1371a9110d289257a02b2d7d5c'
  end

  resource 'G4PIIDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4PII.1.3.tar.gz'
    sha256 '6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926'
  end

  resource 'G4REALSURFACEDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/RealSurface.1.0.tar.gz'
    sha256 '3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1'
  end

  resource 'G4SAIDXSDATA' do
    url 'http://geant4.web.cern.ch/geant4/support/source/G4SAIDDATA.1.1.tar.gz'
    sha256 'a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f'
  end

  def install
    (share/'Geant4-9.6.4/data/G4NDL4.2').install resource('G4NEUTRONHPDATA')
    (share/'Geant4-9.6.4/data/G4EMLOW6.32').install resource('G4LEDATA')
    (share/'Geant4-9.6.4/data/PhotonEvaporation2.3').install resource('G4LEVELGAMMADATA')
    (share/'Geant4-9.6.4/data/RadioactiveDecay3.6').install resource('G4RADIOACTIVEDATA')
    (share/'Geant4-9.6.4/data/G4NEUTRONXS1.2').install resource('G4NEUTRONXSDATA')
    (share/'Geant4-9.6.4/data/G4PII1.3').install resource('G4PIIDATA')
    (share/'Geant4-9.6.4/data/RealSurface1.0').install resource('G4REALSURFACEDATA')
    (share/'Geant4-9.6.4/data/G4SAIDDATA1.1').install resource('G4SAIDXSDATA')
    
    mkdir 'geant4-build' do
      args = %W[
               ..
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
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
end

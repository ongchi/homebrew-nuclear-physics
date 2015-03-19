require 'formula'

class Geant4 < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.web.cern.ch/geant4/support/source/geant4.9.6.p04.tar.gz'
  sha1 'f1cdab8cbbdf2397fbe4f12260055cf6c2f202d6'

  option 'with-g3tog4', 'Use G3toG4 Library'
  option 'with-gdml', 'Use GDML'
  option 'with-notimeout', 'Set notimeout in installing data'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'clhep' => :optional
  depends_on 'qt' => :optional
  depends_on 'xerces-c' if build.with? 'gdml'

  def install
    mkdir 'geant-build' do
      args = %W[
               ../
               -Dgnuinstall=ON
               -Dbuiltin_freetype=ON
               -DGEANT4_INSTALL_DATA=ON
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
               -DGEANT4_BUILD_EXAMPLE=ON
               ]

      args << '-DGEANT4_INSTALL_DATA_TIMEOUT=86400' if build.with? 'notimeout'
      args << '-DGEANT4_USE_QT=ON' if build.with? 'qt'
      args << '-DGEANT4_USE_G3TOG4=ON' if build.with? 'g3tog4'
      args << '-DGEANT4_USE_GDML=ON' if build.with? 'gdml'
      args << '-DGEANT4_USE_SYSTEM_CLHEP=ON' if build.without? 'clhep'
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end
end

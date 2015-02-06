require "formula"

class Gate < Formula
  homepage "http://www.opengatecollaboration.org"
  url "http://www.opengatecollaboration.org/sites/opengatecollaboration.org/files/gate_v7.0.tar.gz"
  version '7.0'
  sha1 "c2933786d8e9cee97011c3ebe198fc6e1fb5fe1d"

  option 'with-benchmarks', 'Download Benchmarks Data'
  option 'with-examples', 'Download Examples Data'
  option 'with-ecat7', 'ECAT7 Support'
  option 'with-lmf', 'LMF Support'
  option 'with-gpu', 'CUDA Support'
  option 'with-optical', 'Optical Support'
  option 'with-clhep', 'Use System CLHEP Library'

  depends_on 'cmake' => :build
  depends_on 'clhep' if build.with? 'clhep'

  def install
    mkdir 'gate-build' do
      args = %W[
               ../
               ]

      args << '-DGATE_DOWNLOAD_BENCHMARKS_DATA=ON' if build.with? 'benchmarks'
      args << '-DGATE_DOWNLOAD_EXAMPLES_DATA=ON' if build.with? 'examples'
      arcs << '-DGATE_USE_ECAT7=ON' if build.with? 'ecat7'
      args << '-DGATE_USE_GPU=ON' if build.with? 'gpu'
      args << '-DGATE_USE_LMF=ON' if build.with? 'lmf'
      args << '-DGATE_USE_OPTICAL=ON' if build.with? 'optical'
      args << '-DGATE_USE_SYSTEM_CLHEP=ON' if build.with? 'clhep'
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make install"
    end
  end
end

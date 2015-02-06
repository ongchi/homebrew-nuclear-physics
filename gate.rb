require "formula"

class Gate < Formula
  homepage "http://www.opengatecollaboration.org"
  url "http://git.opengatecollaboration.org/git/opengate-public.git", :using => :git, :tag => "master"
  version "7.0"

  depends_on 'cmake' => :build

  needs :cxx11

  patch :DATA

  def install
    ENV['CXXFLAGS'] = "-std=c++11"
    # gcc = Formula["gcc"]
    mkdir 'gate-build' do
      # system "tar", "xvf", "../gate_v7.0.tar_"
      system "cmake", "..",
        # "-DCMAKE_C_COMPILER=#{gcc.bin}/gcc-#{gcc.version_suffix}",
        # "-DCMAKE_CXX_COMPILER=#{gcc.bin}/g++-#{gcc.version_suffix}",
        *std_cmake_args
      system "make", "install"
    end
  end
end

__END__
diff --git a/source/arf/src/GateARFTableMgr.cc b/source/arf/src/GateARFTableMgr.cc
index 49161ee..46f5e5f 100644
--- a/source/arf/src/GateARFTableMgr.cc
+++ b/source/arf/src/GateARFTableMgr.cc
@@ -222,7 +222,7 @@ G4cout << " --------------------------------------------------------------------
 void GateARFTableMgr::SaveARFToBinaryFile()
 {
 
-ofstream dest;
+std::ofstream dest;
 dest.open ( theFN.c_str() );
 
 std::map<G4int,GateARFTable*>::iterator aIt;
@@ -298,7 +298,7 @@ void GateARFTableMgr::LoadARFFromBinaryFile(G4String theFileName)
 
   G4String basename = GetName()+"ARFTable_";
 
-  ifstream dest;
+  std::ifstream dest;
   dest.open ( theFileName.c_str(),std::ios::binary );
 
     dest.seekg(0, std::ios::beg);
diff --git a/source/digits_hits/include/GateDiffCrossSectionActor.hh b/source/digits_hits/include/GateDiffCrossSectionActor.hh
index 07ce504..2f39e53 100644
--- a/source/digits_hits/include/GateDiffCrossSectionActor.hh
+++ b/source/digits_hits/include/GateDiffCrossSectionActor.hh
@@ -64,10 +64,10 @@ class GateDiffCrossSectionActor : public GateVActor
   void SetMaterial(G4String name);
   void ReadMaterialList(G4String filename);
 
-  ofstream PointerToFileDataOutSF;
-  ofstream PointerToFileDataOutFF;
-  ofstream PointerToFileDataOutDCScompton;
-  ofstream PointerToFileDataOutDCSrayleigh;
+  std::ofstream PointerToFileDataOutSF;
+  std::ofstream PointerToFileDataOutFF;
+  std::ofstream PointerToFileDataOutDCScompton;
+  std::ofstream PointerToFileDataOutDCSrayleigh;
   std::stringstream DriverDataOutSF;
   std::stringstream DriverDataOutFF;
   std::stringstream DriverDataOutDCScompton;

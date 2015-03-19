require "formula"

class Gate < Formula
  homepage "http://www.opengatecollaboration.org"
  url "http://git.opengatecollaboration.org/git/opengate-public.git", :using => :git, :tag => "master"
  version "7.0"

  depends_on 'cmake' => :build
  depends_on 'geant4' => ["with-gdml", "with-qt"]
  depends_on 'root' => "with-gdml"
  depends_on 'qt'

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
diff --git a/source/physics/src/GateBinaryCascade.cc b/source/physics/src/GateBinaryCascade.cc
index 3301c02..dd413ed 100644
--- a/source/physics/src/GateBinaryCascade.cc
+++ b/source/physics/src/GateBinaryCascade.cc
@@ -887,7 +887,7 @@ void GateBinaryCascade::BuildTargetList()
   ClearAndDestroy(&theTargetList);  // clear theTargetList before rebuilding
 
   G4Nucleon * nucleon;
-  G4ParticleDefinition * definition;
+  const G4ParticleDefinition * definition;
   G4ThreeVector pos;
   G4LorentzVector mom;
 // if there are nucleon hit by higher energy models, then SUM(momenta) != 0
@@ -1110,7 +1110,7 @@ G4bool GateBinaryCascade::ApplyCollision(G4CollisionInitialState * collision)
      std::vector<G4KineticTrack *>::iterator titer;
      for ( titer=target_collection.begin() ; titer!=target_collection.end(); ++titer)
      {
- G4ParticleDefinition * aDef=(*titer)->GetDefinition();
+ const G4ParticleDefinition * aDef=(*titer)->GetDefinition();
  G4int aCode=aDef->GetPDGEncoding();
  G4ThreeVector aPos=(*titer)->GetPosition();
  initial_Efermi+= RKprop->GetField(aCode, aPos);
@@ -1477,7 +1477,7 @@ G4bool GateBinaryCascade::CheckPauliPrinciple(G4KineticTrackVector * products)
   const G4VNuclearDensity * density=the3DNucleus->GetNuclearDensity();
 
   G4KineticTrackVector::iterator i;
-  G4ParticleDefinition * definition;
+  const G4ParticleDefinition * definition;
 
 // ------ debug
   G4bool myflag = true;
@@ -2340,7 +2340,7 @@ G4Fragment * GateBinaryCascade::FindFragments()
   fragment->SetNumberOfParticles(excitons);
   fragment->SetNumberOfCharged(zCaptured);
   G4ParticleDefinition * aIonDefinition =
-       G4ParticleTable::GetParticleTable()->FindIon(a,z,0,z);
+       G4IonTable::GetIonTable()->FindIon(a,z,0,z);
   fragment->SetParticleDefinition(aIonDefinition);
 
   return fragment;
@@ -2613,7 +2613,7 @@ void GateBinaryCascade::PrintKTVector(G4KineticTrack * kt, std::string comment)
     G4ThreeVector pos = kt->GetPosition();
     G4LorentzVector mom = kt->Get4Momentum();
     G4LorentzVector tmom = kt->GetTrackingMomentum();
-    G4ParticleDefinition * definition = kt->GetDefinition();
+    const G4ParticleDefinition * definition = kt->GetDefinition();
     G4cout << "    definition: " << definition->GetPDGEncoding() << " pos: "
     << 1/fermi*pos << " R: " << 1/fermi*pos.mag() << " 4mom: "
     << 1/MeV*mom <<"Tr_mom" <<  1/MeV*tmom << " P: " << 1/MeV*mom.vect().mag() 
@@ -2634,7 +2634,7 @@ G4bool GateBinaryCascade::CheckDecay(G4KineticTrackVector * products)
   const G4VNuclearDensity * density=the3DNucleus->GetNuclearDensity();
 
   G4KineticTrackVector::iterator i;
-  G4ParticleDefinition * definition;
+  const G4ParticleDefinition * definition;
 
 // ------ debug
   G4bool myflag = true;
diff --git a/source/physics/src/GateSingleParticleSourceMessenger.cc b/source/physics/src/GateSingleParticleSourceMessenger.cc
index b42a20e..47589ef 100644
--- a/source/physics/src/GateSingleParticleSourceMessenger.cc
+++ b/source/physics/src/GateSingleParticleSourceMessenger.cc
@@ -14,6 +14,7 @@
 #include "G4Geantino.hh"
 #include "G4ThreeVector.hh"
 #include "G4ParticleTable.hh"
+#include "G4IonTable.hh"
 #include "G4UIdirectory.hh"
 #include "G4UIcmdWithoutParameter.hh"
 #include "G4UIcmdWithAString.hh"
@@ -1524,8 +1525,7 @@ void GateSingleParticleSourceMessenger::IonCommand( G4String newValues )
               fIonExciteEnergy = StoD( sQ ) * keV ;
             }
         }
-      G4ParticleDefinition* ion ;
-      ion =  particleTable->GetIon( fAtomicNumber, fAtomicMass, fIonExciteEnergy ) ;
+      G4ParticleDefinition * ion = G4IonTable::GetIonTable()->GetIon( fAtomicNumber, fAtomicMass, fIonExciteEnergy ) ;
       if( ion==0 )
         {
           G4cout << "Ion with Z=" << fAtomicNumber ;
diff --git a/source/physics/src/GateSourcePencilBeam.cc b/source/physics/src/GateSourcePencilBeam.cc
index 4a29350..f4b2b9f 100644
--- a/source/physics/src/GateSourcePencilBeam.cc
+++ b/source/physics/src/GateSourcePencilBeam.cc
@@ -30,6 +30,7 @@
 
 #ifdef G4ANALYSIS_USE_ROOT
 #include "GateSourcePencilBeam.hh"
+#include "G4IonTable.hh"
 #include "G4Proton.hh"
 #include "G4Tokenizer.hh"
 #include <iostream>
@@ -289,7 +290,7 @@ void GateSourcePencilBeam::GenerateVertex( G4Event* aEvent )
 
   string parttype=mParticleType;
   if ( parttype == "GenericIon" ){
-    particle_definition=  particleTable->GetIon( mAtomicNumber, mAtomicMass, mIonExciteEnergy);
+    particle_definition = G4IonTable::GetIonTable()->GetIon( mAtomicNumber, mAtomicMass, mIonExciteEnergy);
   //G4cout<<G4endl<<G4endl<<"mParticleType  "<<mParticleType<<"     selected loop  GenericIon"<<G4endl;
   //G4cout<<mAtomicNumber<<"  "<<mAtomicMass<<"  "<<mIonCharge<<"  "<<mIonExciteEnergy<<G4endl;
   }

#! usr/bin/perl
use strict;
use warnings;

my @interactNoun = ("assembly", "assemblies", "association", "associations", "association with", "associations with", "binding", "bindings",
"co-immunoprecipitation, co-immunoprecipitations, coimmunoprecipitation, coimmunoprecipitations
colocalization", "colocalizations", "co-localization", "co-localizations", "combination", "combinations", "complex",
"complexes", "coprecipitation", "coprecipitations", "co-precipitation", "co-precipitations");

my @interactVerb = qw/coimmunoprecipitate coimmunoprecipitates coimmunoprecipitated
co-immunoprecipitate co-immunoprecipitates co-immunoprecipitated co-localize co-localizes co-localized
combine combines combined precipitate precipitates precipitated assemble assembles assembled associate associates associated binds bound complex complexes complexed coprecipitate
coprecipitates coprecipitated co-precipitate co-precipitates co-precipitated/;

my @interactVerb2 = ("associate with", "associates with", "associated with", "binds to", "bound to");

my @notNeededVerbs = qw/inhibit inhibits inhibited interact interacts interacted modify modifies modified modulate modulates modulated
regulate regulates regulated cleave cleaves cleaved  dimerize dimerizes dimerized disassociate disassociates disassiociated issemble
dissembles dissembled form forms formed phosphorylate phorphorylates phosphorylated
sequester sequesters sequestered transport transportes transported activate activates activated
target targets targeted/;

#there are diff nanogs!!

my @pluriGenes = qw/Oct4 Nanog Sox2 Lin28 C-myc Klf4/;
my @cellDiffGenes = qw/TDGF1 DNM3TB GABRB3 GDF3 Lefty Nodal Sema3a/;
my @neuralLineSpecGenes = qw/Pax6 Nestin Olig2 GFAP Synaptophysin/;

my $test = "Embryonic stem (ES) cells are pluripotent1, 2 and of therapeutic potential in regenerative medicine3, 4.
Understanding pluripotency at the molecular level should illuminate fundamental properties of stem cells and the process
of cellular reprogramming. Through cell fusion the embryonic cell phenotype can be imposed on somatic cells, a process
promoted by the homeodomain protein Nanog5, which is central to the maintenance of ES cell pluripotency6, 7. Nanog is
thought to function in concert with other factors such as Oct4 (ref. 8) and Sox2 (ref. 9) to establish ES cell identity.
Here we explore the protein network in which Nanog operates in mouse ES cells. Using affinity purification of Nanog under
native conditions followed by mass spectrometry, we have identified physically associated proteins. In an iterative fashion
we also identified partners of several Nanog associated proteins (including Oct4), validated the functional relevance of
selected newly identified components and constructed a protein interaction network. The network is highly enriched for nuclear
factors that are individually critical for maintenance of the ES cell state and co-regulated on differentiation. The network is
linked to multiple co-repressor pathways and is composed of numerous proteins whose encoding genes are putative direct transcriptional
targets of its members. This tight protein network seems to function as a cellular module dedicated to pluripotency.";



#pluripotent genes

my $regexplurigene = "";
    
    foreach (@pluriGenes) {
        $regexplurigene .= $_ . "|";
        
    }

$regexplurigene .= "ae";    
print ("the regex is $regexplurigene\n\n");

#cell line diff genes

my $regexcelldiffgene = "";
    
    foreach (@cellDiffGenes) {
        $regexcelldiffgene .= $_ . "|";
        
    }

$regexcelldiffgene .= "ae";

print ("the regex is $regexcelldiffgene\n\n");

#specify germ line genes 

my $regexlinespecgene = "";
    
    foreach (@neuralLineSpecGenes) {
        $regexlinespecgene .= $_ . "|";
        
    }

$regexlinespecgene .= "ae";

print ("the regex is $regexlinespecgene\n\n");

#interact nouns

my $regexnoun = "";
    
    foreach (@interactNoun) {
        $regexnoun .= $_ . "|";
        
    }

$regexnoun .= "ae";

print ("the regex is $regexnoun\n\n");

#interact verb

my $regexverb1 = "";
    
    foreach (@interactVerb) {
        $regexverb1 .= $_ . "|";
        
    }

$regexverb1 .= "ae";

print ("the regex is $regexverb1\n\n");

#interact verb2

my $regexverb2 = "";
    
    foreach (@interactVerb2) {
        $regexverb2 .= $_ . "|";
        
    }

$regexverb2 .= "ae";

print ("the regex is $regexverb2\n\n");

my $gene= "";
my $verb="";
my $gene2="";

       
    if ($test =~ /($regexplurigene|$regexcelldiffgene|$regexlinespecgene)(.+?)($regexverb1|$regexverb2)(.+?)($regexplurigene|$regexcelldiffgene|$regexlinespecgene)/){
        $gene = $1;
        $verb=$3;
        $gene2=$5;
        
        print "the gene found is $gene and it $verb with $gene2\n";
        }

            
        
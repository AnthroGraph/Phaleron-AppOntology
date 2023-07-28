#! /bin/bash

phaleron=0
full=0

function usage {
    
    echo " "
    echo "usage: $0 [-b][-f]"
    echo " "
    echo "    -b          just build Phaleron ontology without dependencies"
    echo "    -f          build Phaleron ontology and include depencency ontology extensions and the RDFBones core ontology"
    echo "    -h -?       print this help"
    echo " "

    exit

}

while getopts "bdfh?" opt; do

    case "$opt" in

	b)
	    phaleron=1
	    ;;

	f)
	    full=1
	    ;;

	?)
	usage
	;;
	h)
	    usage
	    ;;

    esac

done



## SUBMODULES

## check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then

    git submodule init
    git submodule update

fi




if [ $phaleron -ne 1 ]; then

    ## DEPENDENCIES


    ## Build standards-patho.owl

    cd Standards-Pathologies/

    ./Script_StandardsPatho-Robot.sh -b -u -c

    cd ..

fi


## BUILD PHALERON ONTOLOGY EXTENSIONS

## Build phaleron-ae.owl

cd Phaleron-AgeEstimation/

./Script-Build_OntologyExtension-Robot.sh -b -u -c

cd ..

## Build phaleron-di.owl

cd Phaleron-DentalInventory/

./Script_PhaleronDI-Robot.sh -d -u

cd ..

## Build phaleron-dpatho.owl

cd Phaleron-DentalPathologies/
    
./Script_PhaleronDpatho-Robot.sh -b -u -c

cd ..

## Build phaleron-patho.owl

cd Phaleron-Pathologies/

./Script_PhaleronPatho-Robot.sh -b -u -c

cd ..

## Build sb.owl

cd SucheyBrooksPubicAge/

./Script-Build_OntologyExtension-Robot.sh -b -u -c

cd ..


## Merge phaleron-app.owl with phaleron ontology extensions
## phaleron-app_ext.owl

rm -r results/*

robot merge --input phaleron-app.owl \
      --input Phaleron-SkeletalInventory/phaleron-si.owl \
      --input Phaleron-Pathologies/results/phaleron-patho.owl \
      --input Phaleron-DentalInventory/results/phaleron-di.owl \
      --input Phaleron-DentalPathologies/results/phaleron-dpatho.owl \
      --input SucheyBrooksPubicAge/results/sb.owl \
      --input Phaleron-AgeEstimation/results/phaleron-ae.owl \
      --input Phaleron-SexEstimation/phaleron-se.owl \
      --input Phenice-SexEstimation/phenice.owl \
      --input Klales-SexEstimation/klales.owl \
      --input Walker-SexEstimation/walker.owl \
      --input Standards-SexEstimation/standards-se.owl \
      --output results/phaleron-app_ext.owl

if [ $phaleron -eq 1 ]; then

    robot annotate --input results/phaleron-app_ext.owl \
	  --remove-annotations \
	  --ontology-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/latetst/phaleron-app_ext.owl" \
	  --version-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/v0-1/phaleron-app_ext.owl" \https://github.com/RDFBones/Standards-SexEstimation
	  --language-annotation rdfs:label "PBP App ontology extensions" en \
	  --language-annotation dc:description "This ontology combines the Phaleron Bioarchaeological Project App Ontology and all RDFBones ontology extensions that are required for the Phaleron Bioarchaeological Project App to work." en \
	  --language-annotation dc:title "PBP App ontology extensions" en \
	  --output results/phaleron-app_ext.owl

fi


if [ $phaleron -ne 1 ]; then

    ## Merge phaleron-app_ext.owl with required dependencies
    ## phaleron-app_ext_dep.owl
    
    robot merge --input results/phaleron-app_ext.owl \
	  --input Standards-SkeletalInventories/standards-si.owl \
	  --input Standards-Pathologies/results/standards-patho.owl \
	  --input Phaleron-DentalInventory/Dentalwear/results/dentalwear.owl \
	  --input Phaleron-DentalInventory/DentDev/results/dentdev.owl \
	  --input Phaleron-DentalInventory/Standards-Dental1/results/standards-dental1.owl \
	  --input Phaleron-DentalInventory/Wearpatterns/results/wearpatterns.owl \
	  --input Phaleron-DentalPathologies/BABAO/results/babao.owl \
	  --input Phaleron-DentalPathologies/DentalPathology/results/dentpath.owl \
	  --output results/phaleron-app_ext_dep.owl

    rm results/phaleron-app_ext.owl

    if [ $phaleron -ne 1 ] || [ $full -ne 1 ]; then

	robot annotate --input results/phaleron-app_ext_dep.owl \
	      --remove-annotations \
	      --ontology-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/latetst/phaleron-app_ext_dep.owl" \
	      --version-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/v0-1/phaleron-app_ext_dep.owl" \
	      --language-annotation rdfs:label "PBP App ontology extensions and dependencies" en \
	      --language-annotation dc:description "This ontology combines the Phaleron Bioarchaeological Project App Ontology, all RDFBones ontology extensions that are required for the Phaleron Bioarchaeological Project App to work and their dependencies." en \
	      --language-annotation dc:title "PBP App ontology extensions and dependencies" en \
	      --output results/phaleron-app_ext_dep.owl

    fi

fi


if [ $full -eq 1 ]; then

    ## Merge core ontology

    cd RDFBones-O/robot
    ./Script-Build_RDFBones-Robot.sh
    cd ../../

    ## Merge phaleron-app_ext_dep.owl with the RDFBones core ontology
    ## phaleron-app_ext_dep_core.owl

    robot merge --input results/phaleron-app_ext_dep.owl \
	  --input RDFBones-O/robot/results/rdfbones.owl \
	  --output results/phaleron-app_ext_dep_core.owl

    rm -r RDFBones-O/robot/results/

    rm results/phaleron-app_ext_dep.owl

    robot annotate --input results/phaleron-app_ext_dep_core.owl \
	  --remove-annotations \
	  --ontology-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/latetst/phaleron-app_ext_dep_core.owl" \
	  --version-iri "http://w3id.org/rdfbones/ontology_resources/app/phaleron-app/v0-1/phaleron-app_ext_dep_core.owl" \
	  --language-annotation rdfs:label "PBP App ontology extensions, dependencies and RDFBones core ontology" en \
	  --language-annotation dc:description "This ontology combines the Phaleron Bioarchaeological Project App Ontology, all RDFBones ontology extensions that are required for the Phaleron Bioarchaeological Project App to work, their dependencies and the RDFBones core ontology." en \
	  --language-annotation dc:title "PBP App ontology extensions, dependencies and RDFBones core ontology" en \
	  --output results/phaleron-app_ext_dep_core.owl

fi



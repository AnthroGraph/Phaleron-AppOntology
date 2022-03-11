# Phaleron-AppOntology
Support ontology for the implementation of ontologies for the Phaleron Bioarchaeological Project into AnthroGraph.

## Compiled Versions of Required Ontologies

### Description

We provide a bash script that merges the ontologies required by the [PBP App](https://github.com/AnthroGraph/PBP-App) and provides them in one OWL file. In addition to the Phaleron AppOntology, these are

* all [RDFBones ontology extensions for the Phaleron Bioarchaeological Project](https://github.com/RDFBones/RDFBonesPhaleron)
* all dependencies of these extensions

The app itself only works within an information system that has the RDFBones core ontology installed, for example via the [RDFBones App](https://github.com/AnthroGraph/RDFBones-App).

The script offers the following compilations:

* **Minimum Compilation**: Contains the Phaleron App Ontology and all RDFBones ontology extensions written for the Phaleron Bioarchaeological Project. Use this for information systems that already run the required dependencies (i.e. ontology extensions reused by the Phaleron extensions).
* **Standard Compilation**: Contains the Phaleron App Ontology and all RDFBones ontology extensions written for the Phaleron Bioarchaeological Project together with their dependencies. Use this to rund just the PBP App on an AnthroGraph information system.
* **Full Compilation**: Contains the Phaleron App Ontology, all RDFBones ontology extensions written for the Phaleron Bioarchaeological Project together with their dependencies and the RDFBones core ontology. Use this if you want to inspect the data structures modelled by the PBP App (e.g. by loading the OWL file into an editor like Protégé). This option is not for deployment with information systems.

### Usage

Checkout the [robot branch](https://github.com/AnthroGraph/Phaleron-AppOntology/tree/robot).

```
git checkout robot
```

Run the script '[Script_PhaleronApp-Robot.sh'](https://github.com/AnthroGraph/Phaleron-AppOntology/blob/robot/Script_PhaleronApp-Robot.sh).

```
./Script_PhaleronApp-Robot.sh
```

A new directory, 'results' is created. Go there for the output files.

If you run the script without options, this will render the standard compilation with the Phaleron App Ontology, the Phaleron ontology extensions and their dependencies. The output file is called 'phaleron-app_ext_dep.owl'.

If you run the script with the -b flag, this will render the minimum compilation with the Phaleron App Ontology and the Phaleron extensions. The output file is called 'phaleron-app_ext.owl'.

```
./Script_PhaleronApp-robot.sh -b
```

If you run the script with the -f flag, this will render the full compilation with the Phaleron App Ontology, the Phaleron extensions, their dependencies and the RDFBones core ontology. The output file is called 'phaleron-app_ext_dep_core.owl'.

```
./Script_PhaleronApp-robot.sh -f
```

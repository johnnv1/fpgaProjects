# Projects in FPGA
Projects developed throughout the discipline of IC projects

Inside the *python_projects* folder there are the codes made in python where it is made to simulate the state machines and the hw function/sequence to be decelerated later in VHDL, verilog, etc.

The other folders in the repository contain the projects developed in Vivado 2019.1.1 in VHDL, verilog, etc. Used in all these projects a Nexys 4 DDR or Zybo from digilent.


To ensure that all this repository and its submodules are cloned, run:

```bash
git clone --recurse-submodules -j8 https://github.com/johnnv1/fpgaProjects.git
```

## Creating a project in the repository pattern

```Bash.
python .\python_projects\create_project.py -n test -v 10 #example of creating a project
python .\python_projects\create_project.py --help # to see the algorithm options
```

## How to export/import the project
In the live console enter the folder where you want to export/save the project and execute the command:

```bash
write_project_tcl nameFile.tcl
```


--------

To create a project from the **tcl** file open the live and go to a live tcl console and run the command

```Bash.
source nameArchive.tcl
```


## Original repository

Maintained by the professor: *https://bitbucket.org/Joao-Fragoso/vivado-projects/src/master/*
# Abaverify_Example

This is an example folder to show simple useage of abaverify with your own code and not the rather extensive CompDam_DGD VUMAT by Nasa

Abaverify can be found by googling "Abaverify NASA", install from github.

Prerequesites:
- python 2.7 activated on the system, google this for how to make it work. Conda is a good suggestion.
- github is fairly handy for dealing with installation of abaverify and also ComDam_DGD.
- run setup.py from the abaverify folder.
- Your Vumat should be defined in the free format, not the fixed format which is default for Abaqus. In the abaqus_v6.env file the '/free' command specifies this. free and fixed is not backwards compatible.
- To make VUMAT/UMAT on free format work, the abaqus_v6.env file needs to be in the "current working directory" if you use the CAE or in the folder where the .inp file if using cmd to run jobs.
- usub_lib_dir = os.path.join(os.getcwd(), '../for') in the abaqus_v6.env has to be specified to where the UMAT/VUMAT is located. "../" means one folder up.

Optional prerequisites/Troubleshooting:
- Microsoft Visual Studio 2013 Update 5 (https://my.visualstudio.com) 
- Visual Fortran Composer XE 2013 SP1 Update 3 (P:\Campus\Intel\Visual Fortran Composer 2013 SP1)
- Abaqus 2017 (Software Center)
- Setup: file:///C:/Users/eivinhug/Downloads/LinkingAbaqus2017andIntelParallelStudioXE2016VisualFortraninWindows10x64.pdf
- If something is not working, set Abaqus CAE and Abaqus CMD shortcuts to run as adminstrator by default. right click -> open file location -> right click again -> properties -> advanced.
- The abaqus verify -all may not work in CMD even though UMAT/VUMAT actually works, for the example that was the case. This bug has also been discovered over at a KT PhD Candidate's computer with the same VS/Fortran/Abq.

What is in this example:
The exapmle UMAT file is a simple Max stress with degradation of the E modulus after failure by a factor sat in the UMAT itself (this factor could have been defined as a UMAT parameter in the material model, but its not.
There are a few mock tests, two that tests the max stress at a displacement of 0.1 in one direction each and one parametric test that checks E modulus pre failure for a few different displacements and mesh sizes.
 
to run the example use theese three following commands in the abaqus cmd (not the normal cmd):

- cd location/of/folder/named/tests
- activate py27
- python test_runner.py

If you want to make your own input file, here are some tips:

- Make the .inp part and assembly independent, that allows for seamless use of sets, which is used to identify what and where the results shall be extracted.
- you can parametrize the .inp, but then it wont open in CAE, the example file is parametrized for the parametric mesh size test.
- Abaverify operates on history output only, so therefore any field output has to be defined as history output. See .inp example file.






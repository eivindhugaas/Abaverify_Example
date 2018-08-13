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
- Visual Fortran Composer XE 2013 SP1 Update 3 (on NTNU progdist: P:\Campus\Intel\Visual Fortran Composer 2013 SP1)
- Abaqus 2017 (on NTNU Software Center)
- Setup: https://www.researchgate.net/publication/313924098_Linking_ABAQUS_2017_and_Intel_Parallel_Studio_XE2016_Visual_Fortran_in_Windows_10_x64
- If something is not working, set Abaqus CAE and Abaqus CMD shortcuts to run as adminstrator by default. right click -> open file location -> right click again -> properties -> advanced.
- The abaqus verify -all may not work in CMD even though UMAT/VUMAT actually works, for the example that was the case. This bug has also been discovered over at a KT PhD Candidate's computer with the same VS/Fortran/Abq, so it's this bug is assumed legit for now.

What is in this example:
The exapmle UMAT file is a simple Max stress with degradation of the E modulus after failure by a factor sat in the UMAT itself (this factor could have been defined as a UMAT parameter in the material model, but its not. UMAT beginner challenge: make it a material parameter!).
There are a few mock tests, two that tests the max stress at a displacement of 0.1 in one direction each and one parametric test that checks E modulus pre-failure for a few different displacements and mesh sizes.

Note that the material used is physically impossible as it has 0.3 in poissons ratio in all directions despite being glass fiber. How strange you might think, so did the author upon discovering this.

There is also included one test runner for the UMAT CompDam_DGD run with the NASA .props file format on material properties. This file is fairly similar to the test files in the test folder of the CompDam_DGD package. Note that the material is transversly isotropic in the .props file.

For opening the testmodel (simple 1*1*1 cube loaded in x or y) a non parameterized model is also provided, for convenience and visualization.
 
to run the example use theese three following commands in the abaqus cmd (not the normal cmd):

- cd location/of/folder/named/tests
- activate py27
- python test_runner.py

If you want to make your own input file, here are some tips:

- Make the .inp part and assembly independent, that allows for seamless use of sets, which is used to identify what and where the results shall be extracted.
- you can parametrize the .inp, but then it wont open in CAE, the example file is parametrized for the parametric mesh size test.
- Abaverify operates on history output only, so therefore any field output has to be defined as history output. See .inp example file.
- it must be named "test_nameoffile.inp" and the python testcode also has to be named "test_nameoffile.py", see code troubleshooting below for what happens if you don't do this.

Code Troubleshooting:
- "ModuleNotFoundError: No module named 'main'" in cmd. Solution: py27 not activated. run "activate py27".
- "TypeError: runTest() takes exactly 2 arguments (1 given)" in cmd. Solution: name the .py and .inp "test_....."
- "Error: Abaqus odb was not generated. Check the log file in the testOutput directory." in cmd.
- If extensive troubleshooting is needed, use the classic print approach in python, this also works if the UMAT/VUMAT is faulty, though in UMAT/VUMAT the print statement is Write(*,*) followed by what you want to print.

Short description of how the NASA VUMAT works:

The VUMAT is based on continuum damage mechanics. This sounds fancy, but it means that no cracks in the material are modelled in a small cube of material if the failure criteria is breached. Instead the stiffness matrix is altered for the cube to account for the crack. This is why it's called "continuum", the material is treated as one piece regardless of damage and as such is nothing unexpected. The neat part of the Nasa VUMAT is how matrix cracks are modelled when they are subjected to shear. The problem occurs when a cube of material with a crack is subjected to pure shear, then the relative orientation of the crack is wrongly adjusted if this is not taken care of. NASA decomposes the deformation gradient into one that sorts out the deformation of the undamaged material and one that takes care of deforming the damaged material. The following article describes it fairly well: 

https://ac.els-cdn.com/S1359835X15002134/1-s2.0-S1359835X15002134-main.pdf?_tid=07862296-33cb-4f17-a2d2-13631026dc0e&acdnat=1520502306_d9034275b8e0b391949ef7f1e4888a53

however, some familiarity with continuum mechanics is convenient for the reader, the following link is usefull for continuum mechanics beginners:

http://www.continuummechanics.org/deformationgradient.html

Feel free to add changes to the readme and add troubleshooting as you go along.



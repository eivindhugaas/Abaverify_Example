# Abaverify_Example

This is an example folder to show simple useage of abaverify with your own code and not the rather extensive CompDam_DGD VUMAT by Nasa

Abaverify can be found by googling "Abaverify NASA", install from github.

Prerequesites:
- python 2.7 activated on the system, google this for how to make it work. For the example Conda was used to handle the versions.
- github is fairly handy for dealing with installation of abaverify and also ComDam_DGD.
- run setup.py from the abaverify folder.
- Your Vumat should be defined in the free format, not the fixed format which is default for Abaqus. In the abaqus_v6.env file the '/free' command specifies this. free and fixed is not backwards compatible.
- To make VUMAT/UMAT on free format work, the abaqus_v6.env file needs to be in the "current working directory".
- usub_lib_dir = os.path.join(os.getcwd(), '../for') in the abaqus_v6.env has to be specified to where the UMAT/VUMAT is located. "../" means one folder up.

What is in this example:
The exapmle UMAT file is a simple Max stress with degradation of the E modulus after failure by a factor sat in the UMAT itself (this factor could have been defined as a UMAT parameter in the material model, but its not.
There are a few mock tests, two that tests the max stress in one direction each and one parametric test that checks E modulus pre failure for a few different displacements and mesh sizes.
 
to run the example use theese three following commands in the abaqus cmd (not the normal cmd):

cd location/of/folder/named/tests
activate py27
python test_runner.py

If you want to make your own input file, then here are some tips:

- Make the .inp part and assembly independent, that allows for seamless use of sets, which is used to identify what and where the results shall be extracted.

- you can parametrize the .inp, but then it wont open in CAE.

- Abaverify operates on history output only, so therefore any field output has to be defined as history output. See .inp example file.





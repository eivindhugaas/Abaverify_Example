#
# Unittest code to run tests on single element models with DGD
#
"""
This script runs the model with a .props file and the UMAT wrapper for the CompDam_DGD VUMAT.

Note how CopyMatProps is included in the Class.
"""

import os
import shutil
import abaverify as av
def copyMatProps():

    # If testOutput doesn't exist, create 
    testOutputPath = os.path.join(os.getcwd(), 'testOutput')
    if not os.path.isdir(testOutputPath):
        os.makedirs(testOutputPath)

    # Put a copy of the properties file in the testOutput directory
    #propsFiles = [x for x in os.listdir(os.getcwd()) if x.endswith('.props')]
    #for propsFile in propsFiles:
        #shutil.copyfile(os.path.join(os.getcwd(), propsFile), os.path.join(os.getcwd(),'testOutput', propsFile))





#class SingleC3D8RElementTests(av.TestCase): #Name of class irrelevant
    #def test_MaxStress_FiberDir(self):      #Name of def irrelevant
        #self.runTest('test_C3D8R_MaxStress_FiberDir')  #Name of test relevant!
    #def test_MaxStress_MatrixDir(self):
        #self.runTest('test_C3D8R_MaxStress_MatrixDir')    

class ParametricTests(av.TestCase):
    """
    Parametric IncrementSizeTest.
    """
    # Class-wide methods
    @classmethod
    def setUpClass(cls):
        copyMatProps()
    # Specify meta class
    __metaclass__ = av.ParametricMetaClass

    # Refers to the template input file name
    baseName = "test_C3D8R_IncrementSizeNASA" 

    # Range of parameters to test; all combinations are tested, but here
    parameters = {'IncrementSize': [0.01,0.02],'U1':[0.05,0.1]}

if __name__ == "__main__":
    
    #av.runTests(relPathToUserSub='../for/vumatWrapper')
    av.runTests(relPathToUserSub='../for')#, double=True)
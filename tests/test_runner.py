#
# Unittest code to run tests on single element models with DGD
#

import os
import shutil
import abaverify as av


class SingleC3D8RElementTests(av.TestCase): #Name of class irrelevant
    def test_MaxStress_FiberDir(self):      #Name of def irrelevant
        self.runTest('test_C3D8R_MaxStress_FiberDir')  #Name of test relevant!
    def test_MaxStress_MatrixDir(self):
        self.runTest('test_C3D8R_MaxStress_MatrixDir')    

class ParametricTests(av.TestCase):
    """
    Parametric IncrementSizeTest.
    """

    # Specify meta class
    __metaclass__ = av.ParametricMetaClass

    # Refers to the template input file name
    baseName = "test_C3D8R_IncrementSize" 

    # Range of parameters to test; all combinations are tested, but here
    parameters = {'IncrementSize': [0.01,0.02],'U1':[0.05,0.1]}

if __name__ == "__main__":
    av.runTests(relPathToUserSub='../for/UMAT_1_3_MaxStress')

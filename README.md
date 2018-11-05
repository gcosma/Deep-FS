# Deep-FS
Deep-Feature Selection
------------------------------------------------------------------------------
READ ME - Instructions on how to run the code.  
------------------------------------------------------------------------------

Download MNIST dataset to the same folder that the MATLAB code are as follows.

Step 1: Download from http://yann.lecun.com/exdb/mnist the following 4 files:

o	train-images-idx3-ubyte.gz
o	train-labels-idx1-ubyte.gz
o	t10k-images-idx3-ubyte.gz
o	t10k-labels-idx1-ubyte.gz
Step 2: Unzip these 4 files by executing:
o	gunzip train-images-idx3-ubyte.gz
o	gunzip train-labels-idx1-ubyte.gz
o	gunzip t10k-images-idx3-ubyte.gz
o	gunzip t10k-labels-idx1-ubyte.gz

If unzipping with WinZip, make sure the file names have not been changed by WinZip.

Step 3: Run DeepFS2.m

Step 4: The program will return two options. 

Enter 1 to run DeepFS to select features, or 
Enter 2  to first select features using DeepFS and then train a Deep Boltzmann machine (DBM) on the selected data. 

The principle of DeepFS is described in [1]. The DBM in [2] is used in this code. 

[1] A. Taherkhani, G. Cosma, and T. M. McGinnity, “Deep-FS: A feature selection algorithm for Deep Boltzmann Machines,” Neurocomputing, vol. 0, pp. 1–16, 2018.

[2] Learning Deep Boltzmann Machines, http://www.cs.toronto.edu/~rsalakhu/DBM.html


Please e-mail me if us find bugs.  
Dr Aboozar Taherkhani: 
aboozar.taherkhani@ntu.ac.uk

Dr Georgina Cosma
georgina.cosma@ntu.ac.uk

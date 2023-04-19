from sklearn.metrics import mutual_info_score
import numpy as np

A = np.genfromtxt('comorbidity_matrix.csv', delimiter=',')

# Define the number of bins to discretize the matrix A
num_bins = 10

# Discretize the matrix A
A_discrete = np.digitize(A, np.arange(0, 1.01, 1/num_bins))

# Calculate the mutual information of the discretized matrix using the mutual_info_score function
mutual_info = mutual_info_score(A_discrete.flatten(), A_discrete.T.flatten())

print("Mutual information of the discretized comorbidity matrix A", mutual_info)

import pandas as pd
import numpy as np

# Set random seed for reproducibility
np.random.seed(42)

# Number of samples
n_samples = 10000

# Define feature constraints (from your code)
feature_constraints = {
    'Hours_Studied': {'type': 'numerical', 'min': 0, 'max': 50},
    'Attendance': {'type': 'numerical', 'min': 0, 'max': 100},
    'Access_to_Resources': {'type': 'categorical', 'values': ['Low', 'Medium', 'High']},
    'Extracurricular_Activities': {'type': 'categorical', 'values': ['Yes', 'No']},
    'Sleep_Hours': {'type': 'numerical', 'min': 0, 'max': 24},
    'Previous_Scores': {'type': 'numerical', 'min': 0, 'max': 100},
    'Internet_Access': {'type': 'categorical', 'values': ['Yes', 'No']},
    'Teacher_Quality': {'type': 'categorical', 'values': ['Low', 'Medium', 'High']},
    'School_Type': {'type': 'categorical', 'values': ['Public', 'Private']},
    'Peer_Influence': {'type': 'categorical', 'values': ['Positive', 'Negative', 'Neutral']},
    'Learning_Disabilities': {'type': 'categorical', 'values': ['Yes', 'No']},
    'Gender': {'type': 'categorical', 'values': ['Male', 'Female']}
}

# Generate synthetic data
data = {}
# Numerical features
data['Hours_Studied'] = np.random.uniform(0, 50, n_samples)  # Uniform distribution
data['Attendance'] = np.random.normal(85, 10, n_samples).clip(0, 100)  # Normal, mean=85
data['Sleep_Hours'] = np.random.normal(7, 2, n_samples).clip(0, 24)  # Normal, mean=7
data['Previous_Scores'] = np.random.normal(75, 15, n_samples).clip(0, 100)  # Normal, mean=75

# Categorical features with realistic probabilities
data['Access_to_Resources'] = np.random.choice(['Low', 'Medium', 'High'], n_samples, p=[0.3, 0.5, 0.2])
data['Extracurricular_Activities'] = np.random.choice(['Yes', 'No'], n_samples, p=[0.4, 0.6])
data['Internet_Access'] = np.random.choice(['Yes', 'No'], n_samples, p=[0.7, 0.3])
data['Teacher_Quality'] = np.random.choice(['Low', 'Medium', 'High'], n_samples, p=[0.2, 0.6, 0.2])
data['School_Type'] = np.random.choice(['Public', 'Private'], n_samples, p=[0.6, 0.4])
data['Peer_Influence'] = np.random.choice(['Positive', 'Negative', 'Neutral'], n_samples, p=[0.4, 0.2, 0.4])
data['Learning_Disabilities'] = np.random.choice(['Yes', 'No'], n_samples, p=[0.1, 0.9])
data['Gender'] = np.random.choice(['Male', 'Female'], n_samples, p=[0.5, 0.5])

# Create DataFrame
df = pd.DataFrame(data)

# Generate Exam_Score with a formula
exam_score = (
    0.4 * (df['Hours_Studied'] / 50) * 100 +
    0.3 * (df['Attendance'] / 100) * 100 +
    0.2 * (df['Previous_Scores'] / 100) * 100 +
    0.1 * (df['Sleep_Hours'] / 24) * 100 +
    df['Access_to_Resources'].map({'Low': -5, 'Medium': 0, 'High': 10}) +
    df['Teacher_Quality'].map({'Low': -3, 'Medium': 0, 'High': 5}) +
    df['Internet_Access'].map({'Yes': 5, 'No': -3}) +
    df['Extracurricular_Activities'].map({'Yes': 3, 'No': -2}) +
    df['School_Type'].map({'Private': 5, 'Public': -3}) +
    df['Peer_Influence'].map({'Positive': 5, 'Negative': -3, 'Neutral': 0}) +
    df['Learning_Disabilities'].map({'Yes': -5, 'No': 0}) +
    df['Gender'].map({'Male': 0, 'Female': 0}) +
    60 +  # Higher base score
    np.random.normal(0, 3, n_samples)  # Less noise
).clip(0, 100)

df['Exam_Score'] = exam_score

# Save to CSV
df.to_csv('StudentPerformanceFactors_synthetic.csv', index=False)
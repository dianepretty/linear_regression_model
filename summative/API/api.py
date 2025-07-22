from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, validator
import pandas as pd
import joblib

app = FastAPI()

# Enable CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Feature constraints
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

# Pydantic model for input validation
class StudentInput(BaseModel):
    Hours_Studied: float
    Attendance: float
    Access_to_Resources: str
    Extracurricular_Activities: str
    Sleep_Hours: float
    Previous_Scores: float
    Internet_Access: str
    Teacher_Quality: str
    School_Type: str
    Peer_Influence: str
    Learning_Disabilities: str
    Gender: str

    @validator('Hours_Studied')
    def validate_hours_studied(cls, v):
        if not (0 <= v <= 50):
            raise ValueError('Hours_Studied must be between 0 and 50')
        return v

    @validator('Attendance')
    def validate_attendance(cls, v):
        if not (0 <= v <= 100):
            raise ValueError('Attendance must be between 0 and 100')
        return v

    @validator('Sleep_Hours')
    def validate_sleep_hours(cls, v):
        if not (0 <= v <= 24):
            raise ValueError('Sleep_Hours must be between 0 and 24')
        return v

    @validator('Previous_Scores')
    def validate_previous_scores(cls, v):
        if not (0 <= v <= 100):
            raise ValueError('Previous_Scores must be between 0 and 100')
        return v

    @validator('Access_to_Resources')
    def validate_access_to_resources(cls, v):
        if v not in ['Low', 'Medium', 'High']:
            raise ValueError('Access_to_Resources must be Low, Medium, or High')
        return v

    @validator('Extracurricular_Activities')
    def validate_extracurricular_activities(cls, v):
        if v not in ['Yes', 'No']:
            raise ValueError('Extracurricular_Activities must be Yes or No')
        return v

    @validator('Internet_Access')
    def validate_internet_access(cls, v):
        if v not in ['Yes', 'No']:
            raise ValueError('Internet_Access must be Yes or No')
        return v

    @validator('Teacher_Quality')
    def validate_teacher_quality(cls, v):
        if v not in ['Low', 'Medium', 'High']:
            raise ValueError('Teacher_Quality must be Low, Medium, or High')
        return v

    @validator('School_Type')
    def validate_school_type(cls, v):
        if v not in ['Public', 'Private']:
            raise ValueError('School_Type must be Public or Private')
        return v

    @validator('Peer_Influence')
    def validate_peer_influence(cls, v):
        if v not in ['Positive', 'Negative', 'Neutral']:
            raise ValueError('Peer_Influence must be Positive, Negative, or Neutral')
        return v

    @validator('Learning_Disabilities')
    def validate_learning_disabilities(cls, v):
        if v not in ['Yes', 'No']:
            raise ValueError('Learning_Disabilities must be Yes or No')
        return v

    @validator('Gender')
    def validate_gender(cls, v):
        if v not in ['Male', 'Female']:
            raise ValueError('Gender must be Male or Female')
        return v

@app.get("/")
async def root():
    return {"message": "Student Performance Prediction API"}

@app.post("/predict")
async def predict_exam_score(input: StudentInput):
    try:
        # Convert input to DataFrame
        input_dict = input.dict()
        user_data = pd.DataFrame([input_dict])

        # Load the best model
        best_model = joblib.load('../linear_regression/best_model.pkl')

        # Predict
        prediction = best_model.predict(user_data)[0]

        return {"predicted_exam_score": round(prediction, 2)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
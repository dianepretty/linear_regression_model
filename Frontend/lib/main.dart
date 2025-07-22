import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

void main() {
  runApp(const StudentPredictionApp());
}

class StudentPredictionApp extends StatelessWidget {
  const StudentPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Performance Predictor',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PredictionForm(),
    );
  }
}

class PredictionForm extends StatefulWidget {
  const PredictionForm({super.key});

  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _hoursStudiedController = TextEditingController();
  final _attendanceController = TextEditingController();
  final _sleepHoursController = TextEditingController();
  final _previousScoresController = TextEditingController();
  String? _accessToResources;
  String? _extracurricularActivities;
  String? _internetAccess;
  String? _teacherQuality;
  String? _schoolType;
  String? _peerInfluence;
  String? _learningDisabilities;
  String? _gender;
  String _predictionResult = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Dropdown options based on feature constraints
  final Map<String, List<String>> _dropdownOptions = {
    'Access_to_Resources': ['Low', 'Medium', 'High'],
    'Extracurricular_Activities': ['Yes', 'No'],
    'Internet_Access': ['Yes', 'No'],
    'Teacher_Quality': ['Low', 'Medium', 'High'],
    'School_Type': ['Public', 'Private'],
    'Peer_Influence': ['Positive', 'Negative', 'Neutral'],
    'Learning_Disabilities': ['Yes', 'No'],
    'Gender': ['Male', 'Female'],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _predictionResult = '';
      });

      final input = {
        'Hours_Studied': double.parse(_hoursStudiedController.text),
        'Attendance': double.parse(_attendanceController.text),
        'Access_to_Resources': _accessToResources,
        'Extracurricular_Activities': _extracurricularActivities,
        'Sleep_Hours': double.parse(_sleepHoursController.text),
        'Previous_Scores': double.parse(_previousScoresController.text),
        'Internet_Access': _internetAccess,
        'Teacher_Quality': _teacherQuality,
        'School_Type': _schoolType,
        'Peer_Influence': _peerInfluence,
        'Learning_Disabilities': _learningDisabilities,
        'Gender': _gender,
      };

      final apiService = ApiService();
      final result = await apiService.predictExamScore(input);

      setState(() {
        _isLoading = false;
        if (result['success']) {
          _predictionResult = 'Predicted Exam Score: ${result['predicted_exam_score'].toStringAsFixed(2)}';
          _animationController.forward(from: 0.0);
        } else {
          _predictionResult = 'Error: ${result['error']}';
          _animationController.forward(from: 0.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade300, Colors.teal.shade100],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Predict Your Exam Score',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputCard([
                      _buildTextField(_hoursStudiedController, 'Hours Studied (0-50)', 'Must be between 0 and 50', 0, 50),
                      _buildTextField(_attendanceController, 'Attendance (0-100)', 'Must be between 0 and 100', 0, 100),
                      _buildTextField(_sleepHoursController, 'Sleep Hours (0-24)', 'Must be between 0 and 24', 0, 24),
                      _buildTextField(_previousScoresController, 'Previous Scores (0-100)', 'Must be between 0 and 100', 0, 100),
                    ]),
                    const SizedBox(height: 20),
                    _buildInputCard([
                      _buildDropdown('Access to Resources', _accessToResources, _dropdownOptions['Access_to_Resources']!, (value) => _accessToResources = value),
                      _buildDropdown('Extracurricular Activities', _extracurricularActivities, _dropdownOptions['Extracurricular_Activities']!, (value) => _extracurricularActivities = value),
                      _buildDropdown('Internet Access', _internetAccess, _dropdownOptions['Internet_Access']!, (value) => _internetAccess = value),
                      _buildDropdown('Teacher Quality', _teacherQuality, _dropdownOptions['Teacher_Quality']!, (value) => _teacherQuality = value),
                      _buildDropdown('School Type', _schoolType, _dropdownOptions['School_Type']!, (value) => _schoolType = value),
                      _buildDropdown('Peer Influence', _peerInfluence, _dropdownOptions['Peer_Influence']!, (value) => _peerInfluence = value),
                      _buildDropdown('Learning Disabilities', _learningDisabilities, _dropdownOptions['Learning_Disabilities']!, (value) => _learningDisabilities = value),
                      _buildDropdown('Gender', _gender, _dropdownOptions['Gender']!, (value) => _gender = value),
                    ]),
                    const SizedBox(height: 20),
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            backgroundColor: Colors.teal.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'Predict Score',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _predictionResult.startsWith('Error') ? Colors.red.shade100 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _predictionResult.isEmpty ? 'Enter details to see your prediction' : _predictionResult,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _predictionResult.startsWith('Error') ? Colors.red.shade900 : Colors.green.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(List<Widget> children) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String errorMessage, double min, double max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.teal.shade700),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          final num = double.tryParse(value);
          if (num == null || num < min || num > max) return errorMessage;
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.teal.shade700),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
        value: value,
        items: items.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: (value) => setState(() => onChanged(value)),
        validator: (value) => value == null ? 'Please select an option' : null,
      ),
    );
  }

  @override
  void dispose() {
    _hoursStudiedController.dispose();
    _attendanceController.dispose();
    _sleepHoursController.dispose();
    _previousScoresController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
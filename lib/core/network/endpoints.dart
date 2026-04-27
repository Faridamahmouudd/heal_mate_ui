class Endpoints {
  static const login = "/api/auth/login";
  static const register = "/api/auth/register";
  static const me = "/api/auth/me";

  static const doctorPatients = "/api/doctor/patients";
  static const doctorSearchPatients = "/api/doctor/patients/search";

  static const nurses = "/api/nurses";

  static const chatHistory = "/api/chat/history";
  static const chatSend = "/api/chat/send";
  static const chatUser = "/api/chat";

  static const aiPredict = "/api/doctor/ai/predict";

  static const robotCommand = "/api/robot/command";
  static const robotStatus = "/api/robot/status";
  static const robotLogs = "/api/robot/logs";

  static const patientVitals = "/api/patient";
}
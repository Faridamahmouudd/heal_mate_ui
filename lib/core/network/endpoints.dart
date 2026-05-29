class Endpoints {
  // ================= AUTH =================
  static const login = "/api/Auth/login";
  static const register = "/api/Auth/register";
  static const me = "/api/Auth/me";
  static const logout = "/api/Auth/logout";

  // ================= DOCTOR =================
  static const doctorPatients = "/api/doctor/patients";
  static const doctorSearchPatients = "/api/doctor/patients/search";

  // ================= NURSES =================
  static const nurses = "/api/nurses";

// ================= CHAT =================
  static const chatHistory = "/api/chat/history";
  static const chatSend = "/api/chat/send";
  static const chatUser = "/api/chat";
  static const chatMarkAsRead = "/api/chat/mark-as-read";
  // ================= AI =================
  static const aiPredict = "/api/doctor/ai/predict";

  // ================= ROBOT =================
  static const robotCommand = "/api/robot/command";
  static const robotStatus = "/api/robot/status";
  static const robotLogs = "/api/robot/logs";

  // ================= PATIENT =================
  static const patientVitals = "/api/patient";
}
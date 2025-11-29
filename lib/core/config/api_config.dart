class ApiConfig {
  static const String baseUrl =
      'https://lightgray-dolphin-920276.hostingersite.com/api';

  // Şagird endpointləri
  static const String studentsList = '/sagirdler/list.php';
  static const String studentsCreate = '/sagirdler/create.php';
  static const String studentsUpdate = '/sagirdler/update.php';
  static const String studentsDelete = '/sagirdler/delete.php';

  // Dərslər
  static const String lessonsList = '/dersler/list.php';
  static const String lessonsCreate = '/dersler/create.php';
  static const String lessonsUpdate = '/dersler/update.php';
  static const String lessonsDelete = '/dersler/delete.php';

  // İmtahanlar
  static const String examsList = '/imtahanlar/list.php';
  static const String examsCreate = '/imtahanlar/create.php';
  static const String examsByStudent = '/imtahanlar/by_student.php';
  static const String examsByLesson = '/imtahanlar/by_lesson.php';
  static const String examsUpdate = '/imtahanlar/update.php';
  static const String examsDelete = '/imtahanlar/delete.php';
}

class PraktikanStudent {
  String fullName;
  int age;

  PraktikanStudent(this.fullName, this.age);

  int incrementAge() {
    // TODO 1

    return ++age; //

    // End of TODO 1
  }

  Future<String> getStudentInfo() {
    // TODO 2

    PraktikanStudent student = createStudent();

    return Future.delayed(Duration(seconds: 3), () {
      return "Nama Lengkap: ${student.fullName}, Umur: ${student.age} tahun";
    });

    // End of TODO 2
  }
}

dynamic createStudent() {
  // TODO 3

  return PraktikanStudent("Belia Eka Sukma Mentari", 19);

  // End of TODO 3
}

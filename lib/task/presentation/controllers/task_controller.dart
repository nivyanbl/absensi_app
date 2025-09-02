import 'package:employment_attendance/task/domain/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var pickedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();

    fetchTasks();
  }

  void fetchTasks() {
    var dummyTask = [
      Task(
          id: '1',
          title: 'Prepare monthly report',
          description:
              'A brief summary of the company/divsions performance for 1 month',
          date: 'Wednesday 30 July 2025',
          status: 'Pending',
          image: "assets/image/task.png"),
      Task(
          id: '2',
          title: 'Prepare monthly report',
          description:
              'A brief summary of the company/divsions performance for 1 month',
          date: 'Wednesday 30 July 2025',
          status: 'Pending',
          image: "assets/image/task.png"),
      Task(
          id: '3',
          title: 'Meeting with client',
          description: 'Continue discussing the website project',
          date: 'Monday 4 August 2025',
          status: 'Complate',
          image: "assets/image/task.png"),
      Task(
          id: '4',
          title: 'Meeting with client',
          description: 'Continue discussing the website project',
          date: 'Monday 4 August 2025',
          status: 'Complate',
          image: "assets/image/task.png"),
      Task(
        id: '5',
        title: 'Meeting with client',
        description: 'Continue discussing the website project',
        date: 'Monday 4 August 2025',
        status: 'Complate',
        image: "assets/image/task.png",
      ),
    ];
    tasks.assignAll(dummyTask);
  }

  //untuk mengubah status
  void updateTaskStatus(String id) {
    int index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].status =
          tasks[index].status == 'Pending' ? 'Complate' : 'Pending';
          tasks.refresh();
          Get.snackbar('Succses', 'Task status has been update',
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  }


  

  void addTask({
    required String title,
    required String description,
    required String date,
    required String status,
    File? imageFile,
  }) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      date: date,
      status: status,
      image: imageFile?.path ?? 'assets/image/task.png',
    );

    tasks.insert(0, newTask);
    pickedImage.value = null;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File(image.path);
    } else {
      Get.snackbar('Image Selection', 'No image selected.');
    }
  }

  void clearPickedImage() {
    pickedImage.value = null;
  }
}

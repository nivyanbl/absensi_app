import 'package:employment_attendance/task/data/repositories/task_repository.dart';
import 'package:employment_attendance/task/domain/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TaskController extends GetxController {
  final TaskRepository _taskRepository = TaskRepository();

  var tasks = <Task>[].obs;
  var pickedImage = Rx<File?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      isLoading.value = true;
      var fetchedTasks = await _taskRepository.getTasks();
      tasks.assignAll(fetchedTasks);
    } finally {
      isLoading.value = false;
    }
  }

  // buat ubah status
  void updateTaskStatus(String id) {
    int index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].status =
          tasks[index].status == 'Pending' ? 'Completed' : 'Pending';
      tasks.refresh();
      Get.snackbar('Success', 'Task status has been updated',
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  void addTask({
    required String title,
    required String description,
    required String date,
    required String status,
    File? imageFile,
  }) async {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      date: date,
      status: status,
      image: imageFile?.path ?? 'assets/image/task.png',
    );
    await _taskRepository.addTask(newTask);
    fetchTasks();
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

import 'package:employment_attendance/task/presentation/controllers/task_controller.dart';
import 'package:employment_attendance/task/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    final status = 'Pending'.obs;
    final TaskController taskController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {          
                taskController.addTask(
                  title: titleController.text,
                  description: descriptionController.text,
                  date: dateController.text,
                  status: status.value,
                  imageFile: taskController.pickedImage.value,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6EA07A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //title
              CustomTextField(
                label: 'Task Tittle',
                controller: titleController,
                hintText: 'Enter task name',
              ),
              const SizedBox(height: 24),
              //description
              CustomTextField(
                label: 'Description',
                controller: descriptionController,
                hintText: 'Enter your detail task',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              //date
              CustomTextField(
                label: 'Date',
                controller: dateController,
                hintText: 'Select Date',
                readOnly: true,
                prefixIcon:const Icon(Icons.calendar_month),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF6EA07A),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF6EA07A),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('EEEE, d MMMM yyyy').format(pickedDate);
                    dateController.text = formattedDate;
                  }
                },
              ),           
              const SizedBox(height: 24),
              //status
              const Text('Status',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      color: Colors.white,
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.pending_actions),
                            title: const Text('Pending'),
                            onTap: () {
                              status.value = 'Pending';
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: const Text('Completed'),
                            onTap: () {
                              status.value = 'Completed';
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(status.value,
                              style: const TextStyle(fontSize: 16)),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    )),
              ),
              const SizedBox(height: 24),
              // form upload
              Obx(() {
                final pickedFile = taskController.pickedImage.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.grey[200]!, style: BorderStyle.solid),
                  ),
                  child: pickedFile == null
                      ? Column(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                child: Icon(Icons.cloud_upload_outlined,
                                    size: 30, color: Colors.grey[600])),
                            const SizedBox(height: 16),
                            const Text('Select foto to Upload',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Supported Fomat: PNG, JPG, SVG',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => taskController.pickImage(),
                              icon: const Icon(
                                Icons.ios_share,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Select File',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6EA07A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(pickedFile,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => taskController.pickImage(),
                              icon: const Icon(
                                Icons.ios_share,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Change Image',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:const  Color(0xFF6EA07A),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            )
                          ],
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

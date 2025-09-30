import 'package:employment_attendance/task/domain/models/task_model.dart';

class TaskRepository {

    final List <Task> _dummyTasks = [
      Task(
        id: "1",
        title: 'Prepare monthly report',
        description:
            'A brief summary of the company/divisions preformance for 1 month',
        date: 'Wednesday 30 July 2025',
        status: "Pending",
        image: "assets/image/task.png",
      ),
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
    ];
    Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(microseconds: 500));
    return _dummyTasks;
    }

    Future <void> addTask(Task newTask) async {
      _dummyTasks.insert(0, newTask);
      print("Tugas baru ditambahkan di repository");
    }

  }


import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:employment_attendance/core/widgets/custom_text_field.dart';
import 'package:employment_attendance/features/task/domain/models/task_entry_model.dart';
import 'package:employment_attendance/features/task/domain/models/attachment_model.dart';
import 'package:employment_attendance/features/task/presentation/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TaskController controller = Get.find<TaskController>();

  final _summaryController = TextEditingController();

  final List<Map<String, TextEditingController>> _taskControllers = [];
  final List<List<Attachment>> _taskAttachments = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addTaskForm();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    for (var controllers in _taskControllers) {
      controllers['title']?.dispose();
      controllers['description']?.dispose();
    }
    super.dispose();
  }

  void _addTaskForm() {
    setState(() {
      _taskControllers.add({
        'title': TextEditingController(),
        'description': TextEditingController(),
      });
      _taskAttachments.add([]);
    });
  }

  void _removeTaskForm(int index) {
    _taskControllers[index]['title']?.dispose();
    _taskControllers[index]['description']?.dispose();
    setState(() {
      _taskControllers.removeAt(index);
      if (index < _taskAttachments.length) {
        _taskAttachments.removeAt(index);
      }
    });
  }

  Future<void> _submitPlan() async {
    if (_summaryController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Summary cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final summary = _summaryController.text;

    final List<TaskEntry> tasks = [];
    for (int i = 0; i < _taskControllers.length; i++) {
      final title = _taskControllers[i]['title']!.text;
      if (title.isNotEmpty) {
        final safeAttachments = (i < _taskAttachments.length)
            ? _taskAttachments[i]
                .where((att) => att.url.toLowerCase().startsWith('http'))
                .toList()
            : <Attachment>[];
        tasks.add(TaskEntry(
          title: title,
          description: _taskControllers[i]['description']!.text.isNotEmpty
              ? _taskControllers[i]['description']!.text
              : null,
          status: TaskStatus.PLANNED,
          order: i,
          attachments: safeAttachments,
        ));
      }
    }

    if (tasks.isEmpty) {
      Get.snackbar(
        'Error',
        'Add at least one task',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await controller.createPlan(summary, tasks);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Today Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Summary',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomTextField(
                    controller: _summaryController,
                    label: "Summary (Today's focus)",
                    hintText: 'Example: Finish feature X',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_taskControllers.length} item(s)',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _taskControllers.length,
                itemBuilder: (context, index) {
                  return _buildTaskFormItem(index);
                },
              ),

              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _addTaskForm,
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.primary),
                label: const Text(
                  'Add Task',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'Save Plan',
                onPressed: _submitPlan,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskFormItem(int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.list_alt,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Task #${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (_taskControllers.length > 1)
                  IconButton(
                    tooltip: 'Hapus task',
                    onPressed: () => _removeTaskForm(index),
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taskControllers[index]['title'],
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g. Polish UI',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _taskControllers[index]['description'],
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Task details...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _buildAttachmentsSection(index),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(int taskIndex) {
    final attachments = taskIndex < _taskAttachments.length
        ? _taskAttachments[taskIndex]
        : <Attachment>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.attach_file, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            const Text(
              'Attachments',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              '${attachments.length}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (attachments.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < attachments.length; i++)
                InputChip(
                  label: Text(
                    attachments[i].label,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onDeleted: () {
                    setState(() {
                      _taskAttachments[taskIndex].removeAt(i);
                    });
                  },
                  avatar: Icon(
                    attachments[i].url.toLowerCase().startsWith('http')
                        ? Icons.link
                        : Icons.insert_drive_file,
                    size: 18,
                  ),
                )
            ],
          )
        else
          const Text(
            'No attachments',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => _promptAddLinkAttachment(taskIndex),
              icon: const Icon(Icons.link, color: AppColors.primary),
              label: const Text(
                'Add link',
                style: TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _pickLocalFile(taskIndex),
              icon: const Icon(Icons.attach_file, color: AppColors.primary),
              label: const Text(
                'Add file',
                style: TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _promptAddLinkAttachment(int taskIndex) async {
    final labelCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add attachment link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Label',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL (http/https)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final label = labelCtrl.text.trim();
                final url = urlCtrl.text.trim();
                if (label.isEmpty ||
                    !(url.toLowerCase().startsWith('http://') ||
                        url.toLowerCase().startsWith('https://'))) {
                  Get.snackbar(
                    'Invalid',
                    'Please enter a label and valid URL',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                setState(() {
                  _taskAttachments[taskIndex].add(
                    Attachment(
                      label: label,
                      url: url,
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                    ),
                  );
                });
                Get.back();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickLocalFile(int taskIndex) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final fileName = result.files.single.name;
        final filePath = result.files.single.path!;
        setState(() {
          _taskAttachments[taskIndex].add(
            Attachment(
              label: fileName,
              url: filePath, // local path; won\'t be uploaded yet
              description: 'Local file',
            ),
          );
        });
        Get.snackbar(
          'Attached',
          'File added to task attachments',
          backgroundColor: Colors.white,
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

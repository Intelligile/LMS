import 'package:flutter/material.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/core/utils/api.dart';
import 'package:dio/dio.dart';

class DMZSetupDownloadPage extends StatefulWidget {
  const DMZSetupDownloadPage({super.key});

  @override
  State<DMZSetupDownloadPage> createState() => _DMZSetupDownloadPageState();
}

class _DMZSetupDownloadPageState extends State<DMZSetupDownloadPage> {
  final Color primaryColor = const Color(0xFF017278); // LMS Primary Color

  Future<void> _downloadDMZSetup() async {
    try {
      Dio dio = Dio();
      const url = 'http://localhost:8080/downloads/dmz-setup.zip';
      const savePath =
          '/path/to/save/dmz-setup.zip'; // Specify the local save path

      await dio.download(url, savePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('DMZ setup downloaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download DMZ setup: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBreadcrumb(
              items: const ['Home', 'DMZ Setup Download'],
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Here is your DMZ setup ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'To enable secure DMZ access, download and configure the DMZ setup software.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _downloadDMZSetup,
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text('Download DMZ Setup',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

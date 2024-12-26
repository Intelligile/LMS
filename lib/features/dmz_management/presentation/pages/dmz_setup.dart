import 'dart:html' as html; // Import the HTML package
import 'package:flutter/material.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
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
      const url = 'http://localhost:8082/api/dmz/config/dmz-setup.zip';

      // Fetch the file from the server
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes), // Get raw bytes
      );

      // Create a Blob and initiate a download
      final blob = html.Blob([response.data]);
      final urlBlob = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: urlBlob)
        ..target = 'blank'
        ..download = 'dmz-setup.zip'
        ..click();

      // Revoke the URL object to free up resources
      html.Url.revokeObjectUrl(urlBlob);

      // Show success message
      print('DMZ setup downloaded successfully!');
    } catch (e) {
      // Show error message
      print('Failed to download DMZ setup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
            // const Text(
            //   'Here is your DMZ setup',
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            // const SizedBox(height: 16),
            // const Text(
            //   'To enable secure DMZ access, download and configure the DMZ setup software.',
            //   style: TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   onPressed: _downloadDMZSetup,
            //   icon: const Icon(Icons.download, color: Colors.white),
            //   label: const Text('Download DMZ Setup',
            //       style: TextStyle(color: Colors.white)),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: primaryColor,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 40),
            // const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Installation Instructions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow the steps below to install the DMZ setup:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildInstallationSection(
              title: 'Windows Installation',
              description: '1. Download the DMZ setup file.\n'
                  '2. Locate the downloaded file in your Downloads folder.\n'
                  '3. Double-click the file to start the installation wizard.\n'
                  '4. Follow the on-screen instructions to complete the installation.',
              onDownload: _downloadDMZSetup,
            ),
            const SizedBox(height: 20),
            _buildInstallationSection(
              title: 'Linux Installation',
              description: '1. Download the DMZ setup file.\n'
                  '2. Open a terminal and navigate to the download location.\n'
                  '3. Run the following command to extract the file:\n'
                  '   `unzip dmz-setup.zip`\n'
                  '4. Follow the instructions in the extracted README file to complete the installation.',
              onDownload: _downloadDMZSetup,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallationSection({
    required String title,
    required String description,
    required VoidCallback onDownload,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download, color: Colors.white),
          label: Text('Download for $title',
              style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

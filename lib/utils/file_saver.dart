import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_saver/file_saver.dart';

class DocumentImageGrid extends StatelessWidget {
  final List<String> networkUrls;
  final List<File> localFiles;

  const DocumentImageGrid({
    super.key,
    required this.networkUrls,
    required this.localFiles,
  });

  Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        // ✅ Use FileSaver for cross-platform download
        await FileSaver.instance.saveFile(
          name: "document${DateTime.now()}",
          bytes: bytes,
          fileExtension: "png",
          mimeType: MimeType.png,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Download complete")));
      } else {
        throw Exception("HTTP ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Download failed: $e")));
    }
  }

  void _showImageDialog(BuildContext context, Widget image, {String? url}) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: image,
                  ),
                ),
                if (url != null) // Only show for network images
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text("Download"),
                      onPressed: () => _downloadImage(context, url),
                    ),
                  ),
              ],
            ),
          ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    Widget image,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // ✅ Network images
        ...networkUrls.map(
          (url) => _buildThumbnail(
            context,
            Image.network(url, fit: BoxFit.cover),
            () => _showImageDialog(
              context,
              Image.network(url, fit: BoxFit.contain),
              url: url,
            ),
          ),
        ),
        // ✅ Local images
        ...localFiles.map(
          (file) => _buildThumbnail(
            context,
            Image.file(file, fit: BoxFit.cover),
            () => _showImageDialog(
              context,
              Image.file(file, fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }
}

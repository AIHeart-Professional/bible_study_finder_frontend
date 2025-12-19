import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/group/worksheet.dart';
import '../../core/logging/logger.dart';
import '../../core/config/app_config.dart';
import '../../apis/group/group_api.dart';
import 'worksheet_editor_page.dart';

class GroupResourcesTab extends StatelessWidget {
  static final _logger = getLogger('GroupResourcesTab');
  final List<Worksheet> worksheets;
  final String groupId;
  final List<String> userPermissions;
  final Future<void> Function() onRefresh;

  const GroupResourcesTab({
    super.key,
    required this.worksheets,
    required this.groupId,
    required this.userPermissions,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    _logger.debug('Building GroupResourcesTab with ${worksheets.length} worksheets');
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Resources'),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return _buildHeader(context);
                  }
                  if (worksheets.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildWorksheetCard(context, worksheets[index - 1]);
                },
                childCount: worksheets.isEmpty ? 2 : worksheets.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _logger.debug('Refreshing worksheets for group: $groupId');
    try {
      await onRefresh();
      _logger.info('Successfully refreshed worksheets');
    } catch (e) {
      _logger.error('Error refreshing worksheets: $e');
    }
  }

  bool _canUploadResources() {
    final canUpload = userPermissions.contains('upload_resources') ||
        userPermissions.contains('create_worksheet') ||
        userPermissions.contains('edit_group_resources');
    
    // Debug logging
    debugPrint('GroupResourcesTab - User permissions: $userPermissions');
    debugPrint('GroupResourcesTab - Can upload: $canUpload');
    
    return canUpload;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Worksheets',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                Text(
                  '${worksheets.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                if (_canUploadResources()) ...[
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => _handleUploadResource(context),
                    icon: const Icon(Icons.upload),
                    tooltip: 'Upload Resource',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _handleUploadResource(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Resource'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload File'),
              subtitle: const Text('Upload a PDF or DOCX document'),
              onTap: () {
                Navigator.of(context).pop();
                _handleFileUpload(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_document),
              title: const Text('Create Worksheet'),
              subtitle: const Text('Create a new worksheet in-app'),
              onTap: () {
                Navigator.of(context).pop();
                _handleCreateWorksheet(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileUpload(BuildContext context) async {
    try {
      // Import file_picker
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx'],
      );

      if (result == null || result.files.isEmpty) {
        _logger.debug('File selection cancelled');
        return;
      }

      final file = result.files.first;
      _logger.debug('File selected: ${file.name}, size: ${file.size} bytes');

      if (file.bytes == null && file.path == null) {
        _logger.error('File has no data');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: File has no data')),
          );
        }
        return;
      }

      // Show title input dialog
      if (context.mounted) {
        _showTitleInputDialog(context, file);
      }
    } catch (e, stackTrace) {
      _logger.error('Error picking file: $e', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }

  void _showTitleInputDialog(BuildContext context, dynamic file) {
    final titleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Worksheet Title'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Enter a title for this worksheet',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a title')),
                );
                return;
              }
              Navigator.of(context).pop();
              _uploadFile(context, title, file);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(BuildContext context, String title, dynamic file) async {
    try {
      _logger.debug('Uploading file: ${file.name} with title: $title');
      
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Uploading worksheet...'),
              ],
            ),
            duration: Duration(minutes: 1),
          ),
        );
      }

      // Call API (we'll create this in the APIs layer)
      final success = await GroupApi.uploadWorksheet(
        groupId: groupId,
        title: title,
        file: file,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Worksheet uploaded successfully')),
          );
          // Refresh worksheets
          await onRefresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload worksheet')),
          );
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Error uploading file: $e', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: $e')),
        );
      }
    }
  }

  void _handleCreateWorksheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorksheetEditorPage(
          groupId: groupId,
          onWorksheetCreated: onRefresh,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Worksheets Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Worksheets will appear here when they are added to this group.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorksheetCard(BuildContext context, Worksheet worksheet) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showWorksheetDetails(context, worksheet),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      worksheet.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _truncateContent(worksheet.content),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Updated ${_formatDate(worksheet.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _truncateContent(String content) {
    if (content.length <= 150) {
      return content;
    }
    return '${content.substring(0, 150)}...';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  Widget _buildWorksheetContent(BuildContext context, Worksheet worksheet) {
    final isPdf = worksheet.contentType?.toLowerCase() == 'pdf' || 
                  worksheet.content.contains('PDF Document');
    
    if (isPdf && worksheet.fileId != null) {
      return _buildPdfViewer(context, worksheet);
    } else {
      return _buildHtmlContent(context, worksheet);
    }
  }

  Widget _buildPdfViewer(BuildContext context, Worksheet worksheet) {
    final pdfUrl = '${AppConfig.getBackendBaseUrl()}/groups/download_worksheet/${worksheet.fileId}';
    _logger.debug('Loading PDF from URL: $pdfUrl');
    
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SfPdfViewer.network(
              pdfUrl,
              onDocumentLoaded: (details) {
                _logger.info('PDF loaded successfully: ${details.document.pages.count} pages');
              },
              onDocumentLoadFailed: (details) {
                _logger.error('PDF load failed: ${details.error} - ${details.description}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to load PDF: ${details.description}'),
                    action: SnackBarAction(
                      label: 'Download',
                      onPressed: () => _downloadWorksheet(context, worksheet),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Loading PDF...',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHtmlContent(BuildContext context, Worksheet worksheet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Html(
          data: worksheet.content,
          style: {
            "body": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
            "p": Style(
              margin: Margins.only(bottom: 8),
            ),
            "h1": Style(
              fontSize: FontSize(24),
              fontWeight: FontWeight.bold,
              margin: Margins.only(bottom: 12, top: 8),
            ),
            "h2": Style(
              fontSize: FontSize(20),
              fontWeight: FontWeight.bold,
              margin: Margins.only(bottom: 10, top: 8),
            ),
            "h3": Style(
              fontSize: FontSize(18),
              fontWeight: FontWeight.bold,
              margin: Margins.only(bottom: 8, top: 8),
            ),
            "ul": Style(
              margin: Margins.only(bottom: 8, left: 20),
            ),
            "ol": Style(
              margin: Margins.only(bottom: 8, left: 20),
            ),
            "li": Style(
              margin: Margins.only(bottom: 4),
            ),
            "table": Style(
              border: Border.all(color: Colors.grey),
            ),
            "td": Style(
              padding: HtmlPaddings.all(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          },
        ),
      ),
    );
  }

  void _downloadWorksheet(BuildContext context, Worksheet worksheet) {
    if (worksheet.fileId == null) return;
    
    final url = '${AppConfig.getBackendBaseUrl()}/groups/download_worksheet/${worksheet.fileId}';
    _logger.debug('Downloading worksheet file from: $url');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download URL: $url\nOpen this URL in a browser to download the file.'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showWorksheetDetails(BuildContext context, Worksheet worksheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  worksheet.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Updated ${_formatDate(worksheet.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                if (worksheet.fileId != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _downloadWorksheet(context, worksheet),
                    icon: const Icon(Icons.download),
                    label: const Text('Download Original File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _buildWorksheetContent(context, worksheet),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


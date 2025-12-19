import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../../core/logging/logger.dart';
import '../../apis/group/group_api.dart';

class WorksheetEditorPage extends StatefulWidget {
  static final _logger = getLogger('WorksheetEditorPage');
  final String groupId;
  final Future<void> Function() onWorksheetCreated;

  const WorksheetEditorPage({
    super.key,
    required this.groupId,
    required this.onWorksheetCreated,
  });

  @override
  State<WorksheetEditorPage> createState() => _WorksheetEditorPageState();
}

class _WorksheetEditorPageState extends State<WorksheetEditorPage> {
  static final _logger = getLogger('WorksheetEditorPage');
  final _titleController = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Worksheet'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _saveWorksheet,
              icon: const Icon(Icons.save),
              tooltip: 'Save Worksheet',
            ),
        ],
      ),
      body: Column(
        children: [
          // Title input
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Worksheet Title',
                hintText: 'Enter a title for this worksheet',
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          // Editor
          Expanded(
            child: HtmlEditor(
              controller: _htmlController,
              htmlEditorOptions: const HtmlEditorOptions(
                hint: 'Start typing your worksheet content...',
                shouldEnsureVisible: true,
                initialText: '',
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeScrollable,
                defaultToolbarButtons: [
                  const StyleButtons(),
                  const FontSettingButtons(fontSizeUnit: false),
                  const FontButtons(clearAll: false),
                  const ColorButtons(),
                  const ListButtons(listStyles: false),
                  const ParagraphButtons(
                    textDirection: false,
                    lineHeight: false,
                    caseConverter: false,
                  ),
                  const InsertButtons(
                    video: false,
                    audio: false,
                    table: true,
                    hr: true,
                    otherFile: false,
                  ),
                ],
              ),
              otherOptions: const OtherOptions(
                height: 400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWorksheet() async {
    final title = _titleController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    // Get HTML content from editor
    final htmlContent = await _htmlController.getText();
    
    if (htmlContent.trim().isEmpty || htmlContent == '<p></p>' || htmlContent == '<p><br></p>') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some content')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);
    _logger.debug('Saving worksheet with title: $title');

    try {
      _logger.debug('HTML content length: ${htmlContent.length} characters');

      // Call API to create worksheet
      final success = await GroupApi.createWorksheetText(
        groupId: widget.groupId,
        title: title,
        content: htmlContent,
      );

      if (!mounted) return;

      if (success) {
        _logger.info('Worksheet created successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Worksheet created successfully')),
        );
        
        // Refresh and go back
        await widget.onWorksheetCreated();
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        _logger.warning('Failed to create worksheet');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create worksheet')),
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Error saving worksheet: $e', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving worksheet: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

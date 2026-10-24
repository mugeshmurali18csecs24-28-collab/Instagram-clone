import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback? onPostPublished;

  const CreatePostScreen({super.key, this.onPostPublished});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> _sampleGalleryImages = [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1000&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=1000&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1000&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=1000&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1000&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1000&auto=format&fit=crop&q=80',
  ];

  late String _selectedImageUrl;
  String _selectedFilter = 'Normal';
  bool _isPublishing = false;

  final List<String> _filters = [
    'Normal',
    'Clarendon',
    'Lark',
    'Juno',
    'Slumber',
    'Sepia',
    'B&W'
  ];

  final List<String> _quickHashtags = [
    '#Connectly',
    '#Photography',
    '#TravelGoals',
    '#DesignLife',
    '#DailyVibes'
  ];

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = _sampleGalleryImages[0];
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _addHashtag(String tag) {
    if (!_captionController.text.contains(tag)) {
      setState(() {
        _captionController.text = '${_captionController.text} $tag'.trim();
      });
    }
  }

  void _publishPost() {
    final caption = _captionController.text.trim();
    final location = _locationController.text.trim();

    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a caption for your post.')),
      );
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    // Extract hashtags
    final RegExp regExp = RegExp(r'#\w+');
    final matches = regExp.allMatches(caption);
    final hashtags = matches.map((m) => m.group(0)!).toList();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        final appState = AppStateProvider.of(context);
        appState.createPost(
          imageUrl: _selectedImageUrl,
          caption: caption,
          location: location,
          hashtags: hashtags,
        );

        setState(() {
          _isPublishing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your post is now live on Connectly! 🎉'),
            backgroundColor: AppTheme.primaryPink,
          ),
        );

        if (widget.onPostPublished != null) {
          widget.onPostPublished!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('New Post',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isPublishing ? null : _publishPost,
              child: _isPublishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppTheme.primaryPink),
                    )
                  : const Text(
                      'Publish',
                      style: TextStyle(
                        color: AppTheme.primaryPink,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview selected image with filter indicator
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColorFiltered(
                  colorFilter: _getFilterMatrix(_selectedFilter),
                  child: Image.network(
                    _selectedImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Select Image Gallery Row
            const Text(
              'Select Photo from Gallery',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleGalleryImages.length,
                itemBuilder: (context, index) {
                  final imgUrl = _sampleGalleryImages[index];
                  final isSelected = imgUrl == _selectedImageUrl;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImageUrl = imgUrl),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryPink
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imgUrl, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Filter Presets Slider
            const Text(
              'Filters',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isSelected = f == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryPurple,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = f;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Caption Text Box
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Hashtag Chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _quickHashtags.map((tag) {
                return ActionChip(
                  label: Text(tag,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.accentBlue)),
                  backgroundColor: Colors.blue.shade50,
                  onPressed: () => _addHashtag(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Location Input
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Add Location (e.g. San Francisco, CA)',
                prefixIcon: const Icon(Icons.location_on_outlined,
                    color: AppTheme.primaryPink),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  ColorFilter _getFilterMatrix(String filter) {
    switch (filter) {
      case 'Sepia':
        return const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0,     0,     0,     1, 0,
        ]);
      case 'B&W':
        return const ColorFilter.matrix([
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0,    0,    0,    1, 0,
        ]);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
    }
  }
}

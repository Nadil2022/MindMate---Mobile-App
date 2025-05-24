// lib/my_collection_screen.dart

import 'package:flutter/material.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({Key? key}) : super(key: key);

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  // Sample folders with initial items
  final List<Folder> _folders = [
    Folder(name: 'Sample Folder', items: ['file1.pdf', 'file2.jpg']),
    Folder(name: 'Resources', items: ['guide.pdf', 'diagram.png']),
  ];

  Future<void> _createFolder() async {
    // placeholder: implement later
  }

  Future<void> _addItem() async {
    // placeholder: implement later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Match your dark, transparent AppBar style
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
        title: const Text('My Collection', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Top row of buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _createFolder,
                      icon: const Icon(Icons.create_new_folder_outlined),
                      label: const Text('New Folder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // List of folders (with sample data)
              Expanded(
                child: ListView.builder(
                  itemCount: _folders.length,
                  itemBuilder: (context, idx) {
                    final folder = _folders[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Folder title
                          Text(
                            folder.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Folder items
                          if (folder.items.isEmpty)
                            const Text(
                              '  (No items)',
                              style: TextStyle(color: Colors.white38),
                            )
                          else
                            for (var fileName in folder.items)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.insert_drive_file,
                                        color: Colors.white54),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        fileName,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple data model for folder + items
class Folder {
  final String name;
  final List<String> items;
  Folder({required this.name, required this.items});
}
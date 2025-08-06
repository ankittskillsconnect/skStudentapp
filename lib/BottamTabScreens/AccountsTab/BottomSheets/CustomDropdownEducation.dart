import 'package:flutter/material.dart';

class SearchableDropdownField extends StatefulWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String label;

  const SearchableDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = 'Select an option',
  });

  @override
  State<SearchableDropdownField> createState() => _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late TextEditingController _searchController;
  late List<String> _filteredItems;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items.toSet().toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _filteredItems = widget.items.toSet().toList();
      _searchController.clear();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(String item) {
    widget.onChanged(item);
    _removeOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    // Get screen dimensions and available space
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    final availableSpaceBelow = screenHeight - position.dy - size.height - padding.bottom;
    final availableSpaceAbove = position.dy - padding.top;
    const maxDropdownHeight = 250.0;

    // Decide whether to open above or below
    bool openAbove = availableSpaceBelow < maxDropdownHeight && availableSpaceAbove > availableSpaceBelow;

    // Calculate dropdown height
    final dropdownHeight = (_filteredItems.length * 48.0 + 56.0).clamp(50.0, maxDropdownHeight);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, openAbove ? -(dropdownHeight + 4) : size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: size.width, // Match input field width
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              constraints: BoxConstraints(maxHeight: maxDropdownHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _filteredItems = widget.items
                            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
                            .toSet()
                            .toList();
                        _removeOverlay();
                        _overlayEntry = _createOverlayEntry();
                        Overlay.of(context).insert(_overlayEntry!);
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Scrollbar(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            dense: true,
                            title: Text(item),
                            onTap: () => _selectItem(item),
                            selected: widget.value == item,
                            selectedTileColor: Colors.blue.shade50,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _key,
        onTap: _toggleDropdown,
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            suffixIcon: Icon(
              _overlayEntry == null ? Icons.arrow_drop_down : Icons.arrow_drop_up,
            ),
          ),
          child: Text(
            widget.value ?? widget.label,
            style: TextStyle(
              color: widget.value == null ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
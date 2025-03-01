import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String, String, String) onSubjectSelected;

  const SearchBarWidget({Key? key, required this.onSubjectSelected})
      : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collectionGroup('subjects').get();

      List<Map<String, String>> results = snapshot.docs
          .where((doc) => doc['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .map((doc) {
        var parentSemester = doc.reference.parent.parent;
        var parentCourse = parentSemester?.parent.parent;

        return {
          'subjectId': doc.id,
          'subjectName': doc['name'].toString(),
          'semesterId': parentSemester?.id ?? '',
          'courseId': parentCourse?.id ?? '',
        };
      }).toList();

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _searchResults = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              autofocus: false,
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for subjects...',
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: _isLoading
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: _clearSearch,
                          )
                        : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_searchResults.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: 250),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var result = _searchResults[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Icon(Icons.book, color: Colors.blueAccent),
                  title: Text(result['subjectName']!,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    widget.onSubjectSelected(result['courseId']!,
                        result['semesterId']!, result['subjectId']!);
                    _controller.clear();
                    setState(() => _searchResults = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

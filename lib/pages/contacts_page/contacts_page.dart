import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3_wallet/constants/api_constants.dart';
import 'package:web3_wallet/resources/colors.dart';
import '../../model/models.dart';
import 'package:http/http.dart' as http;

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
  static const routeName = '/contacts';
}

class _ContactsPageState extends State<ContactsPage> {
  late List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContacts(); // Ensure this is called only once
    searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchContacts() async {
    const url =
        '${ApiConstants.apiBaseUrl}/api/users/contacts?userId=1'; // Replace with your actual endpoint URL

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNzE5NDk4MTM5LCJleHAiOjE3MTk1ODQ1Mzl9.V4dkz0CbAOaqOKhQCjj4-Gq5mvSpbRMH8rk0r9YGO6I'
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          contacts = jsonData.map((data) => Contact.fromJson(data)).toList();
          filteredContacts = contacts;
        });
      } else {
        print('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch contacts: $e');
    }
  }

  Future<void> addContact(String name, String publicAddress) async {
    const url =
        '${ApiConstants.apiBaseUrl}/api/users/contacts'; // Replace with your actual endpoint URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNzE5NDk4MTM5LCJleHAiOjE3MTk1ODQ1Mzl9.V4dkz0CbAOaqOKhQCjj4-Gq5mvSpbRMH8rk0r9YGO6I'
        },
        body: json.encode({
          'userId': 1, // Replace with actual user ID if needed
          'name': name,
          'publicAddress': publicAddress
        }),
      );

      if (response.statusCode == 201) {
        // Close the dialog and refresh contacts
        Navigator.of(context).pop();
        await fetchContacts();
      } else {
        print('Failed to add contact: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to add contact: $e');
    }
  }

  void _filterContacts() {
    setState(() {
      filteredContacts = contacts.where((contact) {
        final query = searchController.text.toLowerCase();
        return contact.name.toLowerCase().contains(query) ||
            contact.publicAddress.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _showAddContactDialog() async {
    String name = '';
    String publicAddress = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Public Address'),
                  onChanged: (value) {
                    publicAddress = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (name.isNotEmpty && publicAddress.isNotEmpty) {
                  await addContact(name, publicAddress);
                } else {
                  // Optionally show an error message if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Name and Public Address cannot be empty'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredContacts[index].name,
                style: Theme.of(context).textTheme.displayMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(filteredContacts[index].publicAddress,
                        style: Theme.of(context).textTheme.displaySmall),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: filteredContacts[index].publicAddress));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
    );
  }
}

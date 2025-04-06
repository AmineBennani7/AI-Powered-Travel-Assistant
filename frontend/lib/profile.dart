import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController =
      TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');
  final TextEditingController _locationController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          TextButton(
            onPressed: () {
            // Send data back to the previous screen
              Navigator.pop(context, {
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'location': _locationController.text,
                'phone': _phoneController.text,
              });
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.pink[100],
              child: const Icon(Icons.person, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your Name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel('First Name'),
            _buildTextField(_firstNameController),

            _buildLabel('Last Name'),
            _buildTextField(_lastNameController),

            _buildLabel('Location'),
            _buildTextField(_locationController),

            _buildLabel('Mobile Number'),
            Row(
              children: [
              // Country Code Field
                SizedBox(
                  width: 105, // fixed width for country code field
                  child: _buildTextField(
                    TextEditingController(), // or use a dedicated controller if needed
                    hintText: '+??',
                    isGreyHint: true,
                  ),
                ),
                const SizedBox(width: 28),
                // Phone Number Field
                Expanded(
                  child: _buildTextField(_phoneController),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    bool isGreyHint = false,
  }) {
    bool hasText = controller.text.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isGreyHint ? const Color(0xFF7C838D) : Colors.grey,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        suffixIcon: Icon(
          hasText ? Icons.check : Icons.help_outline,
          color: Colors.black,
          size: 20,
        ),
      ),
    ),
  );
}

}

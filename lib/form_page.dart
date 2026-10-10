// Student: Farah Alhasan
// Student Number: 21120205709

// PAGE 2 - Form Page
//
// Homework (section 11):
//  1. Phone number field added.
//  2. E-mail field added.
//  3. "Prefer not to say" added to gender options.
//  4. Sign up popup shows the user's name and age.
//  5. "Clear" button that resets the whole form.
//  6. After a successful sign up, pressing OK returns to the home page.

import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String? gender;
  DateTime? birthDate;
  int? age;

  Future<void> pickDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        birthDate = selectedDate;
        age = calculateAge(selectedDate);
      });
    }
  }

  int calculateAge(DateTime birth) {
    final today = DateTime.now();

    int calculatedAge = today.year - birth.year;

    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (!RegExp(r'^\d{10,13}$').hasMatch(digits)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail is required';
    }
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$').hasMatch(value.trim())) {
      return 'Enter a valid e-mail address';
    }
    return null;
  }

  void clearForm() {
    _formKey.currentState?.reset();
    nameController.clear();
    surnameController.clear();
    phoneController.clear();
    emailController.clear();
    cityController.clear();
    setState(() {
      gender = null;
      birthDate = null;
      age = null;
    });
  }

  void register() {
    final fieldsValid = _formKey.currentState!.validate();

    if (!fieldsValid || birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Text(
            '${nameController.text} ${surnameController.text} signed up!\n\n'
            'Name: ${nameController.text}\n'
            'Age: $age\n'
            'Gender: $gender\n'
            'Phone: ${phoneController.text}\n'
            'E-mail: ${emailController.text}\n'
            'City: ${cityController.text}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog and the form page -> back to home page.
                Navigator.of(dialogContext).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say'),
                  ),
                ],
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: nameController,
                validator: requiredValidator,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: surnameController,
                validator: requiredValidator,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: phoneController,
                validator: phoneValidator,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '05xx xxx xx xx',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                validator: emailValidator,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'example@mail.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.grey),
                ),
                title: Text(
                  birthDate == null
                      ? 'Select birth date'
                      : '${birthDate!.day}.${birthDate!.month}.${birthDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: pickDate,
              ),

              const SizedBox(height: 15),

              if (age != null)
                Text(
                  'Age: $age',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cityController,
                validator: requiredValidator,
                decoration: const InputDecoration(
                  labelText: 'City you live in',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: clearForm,
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: register,
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

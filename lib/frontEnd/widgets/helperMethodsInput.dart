import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Widget buildTextFormField({
  required String labelText,
  required String errorText,
  required void Function(String?) onSave,
  TextInputType keyboardType = TextInputType.text,
  int? maxLength,
}) {
  return Column(children: [
    SizedBox(height: 20,),
    TextFormField(
    style: TextStyle(color: Colors.white), // Text color
    keyboardType: keyboardType,
      maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.cyanAccent), // Label color
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyanAccent), // Border color
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: TextStyle(color: Colors.redAccent), // Error text color
    ),
    validator: (value) {
      if (value?.isEmpty ?? true) return errorText;
      return null;
    },
    onSaved: onSave,
  )]);
}


Widget buildDatePickerFormField({
  required BuildContext context,
  required String labelText,
  required String errorText,
  required void Function(DateTime) onSave,
}) {
  // Initialize with current date and time, adjusted to local timezone.
  TextEditingController _controller = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now().toLocal()),
  );

  return TextFormField(
    style: TextStyle(color: Colors.white),
    readOnly: true,
    controller: _controller,
    decoration: InputDecoration(
      labelText: labelText,
      suffixIcon: Icon(Icons.calendar_today),
    ),
    onTap: () async {
      // Ensure any other focused element is unfocused
      FocusScope.of(context).requestFocus(new FocusNode());

      // Present the date picker to the user
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateFormat('yyyy-MM-dd HH:mm').parse(_controller.text),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      // If the user selected a date
      if (pickedDate != null) {
        // Create a new DateTime object with added 3 hours
        DateTime dateWithAddedHours = pickedDate.add(Duration(hours: 3));

        // Format the date and update the controller with the new datetime
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateWithAddedHours);
        _controller.text = formattedDate; // Update the text field with the new date

        // Call the onSave function with the new DateTime object
        onSave(dateWithAddedHours);
      }
    },
    validator: (value) {
      if (value?.isEmpty ?? true) return errorText;
      return null;
    },
    onSaved: (value) {
      if (value != null) {
        onSave(DateFormat('yyyy-MM-dd HH:mm').parse(value));
      }
    },
  );
}


Widget buildStepDot({required bool isSelected}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    height: 10,
    width: 10,
    decoration: BoxDecoration(
      color: isSelected ? Colors.cyanAccent : Colors.grey,
      shape: BoxShape.circle,
    ),
  );
}




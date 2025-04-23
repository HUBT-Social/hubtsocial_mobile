import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

class EditProfileForm extends StatefulWidget {
  final User user;

  const EditProfileForm({super.key, required this.user});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dateOfBirthController;
  late Gender selectedGender;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    dateOfBirthController = TextEditingController(
      text: widget.user.birthDay != null
          ? "${widget.user.birthDay!.day.toString().padLeft(2, '0')}/${widget.user.birthDay!.month.toString().padLeft(2, '0')}/${widget.user.birthDay!.year}"
          : '',
    );
    selectedGender = widget.user.gender ?? Gender.Other;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          context,
          controller: firstNameController,
          label: context.loc.first_name,
          hint: context.loc.first_name_hint,
          required: true,
        ),
        const SizedBox(height: 8), 
        _buildTextField(
          context,
          controller: lastNameController,
          label: context.loc.last_name,
          hint: context.loc.last_name_hint,
          required: true,
        ),
        const SizedBox(height: 8),
        _buildDropdownField(
          context,
          label: context.loc.gender,
          value: selectedGender,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedGender = value;
              });
            }
          },
        ),
        const SizedBox(height: 8),
        _buildTextField(
          context,
          controller: dateOfBirthController,
          label: context.loc.birth_of_date,
          hint: 'dd/mm/yyyy',
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              dateOfBirthController.text =
                  "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 13,
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required) const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 4), 
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 13), 
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8, 
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required Gender value,
    required ValueChanged<Gender?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: 13,
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4), 
        DropdownButtonFormField<Gender>(
          value: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8, 
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
          items: Gender.values
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(
                      gender.name,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

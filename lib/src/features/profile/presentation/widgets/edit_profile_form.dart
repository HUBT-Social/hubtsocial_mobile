import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

class EditProfileForm extends StatefulWidget {
  final User user;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final GlobalKey<FormState> formKey;

  const EditProfileForm({
    super.key,
    required this.user,
    required this.firstNameController,
    required this.lastNameController,
    required this.formKey,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController dateOfBirthController;
  late Gender selectedGender;

  @override
  void initState() {
    super.initState();
    dateOfBirthController = TextEditingController(
      text: widget.user.birthDay != null
          ? "${widget.user.birthDay!.day.toString().padLeft(2, '0')}/${widget.user.birthDay!.month.toString().padLeft(2, '0')}/${widget.user.birthDay!.year}"
          : '',
    );
    selectedGender = widget.user.gender ?? Gender.Other;
  }

  @override
  void dispose() {
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            controller: widget.firstNameController,
            label: context.loc.first_name,
            hint: context.loc.first_name_hint,
            required: true,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            context,
            controller: widget.lastNameController,
            label: context.loc.last_name,
            hint: context.loc.last_name_hint,
            required: true,
          ),
          const SizedBox(height: 8),
          _buildDropdownField(
            context,
            label: context.loc.gender,
            value: selectedGender,
            onChanged: null, // Make read-only
            enabled: false, // Make read-only
          ),
          const SizedBox(height: 8),
          _buildTextField(
            context,
            controller: dateOfBirthController,
            label: context.loc.birth_of_date,
            hint: 'dd/mm/yyyy',
            readOnly: true, // Make read-only
            onTap: null, // Disable tap
          ),
        ],
      ),
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
              fontSize: 13,
              color: readOnly
                  ? context.colorScheme.onSurface.withOpacity(0.7)
                  : context.colorScheme.onSurface),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey
                    .withOpacity(0.3), // Lighter border when disabled
                width: 0.5,
              ),
            ),
          ),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required Gender value,
    required ValueChanged<Gender?>? onChanged,
    bool enabled = true,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey
                    .withOpacity(0.3), // Lighter border when disabled
                width: 0.5,
              ),
            ),
          ),
          items: Gender.values
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(
                      gender.name,
                      style: TextStyle(
                          fontSize: 13,
                          color: enabled
                              ? context.colorScheme.onSurface
                              : context.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
          iconDisabledColor: Colors.grey.withOpacity(0.5),
          style: TextStyle(
              color: enabled
                  ? context.colorScheme.onSurface
                  : context.colorScheme.onSurface.withOpacity(0.7)),
        ),
      ],
    );
  }
}

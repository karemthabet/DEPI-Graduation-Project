import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';

class CustomTextFormFieldWithCountries extends StatelessWidget {
  const CustomTextFormFieldWithCountries({
    super.key,
    required this.phoneController,
    this.validator,
  });

  final TextEditingController phoneController;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntlPhoneField(
              controller: phoneController,
              initialCountryCode: 'EG',
              dropdownIcon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.black,
              ),
              dropdownIconPosition: IconPosition.leading,
              languageCode: 'en',
              disableLengthCheck: true,
              decoration: InputDecoration(
                hintText: 'Your mobile number',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: AppColors.greyLight),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: formFieldState.errorText,
              ),
              onChanged: (phone) {
                formFieldState.didChange(phone.completeNumber);
              },
            ),
          ],
        );
      },
    );
  }
}

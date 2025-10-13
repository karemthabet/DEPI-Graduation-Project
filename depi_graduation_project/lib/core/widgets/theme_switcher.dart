import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/theme_cubit/theme_cubit.dart';
import 'package:whatsapp/core/theme_cubit/theme_cubit_state.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeCubitState>(
      builder: (context, state) {
        final isDark = state is DarkThemeState;
        return Transform.scale(
          scale: 1.2,
          child: Switch.adaptive(
            inactiveThumbColor: Colors.grey,
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withAlpha(50),
            value: isDark,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) async {
              await context.read<ThemeCubit>().toggleTheme();
            },
          ),
        );
      },
    );
  }
}

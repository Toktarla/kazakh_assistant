import 'package:flutter/material.dart';
import 'package:proj_management_project/config/app_colors.dart';

class DefaultAppBar extends CustomAppBar {
  const DefaultAppBar({
    String title = '',
    Color color = Colors.transparent,
    super.key,
  }) : super(
    title: title,
    color: color,
    leading: null,
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.titleTextStyle,
    this.leading,
    this.leadingWidth = 50,
    this.actions,
    this.color,
    this.centerTitle,
    super.key,
  });

  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final double leadingWidth;
  final Color? color;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: color,
    leading: leading ?? _buildBackButton(context),
    leadingWidth: leadingWidth,
    title: title != null ? Text(title!) : null,
    titleTextStyle: titleTextStyle ?? Theme.of(context).appBarTheme.titleTextStyle,
    centerTitle: centerTitle,
    actions: actions,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(40);

  Widget? _buildBackButton(BuildContext context) => ModalRoute.of(context)?.canPop ?? false
      ? const Padding(
    padding: EdgeInsets.only(left: 8),
    child: BackIconButton(),
  )
      : null;
}

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) => AppIconButton(
    onPressed: () => Navigator.pop(context),
    child: Icon(Icons.arrow_back_ios_new_outlined, color: Theme.of(context).iconTheme.color,),
  );
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyColor),
        color: backgroundColor,
      ),
      child: child,
    ),
  );
}

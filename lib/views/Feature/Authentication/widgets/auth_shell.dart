import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/appColor/app_colors.dart';

enum AuthTab { signIn, signUp }

class AuthPageScaffold extends StatelessWidget {
  final AuthTab selectedTab;
  final ValueChanged<AuthTab> onTabChanged;
  final List<Widget> children;

  const AuthPageScaffold({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = (size.height * 0.26).clamp(218.0, 236.0).toDouble();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Column(
            children: [
              _AuthHeader(
                height: headerHeight,
                selectedTab: selectedTab,
                onTabChanged: onTabChanged,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  final double height;
  final AuthTab selectedTab;
  final ValueChanged<AuthTab> onTabChanged;

  const _AuthHeader({
    required this.height,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.blueNav, AppColors.blue],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _HeaderSkyline()),
          SafeArea(
            bottom: false,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const _PinLogo(),
                  const SizedBox(height: 2),
                  Text(
                    'Parkealo',
                    style: GoogleFonts.nunito(
                      fontSize: 26,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rent your parking easily',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueLt,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AuthTabs(
                    selectedTab: selectedTab,
                    onTabChanged: onTabChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSkyline extends StatelessWidget {
  const _HeaderSkyline();

  @override
  Widget build(BuildContext context) {
    final bars = <_SkylineBar>[
      const _SkylineBar(left: -10, width: 30, height: 38),
      const _SkylineBar(left: 39, width: 27, height: 57),
      const _SkylineBar(left: 86, width: 45, height: 38),
      const _SkylineBar(left: 143, width: 24, height: 66),
      const _SkylineBar(left: 190, width: 24, height: 48),
      const _SkylineBar(left: 243, width: 23, height: 72),
      const _SkylineBar(left: 287, width: 26, height: 43),
      const _SkylineBar(left: 328, width: 32, height: 60),
    ];

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 36,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.blueDk.withValues(alpha: 0.16),
            ),
          ),
        ),
        for (final bar in bars)
          Positioned(
            left: bar.left,
            bottom: 0,
            child: Container(
              height: bar.height,
              width: bar.width,
              decoration: BoxDecoration(
                color: AppColors.blueSky.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SkylineBar {
  final double left;
  final double width;
  final double height;

  const _SkylineBar({
    required this.left,
    required this.width,
    required this.height,
  });
}

class _PinLogo extends StatelessWidget {
  const _PinLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      width: 66,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 66,
            color: AppColors.blueSky.withValues(alpha: 0.95),
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          Positioned(
            top: 8,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 32,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 18,
            child: Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTabs extends StatelessWidget {
  final AuthTab selectedTab;
  final ValueChanged<AuthTab> onTabChanged;

  const _AuthTabs({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 158,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _AuthTabButton(
            label: 'Sign In',
            isSelected: selectedTab == AuthTab.signIn,
            onTap: () => onTabChanged(AuthTab.signIn),
          ),
          _AuthTabButton(
            label: 'Sign Up',
            isSelected: selectedTab == AuthTab.signUp,
            onTap: () => onTabChanged(AuthTab.signUp),
          ),
        ],
      ),
    );
  }
}

class _AuthTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AuthTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.bg : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected ? AppColors.shadowSm : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: isSelected ? AppColors.blue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String text;

  const AuthFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: AppColors.textSub,
      ),
    );
  }
}

class AuthInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;

  const AuthInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && obscureText,
      cursorColor: AppColors.blue,
      style: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 52),
        suffixIconConstraints: const BoxConstraints(minWidth: 48),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: SvgPicture.asset(
            widget.prefixIcon,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textFaint,
              BlendMode.srcIn,
            ),
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 19,
                  color: AppColors.textFaint,
                ),
              )
            : null,
        hintStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSub,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderMd, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class AuthCheckRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const AuthCheckRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value ? AppColors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.blue : AppColors.borderMd,
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSub,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.blue, AppColors.blueSky],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textFaint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }
}

class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AuthSocialButton(
            icon: 'assets/icons/appleIcon.svg',
            label: 'Apple',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _AuthSocialButton(
            icon: 'assets/icons/googleIcon.svg',
            label: 'Google',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _AuthSocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _AuthSocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 49,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 20, height: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

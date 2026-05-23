import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _softGreen = Color(0xFFE9FFF4);
const _greenInk = Color(0xFF006B3D);

class PublishParkingSpacesPage extends StatelessWidget {
  const PublishParkingSpacesPage({super.key});

  static const _tabs = ['Location', 'Details', 'Spaces', 'Services', 'Photos'];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _pageBg,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _PublishHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < _tabs.length; i++) ...[
                          Expanded(
                            child: _StepPill(
                              label: _tabs[i],
                              isSelected: i == 0,
                            ),
                          ),
                          if (i != _tabs.length - 1) const SizedBox(width: 5),
                        ],
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'P',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '10 spaces • 1 level',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Preview of your parking map',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9AA6B4),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _SpacesGrid(),
                    const SizedBox(height: 32),
                    const _IdentifierNote(),
                    const SizedBox(height: 38),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/publish-parking-services',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _actionBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishHeader extends StatelessWidget {
  const _PublishHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 17),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 42,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Publish parking',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? _primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _primaryBlue, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: isSelected ? Colors.white : _ink,
              fontSize: 8.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpacesGrid extends StatelessWidget {
  const _SpacesGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 7,
        crossAxisSpacing: 7,
        childAspectRatio: 1.32,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _softGreen,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFDDF8EA)),
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: _greenInk,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      },
    );
  }
}

class _IdentifierNote extends StatelessWidget {
  const _IdentifierNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.emoji_objects_outlined,
            color: Colors.black,
            size: 14,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: _ink, fontSize: 8.6, height: 1.25),
                children: [
                  TextSpan(text: 'You will be able to '),
                  TextSpan(
                    text: 'customize the identifiers\n(A1, VIP, T1...)',
                    style: TextStyle(
                      color: _primaryBlue,
                      decoration: TextDecoration.underline,
                      decorationColor: _primaryBlue,
                    ),
                  ),
                  TextSpan(
                    text: ' and sections from the\nadministration panel.',
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

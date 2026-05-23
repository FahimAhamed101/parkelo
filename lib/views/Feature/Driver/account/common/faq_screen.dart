import 'package:flutter/material.dart';

import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';



class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? expandedIndex = 0;

  final List<Map<String, String>> faqs = [
    {
      "question": "How do I book a service App?",
      "answer": "Select your service, pick a date & time, and confirm. You'll get a notification with details."
    },
    {
      "question": "Can I reschedule or cancel my booking?",
      "answer": "Yes, you can reschedule or cancel your booking from the app up to 24 hours in advance."
    },
    {
      "question": "What payment methods are accepted?",
      "answer": "We accept major credit cards and digital wallets through our secure Stripe integration."
    },
    {
      "question": "How do I contact the service provider?",
      "answer": "You can use the in-app chat or call feature once your booking is confirmed."
    },
    {
      "question": "Is my personal information safe?",
      "answer": "Yes, we use bank-level encryption and do not sell your personal data to third parties."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Faq"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: List.generate(faqs.length, (index) {
            final faq = faqs[index];
            final isExpanded = expandedIndex == index;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: Key(index.toString()),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      expandedIndex = expanded ? index : null;
                    });
                  },
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: AppText(
                    faq["question"]!, 
                    fontSize: 13, 
                    fontWeight: FontWeight.w600, 
                    color: Colors.grey.shade800
                  ),
                  iconColor: Colors.grey.shade600,
                  collapsedIconColor: Colors.grey.shade600,
                  childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  children: [
                    AppText(
                      faq["answer"]!, 
                      fontSize: 12, 
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Premium',
          style: TextStyle(
            color: Color(0xFF1B1E28),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upgrade to GuideMe Premium',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1E28),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Get access to exclusive features, enhanced planning tools, and more travel magic!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7C838D),
              ),
            ),
            const SizedBox(height: 32),
            const PremiumFeatureItem(
              icon: Icons.star_border,
              title: 'Priority Recommendations',
              description: 'Get tailored suggestions based on your travel style.',
            ),
            const SizedBox(height: 16),
            const PremiumFeatureItem(
              icon: Icons.download_rounded,
              title: 'Offline Access',
              description: 'Save your trips and guides even when offline.',
            ),
            const SizedBox(height: 16),
            const PremiumFeatureItem(
              icon: Icons.language,
              title: 'Multi-language Support',
              description: 'Access content in your preferred language.',
            ),
            const SizedBox(height: 16),
            const PremiumFeatureItem(
              icon: Icons.chat_bubble_outline,
              title: 'Unlimited Prompts',
              description: 'Get unlimited prompts on our chatbot',
            ),
            const SizedBox(height: 50),

            // "Choose Your Plan" text
            const Center(
              child: Text(
                'Choose your plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1E28),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Monthly Plan Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // : Handle monthly subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Monthly Plan - \$4.99'),
              ),
            ),
            const SizedBox(height: 12),

            // Yearly Plan Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // : Handle yearly subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Yearly Plan - \$39.99'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PremiumFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PremiumFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Color(0xFF4285F4)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1E28),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7C838D),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

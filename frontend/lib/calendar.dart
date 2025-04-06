import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendations.dart';
import 'premium.dart';
import 'profile.dart';
import 'chatbot.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentDate = DateTime.now();
  bool _isMonthView = false;

  void _goToPrevious() {
    setState(() {
      _currentDate = _isMonthView
          ? DateTime(_currentDate.year, _currentDate.month - 1, _currentDate.day)
          : _currentDate.subtract(const Duration(days: 7));
    });
  }

  void _goToNext() {
    setState(() {
      _currentDate = _isMonthView
          ? DateTime(_currentDate.year, _currentDate.month + 1, _currentDate.day)
          : _currentDate.add(const Duration(days: 7));
    });
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _toggleView() {
    setState(() {
      _isMonthView = !_isMonthView;
    });
  }

  List<DateTime> _getWeekDates() {
    final firstDay = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
    return List.generate(7, (index) => firstDay.add(Duration(days: index)));
  }

  List<List<DateTime>> _getMonthDates() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final firstDayToDisplay = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
    final totalDays = ((lastDayOfMonth.difference(firstDayToDisplay).inDays) / 7.0).ceil() * 7;

    return List.generate(
      totalDays ~/ 7,
      (week) => List.generate(7, (day) => firstDayToDisplay.add(Duration(days: week * 7 + day))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedCurrentDate = DateFormat('d MMMM yyyy').format(_currentDate);
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B1E28),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedCurrentDate,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1E28),
                      ),
                    ),
                    Row(
                      children: [
                        _simpleIcon(_goToPrevious, Icons.arrow_back_ios),
                        const SizedBox(width: 6),
                        _simpleIcon(_toggleView, _isMonthView ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        const SizedBox(width: 6),
                        _simpleIcon(_goToNext, Icons.arrow_forward_ios),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _goToToday,
                          icon: const Icon(Icons.access_time, size: 14),
                          label: const Text('Today'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4285F4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C838D),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              if (_isMonthView)
                ..._getMonthDates().map(
                  (week) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                    child: Row(
                      children: week.map((date) {
                        final isToday = date.year == today.year &&
                            date.month == today.month &&
                            date.day == today.day;
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: isToday ? const Color(0xFFFF7029) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isToday ? Colors.white : const Color(0xFF1B1E28),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: _getWeekDates().map((date) {
                      final isToday = date.year == today.year &&
                          date.month == today.month &&
                          date.day == today.day;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isToday ? const Color(0xFFFF7029) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isToday ? Colors.white : const Color(0xFF1B1E28),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Schedule",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1E28),
                      ),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF24BAEC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ScheduleCard(
                      imageUrl: "https://picsum.photos/80/80",
                      date: "26 January 2022",
                      title: "Niladri Reservoir",
                      location: "Tekergat, Sunamgnj",
                    ),
                    SizedBox(height: 12),
                    ScheduleCard(
                      imageUrl: "https://picsum.photos/80/80?2",
                      date: "26 January 2022",
                      title: "Darma Reservoir",
                      location: "Darma, Kuningan",
                    ),
                    SizedBox(height: 12),
                    ScheduleCard(
                      imageUrl: "https://picsum.photos/80/80?3",
                      date: "26 January 2022",
                      title: "High Rech Park",
                      location: "Zeero Point, Sylhet",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleIcon(VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String title;
  final String location;

  const ScheduleCard({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1EB3BCC8), blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF7C838D)),
                    const SizedBox(width: 4),
                    Text(date,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF7C838D))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1E28))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF7C838D)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(location,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF7C838D))),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RecommendationsPage()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CalendarPage()),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatbotPage()),
      );
      break;
    case 3:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfilePage()),
      );
      break;
    case 4: // ⭐️ Premium page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PremiumPage()),
      );
      break;
  }
},

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
        // BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"), NOT NEEDED THIS PAGE
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chatbot"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Premium Version"),
      ],
    );
  }
}

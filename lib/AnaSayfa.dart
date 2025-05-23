import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'FeedPage.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:table_calendar/table_calendar.dart';
import 'YemekTarifleri.dart';
import 'Profile.dart';

class PaketKart extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final String arkaPlan;
  final VoidCallback? onTap;

  const PaketKart(this.baslik, this.aciklama, this.arkaPlan,
      {super.key, this.onTap});

  void _showPopup(BuildContext context, String baslik, String aciklama) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(arkaPlan),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        baslik,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        aciklama,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Show more"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Kapat"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          opacity: 0.6,
          image: AssetImage(arkaPlan),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap ?? () => _showPopup(context, baslik, aciklama),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                baslik,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(aciklama, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class AnaSayfaIcerigi extends StatelessWidget {
  const AnaSayfaIcerigi({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    required this.taskController,
    required this.onAddTask,
    required this.onDeleteTask,
    required this.getTasksForSelectedDay,
    required this.showExercisePopup,
  });

  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final TextEditingController taskController;
  final VoidCallback onAddTask;
  final Function(int) onDeleteTask;
  final List<String> Function(DateTime) getTasksForSelectedDay;
  final Function(BuildContext, String, List<String>) showExercisePopup;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/girisekrani.jpg"),
                fit: BoxFit.cover,
                opacity: 0.07,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 20),
                      lastDay: DateTime.utc(2060, 10, 20),
                      focusedDay: selectedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDay),
                      onDaySelected: (newSelectedDay, focusedDay) {
                        onDaySelected(newSelectedDay, focusedDay);
                      },
                      headerStyle: const HeaderStyle(
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      calendarStyle: const CalendarStyle(
                        todayTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: const InputDecoration(
                              labelText: "Görev Ekle",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: onAddTask,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: getTasksForSelectedDay(selectedDay).isEmpty
                        ? const Center(child: Text("Bu gün için görev yok."))
                        : ListView.builder(
                            itemCount:
                                getTasksForSelectedDay(selectedDay).length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    getTasksForSelectedDay(selectedDay)[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    onDeleteTask(index);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.auto_graph_outlined,
                          size: 30,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Alınması Gereken Kalori Miktarı:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 2250),
                                duration: const Duration(seconds: 3),
                                builder: (context, value, child) {
                                  double progress = value / 2500;

                                  return Row(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 70.0,
                                        lineWidth: 12.0,
                                        percent: progress.clamp(0.0, 1.0),
                                        center: Text(
                                          "${value.toStringAsFixed(0)}\nKcal",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                        backgroundColor: Colors.grey.shade300,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35.0),
                    child: Text(
                      'Diyetisyenler',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PaketKart(
                              'Selahattin Durmaz',
                              'Günlük öneriler, basit takip.',
                              "lib/assets/diyetisyenArkaPlan.jpg"),
                          PaketKart(
                              'Premium Paket',
                              'Özel diyet listeleri, haftalık analizler.',
                              "lib/assets/d3.jpeg"),
                          PaketKart(
                              'VIP Paket',
                              'Kişisel diyetisyen, gelişmiş analiz.',
                              "lib/assets/d3.jpeg"),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Egzersiz Bölümü',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PaketKart(
                            'SIRT VE BACAK EGZERSİZİ PROGRAMI',
                            'Isınma hareketleri, Sırt kasları ve bacak kasları için hareketler',
                            "lib/assets/fitnessArkaPlan.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              'Sırt ve Bacak Egzersizleri',
                              ["Deadlift", "Squat", "Leg Press", "Barbell Row"],
                            ),
                          ),
                          PaketKart(
                            'GÖĞÜS VE ÖN KOL PROGRAMI',
                            'Isınma hareketleri, Gögüs ve ön kol kasları için hareketler',
                            "lib/assets/fitnessArkaPlan.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Göğüs ve Ön Kol Egzersizleri",
                              [
                                "Bench Press",
                                "Incline Dumbell Press",
                                "Biceps Curl"
                              ],
                            ),
                          ),
                          PaketKart(
                            'OMUZ VE ARKA KOL PROGRAMI',
                            'Isınma hareketleri, Omuz ve Arka kol kasları için hareketler',
                            "lib/assets/fitnessArkaPlan.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Omuz ve Arka Kol Programı",
                              [
                                "Shoulder Press",
                                "Lateral Raise",
                                "Triceps Dips"
                              ],
                            ),
                          ),
                          PaketKart(
                            'FULL BODY PROGRAM',
                            'Bu egzersiz programı bütün kas gruplarını çalıştırmak içindir.',
                            "lib/assets/fitnessArkaPlan.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Full Body Egzersizleri",
                              ["Squats", "Push-ups", "Deadlifts", "Pull-ups"],
                            ),
                          ),
                          PaketKart(
                            "KARDİYO PROGRAMI",
                            "Yağ yağmak ve ödem atmak için egzersizler",
                            "lib/assets/fitnessArkaPlan.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Kardiyo Egzersizleri",
                              [
                                "Running",
                                "Cycling",
                                "Jumping Jacks",
                                "Mountain Climbers"
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 20),
              lastDay: DateTime.utc(2060, 10, 20),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w900,
                ),
              ),
              calendarStyle: const CalendarStyle(
                todayTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Text("Diğer Ana Sayfa İçerikleri Burada"),
        ],
      ),
    );
  }
}

class _AnasayfaState extends State<Anasayfa> {
  int _seciliKart = -1;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasks = {};
  TextEditingController _taskController = TextEditingController();
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // static kaldırıldı, final kaldı
  late final List<Widget> _widgetOptions = <Widget>[
    AnaSayfaIcerigi(
      selectedDay: _selectedDay,
      onDaySelected: (newSelectedDay, focusedDay) {
        setState(() {
          _selectedDay = newSelectedDay;
        });
      },
      taskController: _taskController,
      onAddTask: () {
        if (_taskController.text.isNotEmpty) {
          setState(() {
            _tasks[_selectedDay] = _tasks[_selectedDay] ?? [];
            _tasks[_selectedDay]!.add(_taskController.text);
            _taskController.clear();
          });
        }
      },
      onDeleteTask: (index) {
        setState(() {
          _tasks[_selectedDay]!.removeAt(index);
        });
      },
      getTasksForSelectedDay: (day) {
        return _tasks[day] ?? [];
      },
      showExercisePopup:
          _showExercisePopup, // İşte yeni eklenen parametre ve değeri
    ),
    Profile(),
    Diyetisyenim(),
    FeedPage(),
    YemekTarifleri(),
  ];

  String _getGifPath(String hareketAdi) {
    switch (hareketAdi) {
      case "Barbell Row":
        return "lib/assets/gifs/barbellRow.gif";
      case "Deadlift":
        return "lib/assets/gifs/deadlift.gif";
      case "Squat":
        return "lib/assets/gifs/squat.gif";
      case "Leg Press":
        return "lib/assets/gifs/legpress.gif";
      case "Bench Press":
        return "lib/assets/gifs/benchPress.gif";
      case "Incline Dumbell Press":
        return "lib/assets/gifs/inclinee.gif";
      case "Biceps Curl":
        return "lib/assets/gifs/bicepsCurl.gif";
      case "Shoulder Press":
        return "lib/assets/gifs/shoulderPress.gif";
      case "Lateral Raise":
        return "lib/assets/gifs/latereal.gif";
      case "Triceps Dips":
        return "lib/assets/gifs/dips.gif";
      case "Squats":
        return "lib/assets/gifs/squat.gif";
      case "Push-ups":
        return "lib/assets/gifs/pushUp.gif";
      case "Deadlifts":
        return "lib/assets/gifs/deadlift.gif";
      case "Pull-ups":
        return "lib/assets/gifs/pullUps.gif";
      case "Running":
        return "lib/assets/gifs/running.gif";
      case "Cycling":
        return "lib/assets/gifs/cycling.gif";
      case "Jumping Jacks":
        return "lib/assets/gifs/jmp.gif";
      case "Mountain Climbers":
        return "lib/assets/gifs/mountain.gif";
      default:
        return "lib/assets/gifs/default.gif";
    }
  }

  void _showGif(BuildContext context, String hareketAdi, String giffYolu) {
    final gifPath = _getGifPath(hareketAdi);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hareketAdi),
        content: Image.asset(giffYolu),
        actions: [
          TextButton(
            child: const Text("Kapat"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context, String baslik, String aciklama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage('lib/assets/girisekrani.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  baslik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  aciklama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Show more"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Kapat"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExercisePopup(
      BuildContext context, String title, List<String> hareketler) {
    int currentIndex = 0;
    int remainingSeconds = 10;
    late Timer timer;

    void startTimer(StateSetter setState) {
      remainingSeconds = 45;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds == 0) {
          t.cancel();
          if (currentIndex < hareketler.length - 1) {
            currentIndex++;
            startTimer(setState);
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("TEBRİKLER:)"),
                content: const Text("Tüm Egzersizleri Tamamladınız."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kapat"),
                  )
                ],
              ),
            );
          }
        } else {
          setState(() {
            remainingSeconds--;
          });
        }
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          if (remainingSeconds == 10 && currentIndex == 0) {
            startTimer(setState);
          }

          String hareketAdi = hareketler[currentIndex];
          String gifPath = _getGifPath(hareketAdi);

          return AlertDialog(
            title: Text("$title\n(${currentIndex + 1}/${hareketler.length})"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hareketAdi,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Image.asset(gifPath, height: 150),
                const SizedBox(height: 10),
                Text(
                  "$remainingSeconds saniye",
                  style: const TextStyle(fontSize: 28, color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    timer.cancel();
                    if (currentIndex < hareketler.length - 1) {
                      currentIndex++;
                      startTimer(setState);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Geç (İleri)"),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Diyetisyenlik Uygulaması'),
        backgroundColor: const Color(0xFFD69C6C),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        indicatorColor: Color(0xFFD69C6C),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_box,
              size: 30,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.account_box_outlined,
              size: 30,
            ),
            label: 'Profilim',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.assignment_ind_rounded,
              size: 30,
              color: Colors.white,
            ),
            icon: Badge(
              child: Icon(
                Icons.assignment_ind_outlined,
                size: 30,
              ),
            ),
            label: 'Diyetisyenim',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.messenger,
              size: 25,
              color: Colors.white,
            ),
            icon: Icon(Icons.messenger_outline, size: 25),
            label: 'GÜndem',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.food_bank,
              color: Colors.white,
              size: 35,
            ),
            label: "Yemek",
            icon: Icon(
              Icons.food_bank_outlined,
              size: 35,
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(currentPageIndex),
      ),
    );
  }
}

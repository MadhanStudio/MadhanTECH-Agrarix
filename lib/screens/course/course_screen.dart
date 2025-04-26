import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- Add this
import '../../models/user_model.dart';
import 'course_card.dart';
import 'course_pelatihan_ahli.dart';
import 'course_pelatihan_detail_screen.dart'; // Import the missing screen
import 'course_upload.dart'; // Import the upload screen

class CourseScreen extends StatefulWidget {
  final UserModel user;

  const CourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String _activeFilter = 'pakar';

  List<Map<String, dynamic>> pakarCourses = [];
  List<Map<String, dynamic>> komunitasCourses = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      // Fetch course_pakar
      final pakarSnapshot =
          await FirebaseFirestore.instance
              .collection('courses_pelatihan')
              .get();
      pakarCourses =
          pakarSnapshot.docs
              .map(
                (doc) => {
                  'id': doc.id, // <-- ini penting biar punya id course
                  'title': doc['title'] ?? '',
                  'category':
                      '', // Kalau mau, kamu bisa tambahkan category juga di database
                  'date': '', // Kosongkan dulu karena tidak ada field date
                  'time': '',
                  'organizer': doc['authorName'] ?? '',
                  'description': doc['description'] ?? '',
                  'image_path': doc['image_path'] ?? '',
                },
              )
              .toList();

      // Fetch course_komunitas
      final komunitasSnapshot =
          await FirebaseFirestore.instance
              .collection('courses_komunitas')
              .get();
      komunitasCourses =
          komunitasSnapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'title': doc['title'] ?? '',
                  'category': '',
                  'date': '',
                  'time': '',
                  'organizer': doc['authorName'] ?? '',
                  'description': doc['description'] ?? '',
                  'image_path': doc['image_path'] ?? '',
                },
              )
              .toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF013133),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/agrarix_logo.png',
          width: 100,
          height: 50,
        ),
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 16),
          _buildFilterButtons(),
          const SizedBox(height: 16),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildCoursesList(),
          ),
        ],
      ),
floatingActionButton: _activeFilter == 'komunitas'
    ? FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman upload course
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseUploadScreen(
                user: widget.user,
                isPelatihanAhli: false,  // Setel isPelatihanAhli ke false untuk komunitas
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      )
    : null,

    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF013133),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Pelatihan Digital',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Lorem ipsum dolor sit amet consectetur. Pulvinar etiam tellus sed congue adipiscing quis feugiat nunc. Suspendisse lacus turpis quam nullam ut magna ultricies.',
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeFilter = 'pakar';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _activeFilter == 'pakar'
                        ? const Color(0xFF013133)
                        : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        _activeFilter == 'pakar'
                            ? const Color(0xFF013133)
                            : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/verified_course.png',
                    width: 32,
                    height: 32,
                    color: _activeFilter == 'pakar' ? Colors.amber : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pelatihan oleh Pakar\nAhli',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          _activeFilter == 'pakar'
                              ? Colors.amber
                              : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeFilter = 'komunitas';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _activeFilter == 'komunitas'
                        ? const Color(0xFF013133)
                        : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        _activeFilter == 'komunitas'
                            ? const Color(0xFF013133)
                            : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/comun_course.png',
                    width: 32,
                    height: 32,
                    color: _activeFilter == 'komunitas' ? Colors.amber : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pelatihan oleh\nKomunitas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          _activeFilter == 'komunitas'
                              ? Colors.amber
                              : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesList() {
    final courses = _activeFilter == 'pakar' ? pakarCourses : komunitasCourses;

    if (courses.isEmpty) {
      return const Center(child: Text('Belum ada course tersedia.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CourseCard(
            course: courses[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoursePelatihanDetailScreen(
                    courseId: courses[index]['id'] ?? '',
                    courseData: courses[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

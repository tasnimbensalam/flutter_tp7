import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterprojet7/entities/student.dart';
import 'package:flutterprojet7/service/studentservice.dart';
import 'package:flutterprojet7/template/navbar.dart';
import 'package:intl/intl.dart';

import '../template/dialog/studentdialog.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  double _currentFontSize = 0;
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Etudiant'),
      body: FutureBuilder(
        future: getAllStudent(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                print(index);
                print(snapshot.data[index]);
                print(_currentFontSize);
                return Slidable(
                  key: Key((snapshot.data[index]['id']).toString()),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.blue,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbColor: Colors.blueAccent,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                        ),
                        child: Container(
                          width: 100,
                          child: Slider(
                            min: 0,
                            max: 1000,
                            divisions: 5,
                            value: _currentFontSize,
                            onChanged: (value) {
                              setState(() {
                                _currentFontSize = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddStudentDialog(
                                  notifyParent: refresh,
                                  student: Student(
                                      snapshot.data[index]['dateNais'],
                                      snapshot.data[index]['nom'],
                                      snapshot.data[index]['prenom'],
                                      snapshot.data[index]['id']),
                                );
                              });
                          //print("test");
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                        spacing: 1,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await deleteStudent(snapshot.data[index]['id']);
                      setState(() {
                        snapshot.data.removeAt(index);
                      });
                    }),
                    children: [Container()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Nom et Prénom : "),
                                Text(
                                  snapshot.data[index]['nom'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(snapshot.data[index]['prenom']),
                              ],
                            ),
                            Text(
                              'Date de Naissance :' +
                                  DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                          snapshot.data[index]['dateNais'])),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddStudentDialog(
                  notifyParent: refresh,
                );
              });
          //print("test");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'person_model.dart';

class PersonPage extends StatefulWidget {
  @override
  _personPageState createState() => _personPageState();
}

class _personPageState extends State<PersonPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  //Make the initialization

  Future<List<Person>> persons;

  String _personName;
  String _personPhone;

  bool isUpdate = false;
  int personIdForUpdate;
  DBHelper dbHelper;

  final _personNameController = TextEditingController();
  final _personPhoneController = TextEditingController();

//also of the database
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshpersonList();
  }

//fetch persons list
  refreshpersonList() {
    setState(() {
      persons = dbHelper.getPerson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Info App'),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    onSaved: (value) {
                      _personName = value;
                    },
                    controller: _personNameController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Person Name",
                        labelText: "Name",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    onSaved: (value) {
                      _personPhone = value;
                    },
                    keyboardType: TextInputType.number,
                    controller: _personPhoneController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Person Name",
                        labelText: "Phone",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    (isUpdate ? 'UPDATE' : 'ADD'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (isUpdate) {
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();
                        dbHelper
                            .update(Person(
                                personIdForUpdate, _personName, _personPhone))
                            .then((data) {
                          setState(() {
                            isUpdate = false;
                          });
                        });
                      }
                    } else {
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();
                        dbHelper.add(Person(null, _personName, _personPhone));
                      }
                    }
                    _personNameController.text = '';
                    _personPhoneController.text = '';
                    refreshpersonList();
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    (isUpdate ? 'CANCEL' : 'CLEAR'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _personNameController.text = '';
                    _personPhoneController.text = '';
                    setState(() {
                      isUpdate = false;
                      personIdForUpdate = null;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: persons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Text('No Person Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

//Generate the list view from the data
  SingleChildScrollView generateList(List<Person> persons) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Phone'),
            ),
            DataColumn(
              label: Text(''),
            )
          ],
          rows: persons
              .map(
                (person) => DataRow(
                  cells: [
                    DataCell(
                      Text(person.name),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          personIdForUpdate = person.id;
                        });
                        _personNameController.text = person.name;
                        _personPhoneController.text = person.phone;
                      },
                    ),
                    DataCell(
                      Text(person.phone),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          personIdForUpdate = person.id;
                        });
                        _personNameController.text = person.name;
                        _personPhoneController.text = person.phone;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          dbHelper.delete(person.id);
                          refreshpersonList();
                        },
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

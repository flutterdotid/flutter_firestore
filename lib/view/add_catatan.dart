import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCatatan extends StatefulWidget {
  AddCatatan({this.email});
  final String email;
  @override
  _AddCatatanState createState() => _AddCatatanState();
}

class _AddCatatanState extends State<AddCatatan> {
  DateTime _dueDate = DateTime.now();
  String _dateText = '';

  String newTask = '';
  String note = '';


  Future<Null> selectionDueDate(BuildContext context) async{
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(1945),
      lastDate: DateTime(2040),
    );
    if(picked != null ){
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  void _addData(){
    Firestore.instance.runTransaction((Transaction transsaction) async{
      CollectionReference reference = Firestore.instance.collection("task");
      await reference.add({
        "email" : widget.email,
        "title" : newTask,
        "duedate" : _dueDate,
        "note" : note,
      });
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/background.jpg"),fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 32.0
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("CatatanQu",style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 2.0,
                  fontFamily: "Pacifico",
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Catatan Baru ",style: TextStyle( fontSize: 24.0, color: Colors.white),),
                ),
                Icon(Icons.list, color: Colors.white, size: 30.0,),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  newTask = str;
                });
              },
              decoration: InputDecoration(
                icon: Icon(Icons.dashboard, color: Colors.pinkAccent,),
                labelText: "New Task",
                hintText: "Playing Game",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0)
                ),
              ),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:16.0),
                  child: new Icon(Icons.date_range, color: Colors.pinkAccent,),
                ),
                new Expanded(child: Text("Due Date", style: TextStyle(fontSize: 18.0, color: Colors.black45),)),
                new FlatButton(
                  onPressed: () => selectionDueDate(context),
                  child: Text(_dateText, style: TextStyle(fontSize: 18.0, color: Colors.black45),),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  note = str;
                });
              },

              decoration: InputDecoration(
                icon: Icon(Icons.note, color: Colors.pinkAccent,),
                hintText: "Call Of Duty Game",
                labelText: "New Note",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0)
                ),
              ),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    _addData();
                  },
                  icon: Icon(Icons.check, size: 40.0 , color: Colors.green,),
                ),

                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, size: 40.0 , color: Colors.red,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
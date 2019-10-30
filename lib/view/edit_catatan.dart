import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCatatan extends StatefulWidget {
  EditCatatan({this.title,this.note,this.duedate,this.position});
  final String title;
  final String note;
  final DateTime duedate;
  final position;
  @override
  _EditCatatanState createState() => _EditCatatanState();
}

class _EditCatatanState extends State<EditCatatan> {
  TextEditingController _controllerTitle;
  TextEditingController _controllerNote;

  DateTime _dueDate;
  String _dateText = '';

  String newTask = '';
  String note = '';


  void updateTask(){
    Firestore.instance.runTransaction((Transaction transsaction) async{
      DocumentSnapshot snapshot =
      await transsaction.get(widget.position);
      await transsaction.update(snapshot.reference, {
        "title" : newTask,
        "note" : note,
        "duedate" : _dueDate,
      });
    });
    Navigator.pop(context);
  }


  Future<Null> selectionDueDate(BuildContext context) async{
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
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
    _dueDate = widget.duedate;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
    newTask = widget.title;
    note = widget.note;
    _controllerTitle = TextEditingController(text: widget.title);
    _controllerNote = TextEditingController(text: widget.note);
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
                Text("My Task",style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 2.0,
                  fontFamily: "Pacifico",
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Edit Task ",style: TextStyle( fontSize: 24.0, color: Colors.white),),
                ),
                Icon(Icons.list, color: Colors.white, size: 30.0,),
              ],
            ),
          ),


          // Todo Untuk New Task
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controllerTitle,
              onChanged: (String str){
                setState(() {
                  newTask = str;
                });
              },
              decoration: InputDecoration(
                icon: Icon(Icons.dashboard, color: Colors.pinkAccent,),
                hintText: "Edit Catatan",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),


          // Todo Untuk Date Picker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:16.0),
                  child: new Icon(Icons.date_range, color: Colors.pinkAccent,),
                ),
                new Expanded(child: Text("Due Date", style: TextStyle(fontSize: 22.0, color: Colors.black45),)),
                new FlatButton(
                  onPressed: () => selectionDueDate(context),
                  child: Text(_dateText, style: TextStyle(fontSize: 22.0, color: Colors.black45),),
                ),
              ],
            ),
          ),


          //Todo Untuk Note
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controllerNote,
              onChanged: (String str){
                setState(() {
                  note = str;
                });
              },
              decoration: InputDecoration(
                icon: Icon(Icons.note, color: Colors.pinkAccent,),
                hintText: "Keterangan",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    updateTask();
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
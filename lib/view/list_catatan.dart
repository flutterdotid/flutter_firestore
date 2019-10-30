import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './add_catatan.dart';
import './edit_catatan.dart';
import 'package:firebase/main.dart';


class CatatanQu extends StatefulWidget {
  CatatanQu({this.user, this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;


  @override
  _CatatanQuState createState() => _CatatanQuState();
}

class _CatatanQuState extends State<CatatanQu> {
  void _signOut(){
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
      height: 250.0,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.user.photoUrl),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Sign Out?", style: TextStyle(
                fontSize: 16.0
              ),),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(MaterialPageRoute
                      (builder: (context) => MyHomePage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check, color: Colors.green,),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text("Yes")
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close, color: Colors.red,),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text("Cancel")
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: 
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddCatatan(
              email : widget.user.email
            )
          ));
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.add, color: Colors.white,),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 32.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: Colors.pinkAccent,
        child: ButtonBar(
          children: <Widget>[
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
              .collection("task")
              .where("email", isEqualTo: widget.user.email)
              .snapshots(),
              
              builder: (BuildContext context, 
                  AsyncSnapshot<QuerySnapshot>snapshot){
                if(!snapshot.hasData)
                  return new Container( child:  Center(
                    child: CircularProgressIndicator(),
                  ),);
                return new ListCatatan(document: snapshot.data.documents,);
              },
            ),
          ),
          
          Container(
            height: 170.0,
              width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/background.jpg"), fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 32.0
                )
              ],
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60.0, height: 60.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(widget.user.photoUrl),fit: BoxFit.cover
                            )
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Welcome", style: TextStyle(fontSize: 16.0, color: Colors.white),),
                              Text("${widget.user.displayName}", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _signOut();
                        },
                        icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30.0,),
                      )
                    ],
                  ),
                ),
                new Text("My Task", style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 2.0,
                  fontFamily: "Pacifico",
                ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListCatatan extends StatelessWidget {
  ListCatatan({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String title = document[i].data['title'].toString();
        String note = document[i].data['note'].toString();
        DateTime duedate = document[i].data['duedate'].toDate();
        String _date = "${duedate.day}/${duedate.month}/${duedate.year}";

        return Dismissible(
          background: Container(
            color: Colors.red,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Delete Item", style: TextStyle(color: Colors.white, fontSize: 24.0),textAlign: TextAlign.end,),
                  ],
                ),
              ),
            ),
          ),

          key: new Key(document[i].documentID),
          onDismissed: (direction){
            Firestore.instance.runTransaction((Transaction transsaction)async{
              DocumentSnapshot snapshot =
              await transsaction.get(document[i].reference);
              await transsaction.delete(snapshot.reference);
            });
            Scaffold.of(context).showSnackBar(
                new SnackBar(content: Text("Item $title Deleted"), backgroundColor: Colors.blue,)
            );
          },

          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(title, style: TextStyle(fontSize: 18.0,letterSpacing: 1.0),),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:16.0),
                                child: Icon(Icons.date_range, color: Colors.pinkAccent,),
                              ),
                              Text(_date, style: TextStyle(fontSize: 14.0,),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:16.0),
                                child: Icon(Icons.note, color: Colors.pinkAccent,),
                              ),
                              Expanded(child: Text(note, style: TextStyle(fontSize: 14.0,),)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: (){
                     Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => EditCatatan(
                       title: title,
                       note: note,
                       duedate: duedate,
                       position: document[i].reference,
                     )
                         ));
                    },
                    icon: Icon(Icons.edit),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Widget studentCard(name,mobNo,due,paid,address,date) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Container(
        height: 170.0,
        width: size.width,
        child: Card(
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Name : $name'),
                        Text('Mobile Number : $mobNo'),
                        Text('Date : $date'),
                        Text('Paid : $paid'),
                        Text('Due : $due'),
                        Text('Address : $address'),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Customer")
                .snapshots(),
            // ignore: missing_return
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return new Text(
                    'Error: ${snapshot.error}');
              }
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Loading..."),
                      SizedBox(
                        height: 50.0,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) => LayoutBuilder(builder: (ctx, constraint){
                      return studentCard(
                        snapshot.data.documents[index].data["name"],
                        snapshot.data.documents[index].data["phone"],
                        snapshot.data.documents[index].data["due"],
                        snapshot.data.documents[index].data["paid"],
                        snapshot.data.documents[index].data["address"],
                        snapshot.data.documents[index].data["date"],

                      );},)
                );

              }
            }));
  }
}

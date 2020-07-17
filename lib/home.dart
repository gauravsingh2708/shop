import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ridhi_enterprises/history.dart';
import 'package:ridhi_enterprises/payment.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String product, price,quantity;
  String date =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
  List productList = [];
  bool _isAdding = false;
  final _formKey = new GlobalKey<FormState>();
  String pro, pri, quan;
  int total = 0;
  List item = [];

  Future<void> _showMyDialog(index,pro,pri,quan) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child:Text('Edit and Delete'),),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(color:Colors.teal,icon:Icon(Icons.edit,size: 45.0,), onPressed:(){
                  setState(() {
                    total-=productList[index][3];
                    productList.removeAt(index);
                    _isAdding=true;
                    product=pro;
                    price=pri;
                    quantity=quan;
                  });
                  Navigator.of(context).pop();
                }),
                IconButton(color:Colors.teal,icon:Icon(Icons.delete,size: 45.0,), onPressed:(){
                  setState(() {
                    total-=productList[index][3];
                    productList.removeAt(index);
                  });
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ridi Enterprisie'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            setState(() {
              productList=[];
              total=0;
            });
          }),
          SizedBox(
            width: 30,
          ),
          Center(child: Text(date)),
          SizedBox(
            width: 30,
          ),
          IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              })
        ],
      ),
      floatingActionButton: _isAdding
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isAdding = true;
                });
              },
              child: Icon(Icons.add),
            ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(padding:EdgeInsets.only(top: 15.0),child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Product',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Price',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quantity',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Amount',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              Column(
                children: List.generate(
                  productList.length,
                  (index) => Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                          onLongPress:(){
                            _showMyDialog(index,productList[index][0],productList[index][1],productList[index][2],);
                          },
                          child:Container(
                              height: 40.0,
                              child: Card(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    '${productList[index][0]}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${productList[index][1]}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${productList[index][2]}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${productList[index][3]}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))))),
                ),
              )
            ],
          ),
          _isAdding
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[Text('Total'), Text('${total}')],
                  ),
                ),
          _isAdding
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                      child: Form(
                          key: _formKey,
                          child: Card(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
//                                        controller: product,
                                      initialValue: product,
                                        validator: (value) => value.isEmpty
                                            ? 'Enter the Product Name'
                                            : null,
                                        onSaved: (value) => pro = value.trim(),
                                        decoration: InputDecoration(
                                            labelText: 'Product'),
                                      ),
                                      TextFormField(
//                                        controller: price,
                                      initialValue: price,
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value.isEmpty
                                            ? 'Enter the Price'
                                            : null,
                                        onSaved: (value) => pri = value.trim(),
                                        decoration:
                                            InputDecoration(labelText: 'Price'),
                                      ),
                                      TextFormField(
//                                        controller: quantity,
                                      initialValue: quantity,
                                        validator: (value) => value.isEmpty
                                            ? 'Enter the Number of Product'
                                            : null,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) => quan = value.trim(),
                                        decoration: InputDecoration(
                                            labelText: 'Quantity'),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          if (validateAndSave()) {
                                            setState(() {
                                              _isAdding = !_isAdding;
                                            });
                                            item.add(pro);
                                            item.add(pri);
                                            item.add(quan);
                                            item.add(int.parse(pri) *
                                                int.parse(quan));
                                            setState(() {
                                              productList.add(item);
                                              total += int.parse(pri) *
                                                  int.parse(quan);
                                            });
                                            item = [];
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Enter All Field",
                                                timeInSecForIos: 4,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.teal,
                                                textColor: Colors.white);
                                          }
                                        },
                                        child: Icon(Icons.add),
                                        color: Colors.teal,
                                      )
                                    ],
                                  ))))))
              : Container(),
          total == 0
              ? Container()
              : MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment(total:total,productList: productList,)));
                  },
                  child: Text('Payment'),
                  color: Colors.teal,
                )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ridhi_enterprises/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Payment extends StatefulWidget {
  final List productList;
  final int total;
  Payment({this.productList, this.total});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = new GlobalKey<FormState>();
  final pdf = pw.Document();
  bool _isLoading;
  String name, mobNo, address, paid;
  int due;
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> addReceipt(name, phone, address, paid, due) async {
    try {
      DocumentReference documentReference =
          Firestore.instance.document('Customer/${DateTime.now()}');
      Map<String, String> info = <String, String>{
        'name': name,
        'phone': phone,
        'address': address,
        'paid': '$paid',
        'due': '$due',
        'date':
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"
      };
      await documentReference.setData(info);
    } catch (e) {
      print(e.message);
    }
  }

  void writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Center(
                  child: pw.Text("Ridhi Enterprise",
                      style: pw.TextStyle(fontSize: 30.0)))),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text('Name : $name'),
                pw.SizedBox(height: 10.0),
                pw.Text('Mobile Number : $mobNo'),
                pw.SizedBox(height: 10.0),
                pw.Text('Total : ${widget.total}'),
                pw.SizedBox(height: 10.0),
                pw.Text('Paid : $paid'),
                pw.SizedBox(height: 10.0),
                pw.Text('Name : $due'),
                pw.SizedBox(height: 10.0),
              ]),
          pw.Divider(),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  'Product',
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 15.0,
                      fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Price',
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 15.0,
                      fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Quantity',
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 15.0,
                      fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Amount',
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 15.0,
                      fontWeight: pw.FontWeight.bold),
                ),
              ]),
          pw.Column(
              children: List.generate(
                  widget.productList.length,
                  (index) => pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: <pw.Widget>[
                            pw.Text(
                              '${widget.productList[index][0]}',
                              style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontSize: 15.0,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${widget.productList[index][1]}',
                              style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontSize: 15.0,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${widget.productList[index][2]}',
                              style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontSize: 15.0,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              '${widget.productList[index][3]}',
                              style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontSize: 15.0,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                          ]))),
          pw.SizedBox(height: 20.0),
          pw.Center(
              child: pw.Text(
            'Total : ${widget.total}',
            style: pw.TextStyle(fontSize: 25.0, fontWeight: pw.FontWeight.bold),
          ))
        ];
      },
    ));
  }

  Future savePdf(admNo) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/asdf.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    due = widget.total;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
          actions: <Widget>[
            Center(child: Text('Total : ${widget.total}')),
            SizedBox(
              width: 20.0,
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'Enter the Customer Name' : null,
                        onSaved: (value) => name = value.trim(),
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value.isEmpty ? 'Enter Mobile Number' : null,
                        onSaved: (value) => mobNo = value.trim(),
                        decoration: InputDecoration(labelText: 'Mobile Number'),
                      ),
                      TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'Enter Address' : null,
                        onSaved: (value) => address = value.trim(),
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            due = widget.total - int.parse(value);
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Enter paid Amount' : null,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          paid = value.trim();
                        },
                        decoration: InputDecoration(labelText: 'Paid Amount'),
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text('Due Amount : $due'),
                          )),
                      MaterialButton(
                        child: Text('Submit'),
                        color: Colors.teal,
                        onPressed: () async {
                          if (validateAndSave()) {
                            await addReceipt(name, mobNo, address, paid, due)
                                .whenComplete(() async {
                              setState(() {
                                _isLoading = true;
                              });
                              writeOnPdf();
                              await savePdf('asdf').whenComplete(() async {
                                Directory documentDirectory =
                                    await getApplicationDocumentsDirectory();

                                String documentPath = documentDirectory.path;

                                String fullPath = "$documentPath/asdf.pdf";
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PdfPreviewScreen(
                                              path: fullPath,
                                            )));
                              });
                            });
                          }
                        },
                      )
                    ],
                  ),
                )));
  }
}

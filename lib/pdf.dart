import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(icon: Icon(Icons.share), onPressed: () {
              FlutterShareMe().shareToWhatsApp(

              );
            }),
          )
        ],
      ),
      path: path,
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mailer/smtp_server.dart';


class GenerateBoardingPass extends StatefulWidget {
  final Map<dynamic, dynamic> bookingData;
  final Map<dynamic, dynamic> flightData;
  final fullName;
  final userPassport;
  final baggageSelection;

  GenerateBoardingPass({
    required this.bookingData,
    required this.flightData,
    required this.fullName,
    required this.userPassport,
    required this.baggageSelection,
  });

  @override
  State<GenerateBoardingPass> createState() => _GenerateBoardingPassState();
}

class _GenerateBoardingPassState extends State<GenerateBoardingPass> {
  late String qrDataString;

  Future<void> _createAndSavePDF() async {
    final pdf = pw.Document();

    final qrPainter = QrPainter(
      data: qrDataString,
      version: QrVersions.auto,
      // size: 200,
    );

//    final pdfImage = PdfImage(
//   pdf.document,
//   image: Uint8List.fromList((await qrPainter.toImageData(2000))!.buffer.asUint8List()),
//   width: 500,
//   height: 500,
// );

Uint8List qrBytes = Uint8List.fromList((await qrPainter.toImageData(2000))!.buffer.asUint8List());

pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(
          pw.MemoryImage(qrBytes),
          width: 500,
          height: 500,
        ),
      );
    },
  ),
);




    final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();

  // Define the file path
  final filePath = '${directory?.path}/boarding_pass.pdf';

  // Create and save the PDF file
  final file = File(filePath);
  print(file);
  await file.writeAsBytes(await pdf.save());

    if (await file.exists()) {
      OpenFile.open(file.path);
      final server = gmail('christopherjun@graduate.utm.my', 'qwe123asd456zxc789'); // Use your Gmail credentials
      final email =  Message()
        ..from = const Address('christopherooi2801@gmail.com')
        ..recipients.add(Address(widget.bookingData['email'] as String)) // Ensure that 'email' is a string
        ..subject ='Boarding Pass'
        ..attachments.add(FileAttachment(file));

    try {
    final sendReport = await send(email, server);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.'+e.message);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }


    }
  }

  @override
  Widget build(BuildContext context) {
    String qrData = 
      "fullName: " + widget.fullName + "\n" +
      "userPassport: " + widget.userPassport + "\n" +
      "baggageSelection: " + widget.baggageSelection;

      // "bookingData": widget.bookingData,
      // "flightData": widget.flightData,
    ;

    qrDataString = json.encode(qrData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarding Pass'),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: QrImageView(
            data: qrDataString,
            version: QrVersions.auto,
            size: 200,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAndSavePDF,
        child: Icon(Icons.file_download),
      ),
    );
  }
}

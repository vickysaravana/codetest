import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmployeeDetail extends StatefulWidget{
  final Map<String, dynamic> employee;
  EmployeeDetail({
    required this.employee,
    Key? key
  }) : super(key: key);
  _EmployeeDetail createState() => _EmployeeDetail();
}

class _EmployeeDetail extends State<EmployeeDetail>{

  Map<String, dynamic> employee = {};

  void initState(){
    super.initState();
    setState(() {
      employee = widget.employee;
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
        title: Text("Employee Detail",style: TextStyle(color: Colors.blueGrey[900]),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25,),
            Hero(
              tag: employee["id"],
              child: Container(
              padding: EdgeInsets.all(8),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                  ),
                ]
              ),
              child: ClipOval(
                child: employee["profile_image"] == null ?
                Container(
                  color: Colors.grey.withOpacity(0.4),
                  child: Icon(Icons.person_sharp, color: Colors.white, size: 100,),
                ) :
                Image.network(
                  employee["profile_image"],
                  filterQuality: FilterQuality.medium,
                  cacheHeight: 200,
                  cacheWidth: 200,
                  fit: BoxFit.fitHeight,
                  loadingBuilder: (context, url, imageChunkEvent){
                    if (imageChunkEvent == null) {
                      return url;
                    }
                    return Center(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: imageChunkEvent.expectedTotalBytes != null ? (imageChunkEvent.cumulativeBytesLoaded / imageChunkEvent.expectedTotalBytes!.toInt()) : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, url, error) => 
                  Container(
                    color: Colors.grey.withOpacity(0.4),
                    child: Icon(Icons.person_off_outlined, color: Colors.white, size: 100,),
                  ),
                ),
              ),
            )
            ),            
            SizedBox(height: 10,),
            Text(
              "${employee['name']}",
              style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 22,
                fontWeight: FontWeight.w500
              ),
            ), 
            SizedBox(height: 15,),           
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                    spreadRadius: 0.2
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User Name",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['username']}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                  Divider(height: 25,thickness: 0.4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['email']}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                  Divider(height: 25,thickness: 0.4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['address']["suite"]}, ${employee['address']["street"]}, ${employee['address']["city"]}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                  Divider(height: 25,thickness: 0.4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['phone'] ?? ''}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                  Divider(height: 25,thickness: 0.4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Website",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['website'] ?? ''}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                  Divider(height: 25,thickness: 0.4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Company",
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 17,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          "${employee['company']?['name'] ?? ''}",
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 17
                          ),
                          textAlign: TextAlign.end,
                        )
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
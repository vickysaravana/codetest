import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/employeeDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget{
  _EmployeeList createState() => _EmployeeList();
}

class _EmployeeList extends State<EmployeeList>{

  bool loading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController filterText = TextEditingController(text: "");
  List<DocumentSnapshot<Map<String, dynamic>>> employeeList = [];
  List<DocumentSnapshot<Map<String, dynamic>>> filteredEmployeeList = [];

  void initState(){
    super.initState();
    setState(() {
      loading = true;
    });
    firestore.collection("employee list").orderBy("name").snapshots().listen((employee) {
      if(employee.docs.isEmpty){
        fetchFromWeb();
      }
      else{
        setState(() {
          employeeList = employee.docs;
        });
        filterEmployee();
        setState(() {
          loading = false;
        });
      }
    });
  }

  void dispose(){
    super.dispose();
  }

  fetchFromWeb()async{
    var url = "http://www.mocky.io/v2/5d565297300000680030a986";
    var httpclient = HttpClient();
    var result;
    try {
      var request = await httpclient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(response.statusCode == HttpStatus.ok){
        result = await response.transform(utf8.decoder).join();
        if(result.isNotEmpty){
          var list = json.decode(result);
          for (int i = 0; i < list.length; i++) {
            var data = list[i];
            firestore.collection("employee list").add(data).catchError((error){
              print(error);
            });
          }
        }
      }
      else{
        print("${response.statusCode}: " + response.statusCode.toString());
      }
    } catch (err) {
      print(err.toString());
    }
  }

  filterEmployee(){
    setState(() {
      filteredEmployeeList = employeeList.where((element) => (element.data()?["name"].toString().toLowerCase().contains(filterText.text.toLowerCase()) ?? false) || (element.data()?["email"].toString().toLowerCase().contains(filterText.text.toLowerCase()) ?? false)).toList();
    });
  }

  closeKeyboard(){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            floating: true,
            pinned: true,
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            title: Text("Code Test", style: TextStyle(color: Colors.blueGrey[900])),
            expandedHeight: AppBar().preferredSize.height + 35,
            collapsedHeight: AppBar().preferredSize.height + 35,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: CupertinoTextField(
                  controller: filterText,
                  onSubmitted: (val){
                    closeKeyboard();
                  },
                  onChanged: (val){
                    filterEmployee();
                  },
                  placeholder: "Search",
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  suffix: filterText.text.isEmpty ? null : IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey,),
                    onPressed: (){
                      setState(() {
                        filterText.text = "";
                        filterEmployee();
                        closeKeyboard();
                      });
                    },
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 0), constraints: BoxConstraints(),
                  ),
                  prefix: IconButton(icon: Icon(Icons.person_search, color: Colors.grey,), onPressed: null, padding: EdgeInsets.fromLTRB(8, 0, 5, 0), constraints: BoxConstraints(),),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              )
            ),
          ),
          loading ?
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Center(
                child: CircularProgressIndicator()
              ),
            ),
          ) :
          filteredEmployeeList.isEmpty ?
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Text("No Data Found for '${filterText.text}...'", style: TextStyle(color: Colors.grey),),
              ),
            ),
          ) :
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, index){
                Map<String, dynamic> data = filteredEmployeeList[index].data() ?? {};
                return Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => EmployeeDetail(employee: data)
                      ));
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(
                                  "${data['name']}",
                                  style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  "${data['email']}".toLowerCase(),
                                  style: TextStyle(
                                    color: Colors.blueGrey[600],
                                    fontSize: 17,
                                    height: 1.4
                                  ),
                                ),
                                data['company'] == null ? SizedBox(height: 0,) :
                                Text(
                                  "Working at ${data['company']?["name"]}",
                                  style: TextStyle(
                                    color: Colors.teal[300],
                                    fontSize: 16,
                                    height: 1.4
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Hero(
                            tag: data["id"],
                            child: Container(
                              height: 70,
                              width: 70,
                              child: ClipOval(
                                child: data["profile_image"] == null ?
                                Container(
                                  color: Colors.grey.withOpacity(0.4),
                                  child: Icon(Icons.person_sharp, color: Colors.white, size: 50,),
                                ) :
                                Image.network(
                                  data["profile_image"],
                                  filterQuality: FilterQuality.medium,
                                  cacheHeight: 200,
                                  cacheWidth: 200,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (context, url, imageChunkEvent){
                                    if (imageChunkEvent == null) {
                                      return url;
                                    }
                                    return Center(
                                      child: SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: CircularProgressIndicator(
                                          value: imageChunkEvent.expectedTotalBytes != null ? (imageChunkEvent.cumulativeBytesLoaded / imageChunkEvent.expectedTotalBytes!.toInt()) : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, url, error) => 
                                  Container(
                                    color: Colors.grey.withOpacity(0.4),
                                    child: Icon(Icons.person_off_outlined, color: Colors.white, size: 50,),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredEmployeeList.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20,),
          )
        ],
      ),
    );
  }
}
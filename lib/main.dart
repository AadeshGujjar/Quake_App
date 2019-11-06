import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main () async{

  Map _data=await getQuake();
  List _features=_data['features'];
  //List _features=_data['features'];
  //print("${_data['features'][0]['properties']['time']}");
  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Quake"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: ListView.builder(
          itemCount: _features.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context,int position)
              {
                if(position.isOdd)
                  return new Divider();

                final index=position~/2;

                return new ListTile(
                  title: new Text(_dateFormat(_features[position]['properties']['time']),//specify
                  style: new TextStyle(fontSize: 15.0,
                  color: Colors.orangeAccent,
                  fontStyle: FontStyle.italic),),

              subtitle: new Text("${_features[position]['properties']['place']}",
                  style: new TextStyle(fontSize: 15.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,),),

                  leading:  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: new Text("${_features[position]['properties']['mag']}", //specify
                    style: new TextStyle(
                      fontSize: 17.5,
                      color:  Colors.white,
                    ),),
                   //   ${_features[index]['features']['properties']['mag']}"
                  ),
                  onTap: (){_showOnTapMessage(context,"M: ${_features[position]['properties']['mag']}-  ${_features[position]['properties']['place']}");},//specify
                );


              }
            ),
      ),

    ),
  ));
}

String _dateFormat(data) {

  DateTime date = new DateTime.fromMillisecondsSinceEpoch(data);
  var format = new DateFormat.yMMMMd("en_US").add_jm();

  var dateString = format.format(date);
  return dateString;

}

void _showOnTapMessage(BuildContext context,String message)
{
  var alert= new AlertDialog(
    title: new Text('Quake'),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
          child: new Text("Ok"))
    ],
  );
  showDialog(context: context,child: alert);
}

Future<Map> getQuake() async{
  String apiUrl='https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);

  return jsonDecode(response.body);
}


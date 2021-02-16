import 'package:flutter/material.dart';
import 'package:share/share.dart';


class GifPage extends StatelessWidget {
  final Map _gifData;

  const GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do gif",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: (){
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_gifData["title"],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(_gifData["images"]["fixed_height"]["url"])),
          ),
        ],
      )
    );
  }
}

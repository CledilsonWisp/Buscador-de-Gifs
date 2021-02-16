import 'dart:convert';
import 'package:transparent_image/transparent_image.dart' as KTransparent;
import 'package:buscadordegifs/UI/detalhes_gif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offSet = 0;

  Future<Map> getGifs() async{
    http.Response response;
    if(_search == null || _search.isEmpty)
       response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=RT95b73iQ0Ugzis3Z6b3y5XQ0f0TJeY5&limit=25&rating=g");
    else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=RT95b73iQ0Ugzis3Z6b3y5XQ0f0TJeY5&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en");

    return json.decode(response.body);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGifs().then((map){
      print(map);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifs Buscador",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: TextField(
             decoration: InputDecoration(
               labelText: "Pesquise aqui!",
               labelStyle: TextStyle(color: Colors.white),
               border: OutlineInputBorder()
             ),
             style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
             textAlign: TextAlign.center,
             onSubmitted: (text){
               setState(() {
                 _search = text;
               });
             },
           ),
         ),

          Expanded(
            child: FutureBuilder(
              future: getGifs(),
              builder: ( context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                   if(snapshot.hasError) return Container();
                   else return _createGifsTablle(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }
  _getCount (List data){
    if(_search == null ) {
      return data.length;
    }else {
      return data.length +1;
    }
  } //Se ele estiver pesquisando, ele retornar o tamanho da lista +1, se não, retorna o tamanho da lista.

  Widget _createGifsTablle(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder( //retorna um gridView builder
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // quantidade de item na lista.
        crossAxisSpacing: 10, // espaço width de cada item
        mainAxisSpacing: 10, // espaço height de cada item
      ),
      itemCount: _getCount(snapshot.data['data']), // quantidade de item que terá, utilizando o getcount e passando uma lista
      itemBuilder: (context, index){
        // builder criador de cada item.
       if(_search == null || index < snapshot.data["data"].length || _search.isEmpty)
         // se algum item não estiver pesquisado, ou o index for menor que o tamanho da lista ele retorna um item abaixo;
           return GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.memoryNetwork(
                placeholder: KTransparent.kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                fit: BoxFit.cover,
                height: 300,
              )
            ),
             onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index])) );
             },
             onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
             },
         );
       else  // se algum item não estiver como no If acima, ele retorna esse item abaixo;
         return Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10),
             color: Colors.orange
           ),
           child: GestureDetector(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.add,color: Colors.white,size: 70,),
                 Text("Carregar mais...",style: TextStyle(color: Colors.black,fontSize: 22),),
               ],
             ),
             onTap: (){
               setState(() {
                 _offSet += 19;  // setState para mudar a quantidade de item no off set a ser adicionado.
               });
             },
           ),
         );
      },
    );
  }
}

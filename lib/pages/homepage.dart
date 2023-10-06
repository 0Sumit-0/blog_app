import 'package:blogtask/helper/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import '../models/blog.dart';
import 'detailScreen.dart';
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final dbHelper = DBHelper();

  final Connectivity _connectivity = Connectivity();


  late Future<List<Blog>> blogList;

  bool isDataOnce=false;


  @override
  void initState() {
    super.initState();

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      handleConnectivityChange(result);
    });
  }

  Future<bool> isInternetAvailable() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }




  void handleConnectivityChange(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        break;
      case ConnectivityResult.wifi:
      setState(() {});
        break;
      case ConnectivityResult.mobile:
      setState(() {});
        break;
    }
  }

  Future<List<Blog>> fetchBlogs()async{
    const  String url='https://intent-kit-16.hasura.app/api/rest/blogs';
    const  String adminSecret='32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    final hasInternet = await isInternetAvailable();


    if(hasInternet && !isDataOnce){

      try{
        final response=await http.get(Uri.parse(url),headers:{
          'x-hasura-admin-secret': adminSecret,
        });
        if(response.statusCode==200){
          final  jsonData = json.decode(response.body);
          final blogList= Blog.fromJsonList(jsonData);
          insertBlogs(blogList);
          isDataOnce=true;
          return blogList;

        }else{
          if (kDebugMode) {
            print('Request failed with status code: ${response.statusCode}');
            print('Response data: ${response.body}');
          }

          throw 'Request failed with status code: ${response.statusCode}';
        }
      }catch(e){
        if (kDebugMode) {
          print('Error:$e');
        }
        throw e.toString();
      }
    }else{
      try {
        final blogList = await DBHelper().readAllBlogs();
        return blogList;
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching data from the database: $e');
        }
        throw e.toString();
      }
    }
  }


  Future<void> insertBlogs(List<Blog> blogList) async {
    for (final blog in blogList) {
      final newBlog = await dbHelper.create(blog);
      if (kDebugMode) {
        print('Inserted Blog ID: ${newBlog.id}');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.blue,
        onPressed: (){
          Get.defaultDialog(
            title: "App in the developing Phase!",
            middleText: "....Stay Tuned...",
            backgroundColor: Colors.black45,
            titleStyle: const TextStyle(color: Colors.white60),
            middleTextStyle: const TextStyle(color: Colors.white54),
            radius: 30,
          );
        },
        child: const Icon(Icons.chat_bubble_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: fetchBlogs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final blogData=snapshot.data!;
              return ListView.builder(
                itemCount: blogData.length ,
                itemBuilder: (BuildContext context, int index) {
                  final blog=blogData[index];
                  final uniquetag='${blog.id}_heroTag';
                  return InkWell(
                    onTap: (){
                      Get.to(() => DetailScreen(uniquetag: uniquetag,myblog:blog));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white10,
                          ),

                          child: Column(
                            children: [
                              SizedBox(
                                width: width/1.2,
                                height: height/4,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(blog.image,width: double.infinity/1.08,height: height/1.2,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) {
                                        return const Center(child:  Text('Image not available',style: TextStyle(fontSize: 20),));
                                      },),
                                    ),
                                    Positioned(
                                      right: 5,
                                      bottom: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: InkWell(
                                          child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                          child: Icon(Icons.favorite,size: blog.isFavourite ?40:30,color: blog.isFavourite ? Colors.red : Colors.white54)),
                                          onTap: (){
                                            setState(() {
                                              blog.isFavourite = !blog.isFavourite;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: width/1.01,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: Text(
                                        blog.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width > 500 ?60 : MediaQuery.of(context).size.width < 300 ?40:25,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              Future.delayed(Duration.zero, () {
                Get.defaultDialog(
                  title: "Error Occured !!",
                  middleText: "Failed to fetch blog data.\n${snapshot.error}\nPlease try again later. ",
                  backgroundColor: Colors.white10,
                  titleStyle: const TextStyle(color: Colors.white70),
                  middleTextStyle: const TextStyle(color: Colors.white54),
                  radius: 30,
                );
              });
              return const SizedBox.shrink();
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    );
  }
}


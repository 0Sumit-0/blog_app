import 'package:flutter/material.dart';

import '../models/blog.dart';

class DetailScreen extends StatefulWidget {
  final String? uniquetag;
  final Blog myblog;
  const DetailScreen({Key? key, required this.uniquetag, required this.myblog})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.uniquetag!,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: width / 1.1,
                      height: height / 3,
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.myblog.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Text('Image not available',style: TextStyle(fontSize: 20),));
                            },
                          ),
                        ),
                        Positioned(
                          left: 5,
                          top: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              child: const Icon(Icons.bookmark,size: 40,color: Colors.white54,),
                              onTap: (){},
                            ),
                          ),
                        ),
                        Positioned(
                          right: 50,
                          bottom: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:InkWell(
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(Icons.favorite,size: widget.myblog.isFavourite ?40:30,color: widget.myblog.isFavourite ? Colors.red : Colors.white54)),
                              onTap: (){
                                setState(() {
                                  widget.myblog.isFavourite = !widget.myblog.isFavourite;
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              child: const Icon(Icons.share_rounded,size: 35,color: Colors.white54,),
                              onTap: (){},
                            ),
                          ),
                        ),

                       ]
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              widget.myblog.title,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width > 500
                                    ? 50
                                    : MediaQuery.of(context).size.width < 300
                                        ? 30
                                        : 20,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Author: Name",
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width > 500
                                  ? 40
                                  : MediaQuery.of(context).size.width < 300
                                  ? 30
                                  : 18,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '''\n\nThe Description of the blog is only for the demo purpose.\n\n''',
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w500,
                                fontSize: MediaQuery.of(context).size.width > 500
                                    ? 40
                                    : MediaQuery.of(context).size.width < 300
                                    ? 30
                                    : 18,
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
        ),
      ),
    );
  }
}

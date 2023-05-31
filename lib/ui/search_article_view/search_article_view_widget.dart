import 'package:flutter/material.dart';
import '../../location_service.dart';

class SearchArticleView extends StatefulWidget {
  const SearchArticleView({Key? key}) : super(key: key);

  @override
  State<SearchArticleView> createState() => _SearchArticleViewState();
}

class _SearchArticleViewState extends State<SearchArticleView> {

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Search"),
                centerTitle: true,
            ),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            Row(
                                children: <Widget>[
                                    Text(
                                        "Current user location",
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
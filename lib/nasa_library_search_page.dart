import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NasaLibrarySearchPage extends StatefulWidget {
  const NasaLibrarySearchPage({super.key});

  @override
  State<NasaLibrarySearchPage> createState() => _NasaLibrarySearchPageState();
}

class _NasaLibrarySearchPageState extends State<NasaLibrarySearchPage> {
  final TextEditingController _searchTextController = TextEditingController();
  String _searchText = "";
  Future<SearchResultCollection> fetchSearchResult() async {
    var response = await http
        .get(Uri.parse('https://images-api.nasa.gov/search?q=$_searchText'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print(jsonResponse);
      return SearchResultCollection.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      throw Exception('Waiting for search text...');
    } else {
      throw Exception('${response.statusCode} to load search result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa library'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: TextField(
                controller: _searchTextController,
                onChanged: (text) => setState(() => _searchText = text),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            FutureBuilder(
              future: fetchSearchResult(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  var apiData = snapshot.data!;
                  SearchResultCollection searchResultCollection = apiData;
                  var items = searchResultCollection.results;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        SearchResultItem searchResultItem = items[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              SearchResultAmountBlock(
                                  resultAmount:
                                      searchResultCollection.totalHits),
                            SearchResultItemTile(
                                searchResultItem: searchResultItem),
                          ],
                        );
                      },
                      childCount: items.length,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Text('Error: ${snapshot.error}'));
                }
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultCollection {
  SearchResultCollection(
      {required this.totalHits,
      required this.nextPageUrl,
      required this.results});
  int totalHits;
  String nextPageUrl;
  List<SearchResultItem> results = [];

  factory SearchResultCollection.fromJson(Map<String, dynamic> json) {
    json = json['collection'];
    var links = json['links'] as List;
    String nextPageUrl = '';
    for (int i = 0; i < links.length; i++) {
      var link = links[i];
      if (link['rel'] == 'next') {
        nextPageUrl = link['href'];
        break;
      }
    }
    var resultsFromJson = json['items'] as List;
    List<SearchResultItem> resultList =
        resultsFromJson.map((i) => SearchResultItem.fromJson(i)).toList();
    //

    return SearchResultCollection(
        totalHits: json['metadata']['total_hits'],
        nextPageUrl: nextPageUrl,
        results: resultList);
  }
}

class SearchResultAmountBlock extends StatelessWidget {
  const SearchResultAmountBlock({super.key, required this.resultAmount});
  final int resultAmount;

  @override
  Widget build(BuildContext context) {
    // add comma to number string
    String numberString = resultAmount.toString();
    RegExp pattern = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    replace(m) => '${m[1]},';
    String formattedNumber = numberString.replaceAllMapped(pattern, replace);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        'About $formattedNumber results',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class SearchResultItem {
  SearchResultItem(
      {required this.previewImageUrl,
      required this.title,
      required this.nasaId,
      required this.description,
      required this.media});
  String? previewImageUrl;
  String title;
  String nasaId;
  String description;
  String media;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    // previewImageUrl
    String? previewImageUrl;
    try {
      var linkList = json['links'] as List;
      for (int i = 0; i < linkList.length; i++) {
        var link = linkList[i];
        if (link['render'] == 'image') {
          previewImageUrl = link['href'];
        }
      }
    } catch (e) {
      // this item might be audio
    }

    var dataList = json['data'] as List;
    var data = dataList[0];
    String title = data['title'];
    String nasaId = data['nasa_id'];
    String description = data['description'];
    String media = data['media_type'];

    return SearchResultItem(
        previewImageUrl: previewImageUrl,
        title: title,
        nasaId: nasaId,
        description: description,
        media: media);
  }
}

class SearchResultItemTile extends StatelessWidget {
  const SearchResultItemTile({super.key, required this.searchResultItem});
  final SearchResultItem searchResultItem;

  @override
  Widget build(BuildContext context) {
    return Card(color: Color.fromARGB(255, 231, 218, 119),
      child: Column(
        children: [
          if (searchResultItem.previewImageUrl != null)
            Image.network(
              searchResultItem.previewImageUrl!,
              height: 200,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    searchResultItem.title,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
              MediaIcon(mediaType: searchResultItem.media)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              searchResultItem.description,
              maxLines: 10,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class MediaIcon extends StatelessWidget {
  const MediaIcon({super.key, required this.mediaType});
  final String mediaType;

  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.orange;
    return mediaType == 'image'
        ? Icon(
            Icons.image,
            color: iconColor,
          )
        : mediaType == 'audio'
            ? Icon(
                Icons.audiotrack,
                color: iconColor,
              )
            : mediaType == 'video'
                ? Icon(
                    Icons.video_collection,
                    color: iconColor,
                  )
                : Text(mediaType);
  }
}




// Media getMedia(String name) {
//   if (name == 'video') {
//     return video;
//   } else {
//     return image;
//   }
// }

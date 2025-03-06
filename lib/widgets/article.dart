import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'article_model.dart';
import 'article_service.dart';
import 'package:url_launcher/link.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final ArticleService _articleService = ArticleService();
  late Future<List<Article>> _articlesFuture;

  // Predefined list of colors for the first 5 cards
  final List<Color> _cardColors = [
    Color(0xFFCBF3F0), // Color for the first article card
    Color(0xFFECAD5A), // Color for the second article card
    Color(0xFF2EC4B6), // Color for the third article card
    Color(0xFFCBF3F0), // Color for the fourth article card
    Color(0xFFECAD5A), // Color for the fifth article card
  ];

  @override
  void initState() {
    super.initState();
    _articlesFuture = _articleService
        .fetchArticles(); // Fetch articles with a focus on nutrition and food
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No articles found'));
        } else {
          final articles = snapshot.data!;
          final displayedArticles =
              articles.take(5).toList(); // Get the first 5 articles

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 20),
                child: Text(
                  'Recommended Articles',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayedArticles.length,
                  itemBuilder: (context, index) {
                    final article = displayedArticles[index];
                    // Use predefined colors for the first 5 cards
                    return ArticleCard(
                      article: article,
                      cardColor: _cardColors[index],
                      isFifthCard: index ==
                          4, // Pass a flag to indicate if it's the fifth card
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final Color cardColor;
  final bool isFifthCard;

  const ArticleCard(
      {required this.article,
      required this.cardColor,
      required this.isFifthCard,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16), // Spacing between article cards
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: cardColor, // Use the passed color
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // Set the title color for the 5th card, otherwise use black
                  color: isFifthCard ? Colors.black : Colors.black,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                article.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black, // Make description text black
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Link(
                uri: Uri.parse(article.url),
                target: LinkTarget.defaultTarget,
                builder: (context, openLink) => TextButton(
                  onPressed: openLink,
                  child: Text(
                    'Read More',
                    style: TextStyle(
                        color: Colors.blueAccent), // Button text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

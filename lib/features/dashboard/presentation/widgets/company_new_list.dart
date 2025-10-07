import 'package:flutter/material.dart';

import 'news_card.dart';

class CompanyNewsList extends StatelessWidget {
  const CompanyNewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final newsList = [
      {
        "image": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
        "title": "New Project Launch"
      },
      {
        "image": "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2",
        "title": "New Office Opening Soon"
      },
      {
        "image": "https://images.unsplash.com/photo-1461749280684-dccba630e2f6",
        "title": "Team Building Event"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Company News",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        
        SizedBox(
          height: 150, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal, 
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(), 
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return NewsCard(
                imageUrl: news["image"]!,
                title: news["title"]!,
              );
            },
          ),
        ),
      ],
    );
  }
}
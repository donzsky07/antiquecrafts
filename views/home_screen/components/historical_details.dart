
import 'package:flutter/material.dart';

class HistoricalDetails extends StatelessWidget {
  final dynamic data;

  const HistoricalDetails({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),

      body: CustomScrollView(
        slivers: [

          // APP BAR IMAGE
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Color.fromRGBO(48, 176, 199, 1) ,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                data['p_name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              background: Stack(
                fit: StackFit.expand,
                children: [

                  Image.network(
                    data['p_imgs'][0],
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                         Colors.black.withValues(alpha: 0.7)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // CULTURAL TAG
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "ANTIQUE HERITAGE COLLECTION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // PRODUCT NAME
                  Text(
                    data['p_name'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    data['origin_place'] ?? 'Antique, Philippines',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ARTISAN CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                         color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.brown.shade200,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Featured Artisan",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                data['featured_artist'] ?? 'Unknown Artisan',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // HISTORY TITLE
                  const Text(
                    "Historical Background",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // HISTORY CONTENT
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['historical_background'] ??
                          'No historical background available.',
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // CULTURAL IMPORTANCE
                  const Text(
                    "Cultural Importance",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.brown,
                          size: 28,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            data['cultural_importance'] ??
                                'This product represents the artistry and heritage of Antique Province.',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // MUSEUM NOTE
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.brown.shade200,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [

                        Icon(
                          Icons.museum,
                          color: Colors.brown.shade700,
                          size: 35,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            'Preserving local heritage through handcrafted artistry from Antique, Philippines.',
                            style: TextStyle(
                              color: Colors.brown.shade800,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

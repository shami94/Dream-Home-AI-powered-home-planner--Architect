import 'package:dreamhome_architect/common_widgets.dart/custom_button.dart';
import 'package:dreamhome_architect/features/home_plan/feature_card.dart';
import 'package:dreamhome_architect/util/format_function.dart';
import 'package:flutter/material.dart';

class FloorCard extends StatelessWidget {
  final Map cardData;
  final Function() onEdit, onDelete;
  const FloorCard({
    super.key,
    required this.cardData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          if (cardData['image_url'] != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                cardData['image_url'],
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 207),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatValue(cardData['name']),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formatValue(cardData['description']),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          if (cardData['bedrooms'] != 0)
                            FeatureCard(
                              text:
                                  '${formatInteger(cardData['bedrooms'])} Bed',
                              icon: Icons.bed,
                            ),
                          if (cardData['bathrooms'] != 0)
                            FeatureCard(
                              icon: Icons.bathtub,
                              text:
                                  '${formatInteger(cardData['bathrooms'])} Bath',
                            ),
                          FeatureCard(
                            icon: Icons.directions_car,
                            text: "1 Parking",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: 'Edit',
                              color: Colors.orange,
                              onPressed: onEdit,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomButton(
                              label: 'Delete',
                              color: Colors.red,
                              onPressed: onDelete,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

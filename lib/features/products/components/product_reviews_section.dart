import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

/// Data class for a customer review.
class ProductReview {
  final String id;
  final String author;
  final double rating;
  final String date;
  final String comment;
  final bool isVerified;
  int helpfulCount;
  bool isHelpfulMarked;

  ProductReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.date,
    required this.comment,
    this.isVerified = true,
    this.helpfulCount = 0,
    this.isHelpfulMarked = false,
  });
}

/// Initial mock reviews for products.
List<ProductReview> getMockProductReviews() => [
  ProductReview(
    id: 'rev_1',
    author: 'Sophia Chen',
    rating: 5.0,
    date: '2 days ago',
    comment:
        'Absolutely love this item! The fabric quality is exceptional and it fits true to size. Fast delivery with cute panda packaging 🐼.',
    isVerified: true,
    helpfulCount: 14,
  ),
  ProductReview(
    id: 'rev_2',
    author: 'David Kim',
    rating: 5.0,
    date: '1 week ago',
    comment:
        'Exceeded my expectations. The stitching is clean and color matches the pictures perfectly. Would definitely buy again!',
    isVerified: true,
    helpfulCount: 9,
  ),
  ProductReview(
    id: 'rev_3',
    author: 'Elena Rostova',
    rating: 4.0,
    date: '2 weeks ago',
    comment:
        'Very comfortable and stylish. Great for casual everyday wear. Consider ordering one size up if you like a looser fit.',
    isVerified: true,
    helpfulCount: 5,
  ),
];

/// Interactive Customer Reviews and Rating Breakdown component.
class ProductReviewsSection extends StatefulWidget {
  final double rating;
  final int reviewsCount;
  final List<ProductReview> reviews;
  final VoidCallback onWriteReview;

  const ProductReviewsSection({
    super.key,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
    required this.onWriteReview,
  });

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Reviews',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.reviews.length} verified ratings',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: widget.onWriteReview,
              icon: const Icon(LucideIcons.edit2, size: 14),
              label: const Text('Write a Review'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Rating Score Card with Progress Bars
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.homeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              // Average score block
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '96% recommend',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 70,
                width: 1,
                color: isDark ? AppColors.darkBorder : AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              // Star Distribution Progress Bars
              const Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _StarProgressBar(star: 5, percentage: 0.78),
                    SizedBox(height: 4),
                    _StarProgressBar(star: 4, percentage: 0.15),
                    SizedBox(height: 4),
                    _StarProgressBar(star: 3, percentage: 0.04),
                    SizedBox(height: 4),
                    _StarProgressBar(star: 2, percentage: 0.02),
                    SizedBox(height: 4),
                    _StarProgressBar(star: 1, percentage: 0.01),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Reviews List
        for (final review in widget.reviews)
          _ReviewCard(
            review: review,
            onHelpfulTap: () {
              setState(() {
                if (review.isHelpfulMarked) {
                  review.helpfulCount--;
                  review.isHelpfulMarked = false;
                } else {
                  review.helpfulCount++;
                  review.isHelpfulMarked = true;
                }
              });
            },
          ),
      ],
    );
  }
}

class _StarProgressBar extends StatelessWidget {
  final int star;
  final double percentage;

  const _StarProgressBar({required this.star, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Text(
          '$star★',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 5,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFF59E0B),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 28,
          child: Text(
            '${(percentage * 100).toInt()}%',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  final VoidCallback onHelpfulTap;

  const _ReviewCard({required this.review, required this.onHelpfulTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar circle with author initial
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  review.author.isNotEmpty ? review.author[0] : 'U',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            review.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (review.isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 10,
                                  color: Color(0xFF10B981),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: i < review.rating.floor()
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: onHelpfulTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        review.isHelpfulMarked
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 13,
                        color: review.isHelpfulMarked
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Helpful (${review.helpfulCount})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: review.isHelpfulMarked
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: review.isHelpfulMarked
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Interactive Write-a-Review Bottom Sheet Modal
class WriteReviewModal extends StatefulWidget {
  final ValueChanged<ProductReview> onSubmit;

  const WriteReviewModal({super.key, required this.onSubmit});

  @override
  State<WriteReviewModal> createState() => _WriteReviewModalState();
}

class _WriteReviewModalState extends State<WriteReviewModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  int _selectedRating = 5;

  static const List<String> _ratingLabels = [
    '',
    'Poor 😞',
    'Fair 😐',
    'Good 🙂',
    'Very Good 😊',
    'Excellent! 🐼❤️',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final review = ProductReview(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      author: _nameController.text.trim().isEmpty
          ? 'Happy Customer'
          : _nameController.text.trim(),
      rating: _selectedRating.toDouble(),
      date: 'Just now',
      comment: _commentController.text.trim(),
      isVerified: true,
      helpfulCount: 0,
    );

    widget.onSubmit(review);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Write a Review ✍️',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Interactive Stars
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          iconSize: 34,
                          onPressed: () =>
                              setState(() => _selectedRating = starIndex),
                          icon: Icon(
                            starIndex <= _selectedRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: starIndex <= _selectedRating
                                ? const Color(0xFFF59E0B)
                                : AppColors.textMuted,
                          ),
                        );
                      }),
                    ),
                    Text(
                      _ratingLabels[_selectedRating],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Name input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'e.g. Alex Doe',
                  prefixIcon: const Icon(LucideIcons.user, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Review comments input
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  hintText: 'What did you like or dislike about this product?',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 5) {
                    return 'Please write at least 5 characters for your review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

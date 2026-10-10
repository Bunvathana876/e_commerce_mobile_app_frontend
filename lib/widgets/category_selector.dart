import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Item data class for category selector.
class CategoryItem {
  final String id;
  final String label;
  final IconData icon;

  const CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// “Shop by category” horizontal list: All, Fashion, Shoes, Electronics.
class CategorySelector extends StatelessWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onSeeAll;

  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.onSeeAll,
  });

  static const List<CategoryItem> categories = [
    CategoryItem(id: 'all', label: 'All', icon: Icons.grid_view_rounded),
    CategoryItem(
      id: 'fashion',
      label: 'Fashion',
      icon: Icons.checkroom_rounded,
    ),
    CategoryItem(
      id: 'shoes',
      label: 'Shoes',
      icon: Icons.roller_skating_outlined,
    ),
    CategoryItem(
      id: 'electronics',
      label: 'Electronics',
      icon: Icons.headphones_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Shop by category',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.getTextPrimary(context),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: 'View all categories',
                child: InkWell(
                  onTap: () {
                    if (onSeeAll != null) {
                      onSeeAll!();
                    } else {
                      onCategorySelected('all');
                    }
                  },
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 15,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),

        // Horizontal category chips
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  _buildCategoryChip(context, categories[i]),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(BuildContext context, CategoryItem cat) {
    final isSelected = cat.id == selectedCategoryId;
    return Semantics(
      label: 'Category ${cat.label}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => onCategorySelected(cat.id),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.getCardBackground(context),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary
                  : AppTheme.getBorder(context),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppTheme.primary.withValues(alpha: 0.28)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                cat.icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : AppTheme.getTextSecondary(context),
              ),
              const SizedBox(width: 5),
              Text(
                cat.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

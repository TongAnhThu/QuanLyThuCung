import 'package:flutter/material.dart';
import '../../../theme/home_colors.dart';

/// ===== Combo card: hiện rõ combo gồm gì =====
class ComboMenuCard extends StatelessWidget {
  const ComboMenuCard({
    super.key,
    required this.title,
    required this.items,
    required this.priceText,
    required this.onTap,
  });

  final String title;
  final List<String> items;
  final String priceText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final show = items.take(4).toList();
    final remain = items.length - show.length;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Price
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: HomeColors.primaryDark.withOpacity(0.12),
                    child: const Icon(
                      Icons.spa_outlined,
                      color: HomeColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: HomeColors.primaryDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Items (rõ combo gồm gì)
              ...show.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: HomeColors.primaryDark,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[850],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (remain > 0)
                Text(
                  '+ $remain mục nữa',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[800],
                  ),
                ),

              const SizedBox(height: 10),

              // CTA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: HomeColors.primaryDark.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Nhấn để đặt lịch',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: HomeColors.primaryDark,
                    ),
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

/// ===== Dịch vụ lẻ card (chữ rõ) =====
class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailingTop,
    required this.trailingBottom,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailingTop;
  final String trailingBottom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: HomeColors.primaryDark.withOpacity(0.12),
                child: Icon(icon, color: HomeColors.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trailingTop,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: HomeColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    trailingBottom,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Filter chip button =====
class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white,
          border: Border.all(color: HomeColors.primaryDark.withOpacity(0.30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: HomeColors.primaryDark),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 4),
            const Icon(
              Icons.expand_more,
              size: 18,
              color: HomeColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== Simple picker sheet =====
class PickerItem {
  const PickerItem({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;
}

class SimplePickerSheet extends StatelessWidget {
  const SimplePickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
  });

  final String title;
  final List<PickerItem> items;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final it = items[i];
                  final isSel = it.value == selectedValue;

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, it.value),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? HomeColors.primaryDark
                              : Colors.black.withOpacity(0.08),
                        ),
                        color: isSel
                            ? HomeColors.primaryDark.withOpacity(0.06)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: HomeColors.primaryDark.withOpacity(
                              0.12,
                            ),
                            child: Icon(it.icon, color: HomeColors.primaryDark),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              it.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (isSel)
                            const Icon(
                              Icons.check_circle,
                              color: HomeColors.primaryDark,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

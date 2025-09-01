import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/widgets/screens/faq_section.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:pro_kariera/widgets/screens/header.dart';
import 'package:pro_kariera/widgets/screens/hero_section.dart';
import 'package:pro_kariera/widgets/screens/about_me.dart';
import 'package:pro_kariera/widgets/screens/services.dart';
import 'package:pro_kariera/widgets/screens/avgs.dart';
import 'package:pro_kariera/widgets/screens/how_i_work.dart';
import 'package:pro_kariera/widgets/screens/testimonials.dart';
import 'package:pro_kariera/widgets/screens/contact.dart';
import 'package:pro_kariera/funkcional/animated_fab_menu.dart';
import 'package:pro_kariera/widgets/screens/preis_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  late final List<Widget> _sections; // ← инициализируем позже

  static const List<String> _sectionIds = [
    'hero',
    'about',
    'services',
    'price',
    'avgs',
    'how',
    'testimonials',
    'faq',
    'contact',
  ];

  @override
  void initState() {
    super.initState();

    _sections = [
      HeroSection(onBookPressed: () => _scrollToSectionById('contact')),
      const AboutMe(),
      const Services(),
      // передаём колбэк после создания инстанса state (теперь можно)
      PriceSection(onBookPressed: () => _scrollToSectionById('contact')),
      const Avgs(),
      const HowIWork(),
      const Testimonials(),
      const FaqSection(),
      const ContactSection(),
    ];
  }

  void _scrollToSectionById(String id) {
    final idx = _sectionIds.indexOf(id);
    if (idx != -1) {
      _itemScrollController.scrollTo(
        index: idx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
              Header(onItemSelected: _scrollToSectionById),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemCount: _sections.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: _sections[index],
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: const AnimatedFabMenu(),
        );
      },
    );
  }
}

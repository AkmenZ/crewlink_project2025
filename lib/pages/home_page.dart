import 'dart:async';

import 'package:crewlink/models/advert.dart';
import 'package:crewlink/providers/advert_data_provider.dart';
import 'package:crewlink/widgets/advert_card.dart';
import 'package:crewlink/widgets/frosted_date_picker.dart';
import 'package:crewlink/widgets/frosted_text_field.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.8);

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;
      final nextPage = _pageController.page!.round() + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // show add event group form
  void _showAddEventGroupModal() {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.80),
      barrierColor: Colors.black.withValues(alpha: 0.70),
      topRadius: const Radius.circular(24.0),
      elevation: 8.0,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Create Event Group'),
          backgroundColor: Colors.transparent,
          leading: SizedBox.shrink(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        body: FormBuilder(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 16.0,
              children: [
                Image.asset(
                  'assets/images/friends.png',
                  height: 200.0,
                ),
                FrostedTextField(name: 'title', label: 'Title'),
                FrostedTextField(name: 'location', label: 'Location/Venue'),
                Row(
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: FrostedDatePicker(
                          name: 'dateTimeFrom', label: 'From'),
                    ),
                    Text('-'),
                    Expanded(
                      child: FrostedDatePicker(
                          name: 'dateTimeTo', label: 'To'),
                    ),
                  ],
                ),
                FrostedTextField(
                  name: 'description',
                  label: 'Description',
                  minLines: 3,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: Text('Create Event Group'),
          onPressed: () {},
        ),
      ),
    );
  }

  // TODO handle submit

  @override
  Widget build(BuildContext context) {
    final advertsAsyncValue = ref.watch(advertsProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          spacing: 10.0,
          children: [
            Text(
              'Popular this summer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.34,
              child: advertsAsyncValue.when(
                data: (adverts) {
                  if (adverts.isEmpty) {
                    return const Center(child: Text('No adverts available'));
                  }
                  return PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      final advert = adverts[index % adverts.length];
                      return AdvertCard(advert: advert);
                    },
                  );
                },
                loading: () {
                  return Skeletonizer(
                    enabled: true,
                    child: PageView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final advert = Advert(); // empty advert
                        return AdvertCard(advert: advert);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return const Center(child: Text('Error loading adverts'));
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _showAddEventGroupModal();
              },
              child: const Text('Create Event Group'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

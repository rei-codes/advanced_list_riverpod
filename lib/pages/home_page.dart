import 'dart:async';
import 'dart:developer';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listProvider = StateProvider<List<String>>((_) {
  return List.generate(5, (_) => Faker().person.firstName());
});

final indexProvider = Provider<int>((_) {
  throw UnimplementedError();
});

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log('### Page build ###');
    return Scaffold(
      appBar: AppBar(),
      body: const _ListView(),
    );
  }
}

class _ListView extends ConsumerStatefulWidget {
  const _ListView();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ListViewState();
}

class __ListViewState extends ConsumerState<_ListView> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('### _ListView build ###');
    return ListView.builder(
      itemCount: ref.watch(listProvider.select((e) => e.length)),
      itemBuilder: (_, index) {
        return ProviderScope(
          overrides: [indexProvider.overrideWith((_) => index)],
          child: const _ListItem(),
        );
      },
    );
  }
}

class _ListItem extends ConsumerWidget {
  const _ListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.read(indexProvider);
    final item = ref.watch(listProvider.select((e) => e[index]));
    log('$index - $item');
    return ElevatedButton(
      child: Text(item),
      onPressed: () {
        final list = ref.read(listProvider);
        list[index] = Faker().person.firstName();
        ref.read(listProvider.notifier).state = [...list];
      },
    );
  }
}

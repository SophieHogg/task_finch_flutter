import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/empty_state.dart';
import 'package:task_finch/components/task_item.dart';
import 'package:task_finch/theming/constants.dart';

import '../data/database.dart';
import '../dialogs/filter_dialog.dart';
import '../main.dart';
import '../task_filter_provider.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorities = useState<Set<Priority>>(Priority.values.toSet());
    final statuses = useState<Set<CompletionStatus>>(
      CompletionStatus.values.toSet(),
    );
    final searchTerm = useState<String>('');
    final searchTermController = useTextEditingController();
    final filteredTasks = ref.watch(
      taskByFilter((searchTerm.value, priorities.value, statuses.value)),
    );
    final hasActiveFilters =
        priorities.value.length != 3 || statuses.value.length != 2;
    final hasSearched = searchTerm.value.isNotEmpty || hasActiveFilters;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTermController,
                    onChanged: (term) => searchTerm.value = term,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon:
                          searchTerm.value.isNotEmpty
                              ? FittedBox(
                                child: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchTerm.value = '';
                                    searchTermController.text = '';
                                  },
                                ),
                              )
                              : null,
                    ),
                  ),
                ),

                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    final filters = await showDialog<
                      ({
                        Set<CompletionStatus> filterStatus,
                        Set<Priority> filterPriority,
                      })
                    >(
                      context: context,
                      builder: (dialogContext) {
                        return FilterDialog(
                          passedPriorities: priorities.value,
                          passedStatuses: statuses.value,
                        );
                      },
                    );
                    if (filters != null) {
                      priorities.value = filters.filterPriority;
                      statuses.value = filters.filterStatus;
                    }
                  },
                  icon: Badge(
                    smallSize: 8,
                    isLabelVisible: hasActiveFilters,
                    child: Icon(Icons.filter_alt, color: baseColour),
                  ),
                ),
              ],
            ),
            Expanded(
              child:
                  hasSearched
                      ? switch (filteredTasks) {
                        AsyncLoading<List<Task>>() => EmptyState(
                          text: 'Loading ...',
                        ),
                        AsyncData<List<Task>>() =>
                          filteredTasks.value.isNotEmpty
                              ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (final task in filteredTasks.value)
                                      ProviderScope(
                                        overrides: [
                                          currentTask.overrideWithValue(task),
                                        ],
                                        child: const TaskItem(
                                          isOnHomeScreen: true,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                              : EmptyState(text: 'No results found'),
                        AsyncError<List<Task>>() => EmptyState(text: ':( rip'),
                      }
                      : EmptyState(text: 'Filter or enter a search term'),
            ),
          ],
        ),
      ),
    );
  }
}

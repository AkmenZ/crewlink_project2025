import 'package:crewlink/providers/event_group_provider.dart';
import 'package:crewlink/services/event_group_service.dart';
import 'package:crewlink/widgets/custom_snackbar.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get current user
    final user = FirebaseAuth.instance.currentUser;
    // get list of groups user is a member of
    final eventGroupsAsyncValue =
        ref.watch(getEventGroupsForMemberProvider(user!.uid));

    // define themes
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // logout
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                spacing: 20.0,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.primary,
                    radius: 40.0,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : NetworkImage(
                            'https://icons.veryicon.com/png/o/miscellaneous/rookie-official-icon-gallery/225-default-avatar.png'), // default avatar image
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Anonymous User',
                        style: textTheme.displaySmall,
                      ),
                      Text(user.email ?? 'No email'),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Text(
              'My Upcoming Events',
              style: textTheme.headlineSmall,
            ),
            // list of event groups
            Consumer(
              builder: (context, ref, child) {
                return eventGroupsAsyncValue.when(
                  data: (eventGroups) {
                    if (eventGroups.isEmpty) {
                      return const Center(child: Text('No event groups found'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: eventGroups.length,
                      itemBuilder: (context, index) {
                        final eventGroup = eventGroups[index];
                        return Dismissible(
                          key: Key(eventGroup.id),
                          background: Container(
                            color: theme.errorContainer,
                            child: const Icon(Icons.delete),
                          ),
                          confirmDismiss: (direction) async {
                            // shows dialog and returns true or false to confirm action
                            final shouldDismiss = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Leave Event Group'),
                                  content: const Text(
                                      'Are you sure you want to leave this event group?'),
                                  actions: [
                                    // cancel and return
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    // leave group
                                    TextButton(
                                      onPressed: () async {
                                        final eventGroupService = EventGroupService();
                                        final success = await eventGroupService.deleteMemberFromGroup(
                                          groupId: eventGroup.id,
                                          userId: user.uid,
                                        );
                                        if (success) {
                                          // invalidate provider to refresh the list
                                          ref.invalidate(getEventGroupsForMemberProvider(user.uid));
                                          // show success message
                                          if (context.mounted) {
                                            CustomSnackbar.showSuccess(
                                              context,
                                              'You have successfully left the event group',
                                            );
                                            Navigator.of(context).pop(true);
                                          }
                                        } else {
                                          // show error message
                                          if (context.mounted) {
                                            CustomSnackbar.showError(
                                              context,
                                              'Error leaving event group',
                                            );
                                            Navigator.of(context).pop(false);
                                          }
                                        }
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return shouldDismiss ?? false;
                          },
                          child: ListTile(
                            title: Text(eventGroup.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eventGroup.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${DateFormat.yMMMd().format(eventGroup.fromDateTime)} - ${DateFormat.yMMMd().format(eventGroup.toDateTime)}',
                                ),
                                Text(
                                  '${DateFormat.Hm().format(eventGroup.fromDateTime)} - ${DateFormat.Hm().format(eventGroup.toDateTime)}',
                                ),
                              ],
                            ),
                            trailing: eventGroup.createdBy == user.uid
                                ? Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text('Error: $error'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

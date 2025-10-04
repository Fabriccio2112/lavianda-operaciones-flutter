import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/map/map_bloc.dart';
import '../../blocs/map/map_event.dart';
import '../../blocs/map/map_state.dart';

class UserListDrawer extends StatelessWidget {
  final Function(int userId) onUserTap;

  const UserListDrawer({
    super.key,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is! MapLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = state.userMarkers.values.toList()
            ..sort((a, b) {
              // Ordenar: online primero, luego por nombre
              if (a.isOnline != b.isOnline) {
                return a.isOnline ? -1 : 1;
              }
              return a.userName.compareTo(b.userName);
            });

          return Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Usuarios (${users.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${users.where((u) => u.isOnline).length} en línea',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isOnline
                            ? Colors.green
                            : Colors.grey,
                        child: Text(
                          user.userName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user.userName,
                        style: TextStyle(
                          fontWeight: user.isOnline
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.statusText),
                          if (user.speed != null)
                            Text(
                              '${user.speed!.toStringAsFixed(1)} km/h',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user.isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: user.isVisible ? null : Colors.grey,
                            ),
                            onPressed: () {
                              context.read<MapBloc>().add(
                                    ToggleUserVisibilityEvent(user.userId),
                                  );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () => onUserTap(user.userId),
                          ),
                        ],
                      ),
                      onTap: () => onUserTap(user.userId),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

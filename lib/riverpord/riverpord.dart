import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoData =
    StateNotifierProvider<UserProvider, List<User>>((ref) => UserProvider());

class UserProvider extends StateNotifier<List<User>> {
  UserProvider()
      : super([
          User(
              title: "Buy Groceries",
              description:
                  "Purchase fruits, vegetables, and other essentials from the supermarket."),
        User(
              title: "Read a Book",
              description:
                  "Spend some quiet time reading a book to relax and unwind."),
          User(
              title: "Complete Project",
              description:
                  "Work on and finish the project assigned by the team at work."),
          User(
              title: "Plan Weekend Trip",
              description:
                  "Research and plan a short weekend getaway for some leisure time")
        ]);

  Future addData(List<User> user) async {
    state = [...state, ...user];
  }

  Future<void> removeData(User user) async {
    state = List.from(state)..remove(user);
  }

  Future<void> updateData(User existingUser, User updatedUser) async {
    state = state.map((user) {
      if (user.title == existingUser.title &&
          user.description == existingUser.description) {
        // Update the user with new data
        return updatedUser;
      }
      return user;
    }).toList();
  }
}

class User {
  User({this.title, this.description});
  String? title, description;
}


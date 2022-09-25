import 'package:crud_user_registration/provider/theme_provider.dart';
import 'package:crud_user_registration/widgets/modal_form.dart';
import 'package:crud_user_registration/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_list_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final modal = ModalForm();

  Future<List<User>> getUserList() async {
    List<User> userList = await Provider.of<UserListProvider>(context).getUserList();

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Lista de Usuários"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<ThemeProvider>(builder: (context, theme, _) {
              var currentTheme = theme.currentTheme;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  onPressed: () {
                    currentTheme == "light" || currentTheme == "system"
                        ? theme.changeTheme("dark")
                        : theme.changeTheme("light");
                  },
                  icon: Icon(currentTheme == "light" || currentTheme == "system" ? Icons.dark_mode : Icons.light_mode),
                  splashRadius: 26,
                  key: ValueKey(currentTheme),
                ),
              );
            }),
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else {
            final List<User> list = snapshot.data!;

            return list.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Você não cadastrou nenhum usuário!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: list.length,
                    itemBuilder: (context, index) => UserItem(list[index]),
                  );
          }
        },
        // child:
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar novo usuário
          modal.showModal(context, User());
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
      ),
    );
  }
}

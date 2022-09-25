import 'package:crud_user_registration/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_list_provider.dart';

class ModalForm {
  final formKey = GlobalKey<FormState>();

  void showModal(BuildContext context, User user) {
    // controllers
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();

    final users = Provider.of<UserListProvider>(context, listen: false);

    User newUser = user;

    if (newUser.id != null) {
      _nameController.text = newUser.name;
      _emailController.text = newUser.email;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
              left: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return "Preencha o seu nome de usuário.";
                    } else {
                      return null;
                    }
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    label: Text("Nome do Usuário"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Preencha o seu email.";
                    } else if (!email.contains("@")) {
                      return "Isto certamente não é um email.";
                    } else {
                      return null;
                    }
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop();

                          if (newUser.id != null) {
                            newUser = User(
                              id: newUser.id,
                              name: _nameController.text,
                              email: _emailController.text,
                            );

                            users.updateUser(newUser);
                          } else {
                            newUser = User(
                              name: _nameController.text,
                              email: _emailController.text,
                            );

                            users.addUser(newUser);
                          }
                        }
                      },
                      child: Text(newUser.id != null ? "Editar" : "Salvar", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

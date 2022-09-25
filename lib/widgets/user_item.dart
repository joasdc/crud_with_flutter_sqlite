import 'package:crud_user_registration/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/user_list_provider.dart';
import 'modal_form.dart';

class UserItem extends StatelessWidget {
  final User user;

  final modal = ModalForm();

  UserItem(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserListProvider>(context, listen: false);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 1,
            onPressed: (context) {
              modal.showModal(context, user);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            icon: Icons.edit,
            label: 'Editar',
          ),
          const SizedBox(width: 4.0),
          SlidableAction(
            onPressed: (context) {
              users.deleteUser(user.id!);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            icon: Icons.delete,
            label: 'Deletar',
          ),
        ],
      ),
      child: Card(
        elevation: 20,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2016/03/31/19/57/avatar-1295404_960_720.png"),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
        ),
      ),
    );
  }
}

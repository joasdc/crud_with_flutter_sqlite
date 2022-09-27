import 'dart:io';

import 'package:crud_user_registration/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/user_list_provider.dart';
import '../utils/modal_bottom_sheet.dart';

class UserItem extends StatelessWidget {
  final User user;

  final modal = ModalBottomSheet();

  UserItem(this.user, {Key? key}) : super(key: key);

  bool get hasLocalImage {
    bool hasLocalImage = File(user.imageUrl).existsSync();
    return hasLocalImage;
  }

  ImageProvider backgroundImage(bool hasLocalImage) {
    if (hasLocalImage) {
      var bytes = File(user.imageUrl).readAsBytesSync();
      return MemoryImage(bytes);
    } else {
      return NetworkImage(user.imageUrl);
    }
  }

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
          leading: CircleAvatar(
            backgroundImage: backgroundImage(hasLocalImage),
            // child: Visibility(visible: !hasLocalImage, child: CircularProgressIndicator()),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
        ),
      ),
    );
  }
}

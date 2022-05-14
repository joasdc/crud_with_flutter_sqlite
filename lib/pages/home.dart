import 'package:flutter/material.dart';
import '../models/user.dart';
import '../sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> _usersL = [];
  UserDbProvider userDb = UserDbProvider();

  bool _isLoading = true;
  void _refreshUsers() async {
    final data = await userDb.fetchUsers();
    setState(() {
      _usersL = data;
      _isLoading = false;
    });
  }

  Future _deleteUser(int index) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Aviso'),
        content: const Text('Deseja apagar este usuário?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'NÃO'),
            child: const Text('NÃO', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              await userDb.deleteUser(_usersL[index].id!);
              _refreshUsers();
              Navigator.pop(context, 'SIM');
            },
            child: const Text(
              'SIM',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  _showModal([int? index]) {
    return showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          // isso impedirá que o teclado virtual cubra os campos de texto
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nome'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text == "") {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Aviso'),
                      content: const Text('Preencha o nome'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (_emailController.text == "" ||
                    !_emailController.text.contains("@")) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Aviso'),
                      content: const Text('Preencha o email corretamente'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (index != null) {
                    final editUser = User(
                      id: _usersL[index].id,
                      name: _nameController.text,
                      email: _emailController.text,
                    );

                    await userDb.updateUser(_usersL[index].id!, editUser);
                    _refreshUsers();

                    _nameController.text = "";
                    _emailController.text = "";

                    Navigator.pop(context);
                  } else {
                    final user = User(
                      name: _nameController.text,
                      email: _emailController.text,
                    );

                    await userDb.addUser(user);
                    _refreshUsers();

                    _nameController.text = "";
                    _emailController.text = "";

                    Navigator.pop(context);
                  }
                }
              },
              child: Text(index != null ? 'Editar' : 'Salvar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Widget buildRowUsers(BuildContext context, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
            "https://cdn.pixabay.com/photo/2016/03/31/19/57/avatar-1295404_960_720.png"),
      ),
      title: Text(_usersL[index].name),
      subtitle: Text(_usersL[index].email),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                //Editar user
                if (_usersL[index].id != null) {
                  _nameController.text = _usersL[index].name;
                  _emailController.text = _usersL[index].email;
                }

                _showModal(index);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                _deleteUser(index);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersList = ScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Lista de Usuários"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : ListView.builder(
              itemBuilder: ((context, index) => buildRowUsers(context, index)),
              itemCount: _usersL.length,
              controller: usersList,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.text = "";
          _emailController.text = "";
          // Adicionar User
          _showModal();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

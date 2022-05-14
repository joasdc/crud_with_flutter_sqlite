import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import './models/user.dart';
import 'dart:io';
import 'dart:async';

// Inicializar o banco de dados
class UserDbProvider {
  // função para abrir conexão com o banco de dados
  Future<Database> init() async {
    // Retorna um diretório que armazena arquivos permanentes
    Directory directory = await getApplicationDocumentsDirectory();

    // Criar caminho para o banco de dados
    final path = join(directory.path, "users.db");

    // Abre o DB, ou cria um DB se não houver nenhum
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
        CREATE TABLE Users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT)""");
    });
  }

  // Função para obter o model dos dados
  // converter em um MAP
  // inserir os dados no DB com insert()
  Future<int> addUser(User user) async {
    // Abrir DB
    final db = await init();

    // toMap() do model User
    // ConflictAlgorithm: ignora conflitos devido a entradas duplicadas
    return db.insert(
      "Users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Consulta de dados
  Future<List<User>> fetchUsers() async {
    final db = await init();

    // Consulta todas as linhas em uma tabela como um array de mapas
    final maps = await db.query("Users");

    // Cria uma lista de usuários
    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'] as int,
        name: maps[index]['name'].toString(),
        email: maps[index]['email'].toString(),
      );
    });
  }

  // Remoção de dados
  Future<int> deleteUser(int id) async {
    final db = await init();

    int result = await db.delete("Users", // nome da tabela
        where: "id = ?",
        whereArgs: [id] //
        );

    return result;
  }

  // Atualizar dados
  Future<int> updateUser(int id, User user) async {
    final db = await init();

    int result = await db
        .update("Users", user.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}

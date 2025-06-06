import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para gestionar la base de datos SQLite local de la app.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Devuelve la instancia de la base de datos, inicializándola si es necesario.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  /// Inicializa la base de datos SQLite con el archivo dado.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Cambiado a versión 3
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Crea las tablas iniciales de la base de datos (users, vehicles, jornadas).
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id_user INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        empresa TEXT NOT NULL,
        direccion_empresa TEXT,
        cif_empresa TEXT,
        nombre_trabajador TEXT,
        direccion_trabajador TEXT,
        dni_trabajador TEXT,
        localidad_trabajador TEXT
      )
    ''');
    // Crea la tabla vehicles
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id_user)
      )
    ''');
    // Crea la tabla jornadas
    await db.execute('''
      CREATE TABLE jornadas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trabajador TEXT NOT NULL,
        empresa TEXT NOT NULL,
        vehiculo TEXT NOT NULL,
        fecha_hora_inicio TEXT NOT NULL,
        lat_inicio REAL,
        lon_inicio REAL,
        fecha_hora_fin TEXT NOT NULL,
        lat_fin REAL,
        lon_fin REAL,
        firma BLOB,
        cliente TEXT,
        direccion_cliente TEXT,
        cif TEXT,
        localidad_cliente TEXT,
        provincia_cliente TEXT,
        cp TEXT,
        trabajo_realizado TEXT,
        nombre_empresa TEXT,
        direccion_empresa TEXT,
        cif_empresa TEXT,
        nombre_trabajador TEXT,
        direccion_trabajador TEXT,
        dni_trabajador TEXT,
        localidad_trabajador TEXT,
        fecha TEXT,
        hora_llegada TEXT,
        hora_salida TEXT,
        numero_parte TEXT
      )
    ''');
  }

  /// Realiza migraciones de la base de datos según la versión (añade columnas nuevas si es necesario).
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE jornadas ADD COLUMN cliente TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN direccion_cliente TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN cif TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN localidad_cliente TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN provincia_cliente TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN cp TEXT');
      await db.execute('ALTER TABLE jornadas ADD COLUMN trabajo_realizado TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN direccion_empresa TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN cif_empresa TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN nombre_trabajador TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN direccion_trabajador TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN dni_trabajador TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN localidad_trabajador TEXT');
    }
  }

  /// Inserta un usuario en la tabla users. Si el usuario ya existe, lo ignora.
  Future<int> insertUser(
    String username,
    String password,
    String empresa, {
    String? direccionEmpresa,
    String? cifEmpresa,
    String? nombreTrabajador,
    String? direccionTrabajador,
    String? dniTrabajador,
    String? localidadTrabajador,
  }) async {
    final db = await instance.database;
    return await db.insert('users', {
      'username': username,
      'password': password,
      'empresa': empresa,
      'direccion_empresa': direccionEmpresa,
      'cif_empresa': cifEmpresa,
      'nombre_trabajador': nombreTrabajador,
      'direccion_trabajador': direccionTrabajador,
      'dni_trabajador': dniTrabajador,
      'localidad_trabajador': localidadTrabajador,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Inserta un vehículo asociado a un usuario en la tabla vehicles.
  Future<int> insertVehicle(int userId, String nombreVehiculo) async {
    final db = await database;
    return await db.insert('vehicles', {
      'user_id': userId,
      'nombre': nombreVehiculo,
    });
  }

  /// Obtiene un usuario por su nombre de usuario. Devuelve null si no existe.
  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Devuelve el primer usuario de la tabla users (o null si no hay usuarios).
  Future<Map<String, dynamic>?> getUniqueUser() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('users');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Imprime por consola todos los usuarios y vehículos de la base de datos (solo para debug/desarrollo).
  Future<void> printAllData() async {
    final db = await database;
    final users = await db.query('users');
    final vehicles = await db.query('vehicles');

    //print('--- Usuarios ---');
    for (final user in users) {
      //print(user);
    }

    //print('--- Vehículos ---');
    for (final vehicle in vehicles) {
      //print(vehicle);
    }
  }

  /// Elimina físicamente el archivo de la base de datos local.
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    await databaseFactory.deleteDatabase(path);
  }

  /// Inserta una jornada laboral en la tabla jornadas.
  Future<int> insertJornada(Map<String, dynamic> jornada) async {
    final db = await database;
    return await db.insert('jornadas', jornada);
  }
}

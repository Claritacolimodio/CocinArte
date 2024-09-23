const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json()); // Asegúrate de que el cuerpo de las solicitudes se pueda analizar como JSON

// Crear una conexión a la base de datos MySQL
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  port: '3306',
  password: '221522',
  database: 'cocinarte'
});

connection.connect((err) => {
  if (err) {
    console.error('Error al conectar a la base de datos: ', err);
    return;
  }
  console.log('Conectado a la base de datos MySQL');
});

// Ruta para verificar la conexión
app.get('/', (req, res) => {
  connection.query('SELECT 1 + 1 AS solution', (err, results) => {
    if (err) {
      console.error('Error al ejecutar la consulta: ', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    res.send(`La solución es: ${results[0].solution}`);
  });
});

// Ruta para obtener todos los ítems (GET /items)
//http://localhost:3000/items
app.get('/recetas', (req, res) => {
  connection.query('SELECT * FROM recetas', (err, results) => {
    if (err) {
      console.error('Error al obtener las recetas: ', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    res.json(results); // Enviar los resultados como respuesta en formato JSON
  });
});

// Ruta para agregar un ítem (POST /items)
app.post('/ingredientes', (req, res) => {
  const newItem = req.body; // Obtener el nuevo ítem desde el cuerpo de la solicitud
  const query = 'INSERT INTO ingredientes (nombre) VALUES (?)'; // Asegúrate de ajustar el SQL según tu estructura de tabla
  connection.query(query, [newItem.nombre], (err, result) => {
    if (err) {
      console.error('Error al agregar un ítem: ', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    res.status(201).json({ id: result.insertId, ...newItem }); // Responder con el nuevo ítem agregado
  });
});

// Ruta para agregar un ítem (PUT)
app.put('/recetas/:id', (req, res) => {
  const baseId = req.params;
  const newItem = req.body; // Obtener el nuevo ítem desde el cuerpo de la solicitud
  const query = " UPDATE cocinarte.recetas SET Titulo = ? ,Descripcion = ? ,ID_Ingredientes = ? , Instrucciones = ?, Fecha_publicacion = ? WHERE ID_receta = ?; "

  connection.query(query, [newItem.Titulo, newItem.descripcion , newItem.id_ingredientes, newItem.instrucciones, newItem.fechapublicacion , baseId.id]  , (err, result) => {
    if (err) {
      console.error('Error al agregar una receta: ', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    res.status(201).json({ id: result.insertId, ...newItem }); // Responder con el nuevo ítem agregado
  });
});


// Ruta para agregar un ítem (DELETE)
app.delete('/recetas/:id', (req, res) => {
  const baseId = req.params;
  const query = "DELETE FROM cocinarte.recetas WHERE Id_receta = ?";
  
  connection.query(query, [baseId.id], (err, result) => {
    if (err) {
      console.error('Error al agregar una receta: ', err);
      res.status(500).send('Error en el servidor');
      return;
    }
    res.status(201).json({ id: result.insertId, ...newItem }); // Responder con el nuevo ítem agregado
  });
});

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor ejecutándose en http://localhost:${port}`);
});


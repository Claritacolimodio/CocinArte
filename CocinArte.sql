-- Crear la base de datos
CREATE DATABASE CocinArte;
USE CocinArte;

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    ID_usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(45) NOT NULL,
    Apellido VARCHAR(45) NOT NULL,
    Correo_electronico VARCHAR(30) UNIQUE NOT NULL,
    Contrasena VARCHAR(15) NOT NULL,
    Fecha_registro DATE NOT NULL,
    Tipo_usuario ENUM('regular', 'administrador') DEFAULT 'regular'
);


-- Tabla de Recetas
CREATE TABLE Recetas (
    ID_receta INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(200) NOT NULL,
    Descripcion TEXT NOT NULL,
    Instrucciones TEXT NOT NULL,
    Fecha_publicacion DATE NOT NULL,
    ID_usuario INT,
    
    FOREIGN KEY (ID_usuario) REFERENCES Usuarios(ID_usuario)
);

UPDATE `cocinarte`.`recetas`
SET
`ID_receta` = <{ID_receta: }>,
`Titulo` = <{Titulo: }>,
`Descripcion` = <{Descripcion: }>,
`ID_Ingredientes` = <{ID_Ingredientes: }>,
`Instrucciones` = <{Instrucciones: }>,
`Fecha_publicacion` = <{Fecha_publicacion: }>,
`ID_usuario` = <{ID_usuario: }>
WHERE `ID_receta` = <{expr}>;


DELETE FROM `cocinarte`.`recetas`
WHERE <{where_expression}>;


-- Tabla Intermedia Ingredientes
CREATE TABLE Ingredientes (
     ID_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

-- Tabla Receta_Ingredientes
CREATE TABLE Receta_Ingredientes (
    ID_receta INT,
    ID_ingrediente INT,
    Cantidad VARCHAR(50),
    PRIMARY KEY (ID_receta, ID_ingrediente),
	FOREIGN KEY (ID_receta) REFERENCES Recetas(ID_receta),
    FOREIGN KEY (ID_ingrediente) REFERENCES Ingredientes(ID_ingrediente)
);

-- Tabla de Comentarios
CREATE TABLE Comentarios (
    ID_comentario INT AUTO_INCREMENT PRIMARY KEY,
    Contenido TEXT NOT NULL,
    Fecha_comentario DATE NOT NULL,
    ID_usuario INT,
    ID_receta INT,
    FOREIGN KEY (ID_usuario) REFERENCES Usuarios(ID_usuario),
    FOREIGN KEY (ID_receta) REFERENCES Recetas(ID_receta)
);

DELETE FROM `cocinarte`.`comentarios`
WHERE <{where_expression}>;

-- Tabla de Colecciones
CREATE TABLE Colecciones (
    ID_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_coleccion VARCHAR(100) NOT NULL,
    ID_usuario INT,
    FOREIGN KEY (ID_usuario) REFERENCES Usuarios(ID_usuario)
);

-- Tabla intermedia para Recetas y Colecciones (muchos a muchos)
CREATE TABLE Recetas_Colecciones (
    ID_coleccion INT,
    ID_receta INT,
    PRIMARY KEY (ID_coleccion, ID_receta),
    FOREIGN KEY (ID_coleccion) REFERENCES Colecciones(ID_coleccion),
    FOREIGN KEY (ID_receta) REFERENCES Recetas(ID_receta)
);

-- Tabla de Interacciones (like, save, etc.)
CREATE TABLE Interacciones (
    ID_interaccion INT AUTO_INCREMENT PRIMARY KEY,
    Tipo_interaccion ENUM('like', 'save') NOT NULL,
    Fecha_interaccion DATE NOT NULL,
    ID_usuario INT,
    ID_receta INT,
    FOREIGN KEY (ID_usuario) REFERENCES Usuarios(ID_usuario),
    FOREIGN KEY (ID_receta) REFERENCES Recetas(ID_receta)
);


INSERT INTO Usuarios (Nombre, Apellido, Correo_electronico, Contrasena, Fecha_registro, Tipo_usuario)VALUES
("Jeronimo", "Menendez", "jeronimom@gmail.com", "password123", CURDATE(), "regular"),
("Bautista","Bally","bautista@gmail.com", "password456", CURDATE(), "regular");

INSERT INTO Ingredientes (Nombre) VALUES 
    ('Masa para pizza'),
    ('Queso tipo mozzarella'),
    ('Aceitunas'),
    ('Tomates perita'),
    ('Ajo'),
    ('Aceite de oliva'),
    ('Sal'),
    ('Pimienta'),
    ('Orégano'),
    ('Azúcar'),
    ('Manzanas'),
    ('Azúcar'),
    ('Harina'),
    ('Mantequilla'),
    ('Pechugas de pollo'),
    ('Cebollas'),
    ('Ají morrón colorado'),
    ('Panceta ahumada'),
    ('Ciruelas secas sin carozo');


INSERT INTO Recetas(Titulo, Descripcion, Instrucciones, Fecha_publicacion, ID_usuario)VALUES
('Pizza casera', 'Masa casera para preparar una exquisita pizza.', '– Calentar el horno a temperatura fuerte y aceitar apenas una pizzera redonda, una piedra para pizza o una placa de horno.– Picar el ajo y los tomates.– En dos cucharadas de aceite de oliva, rehogar el ajo unos segundos, sin dorar. Agregar los tomates picados, sal, pimienta y pizca de azúcar. Cocinar a fuego medio cinco minutos.– Rallar la mozzarella.– Estirar con la punta de los dedos la masa de pizza en la pizzera, no importa que quede con una textura irregular. Con una cuchara, untar la masa con la salsa de tomate (no poner en exceso o la pizza no quedará crocante). Colocar en el estante más bajo del horno. Cocinar la masa cinco minutos, sin llegar a dorar.– Cuando la masa está apenas cocida, poner un par de cucharadas más de salsa y la mozzarella rallada. Volver al horno hasta que la mozzarella esté derretida y dorada por lugares.– Sacar del horno, distribuir las aceitunas, rociar con un hilo de aceite de oliva, y espolvorear con orégano. Servir.-Se puede probar también agregándole jamón, salame, otros quesos, tomate fresco con albahaca o lo que quieran!', '2024-08-23', 1),
('Tarta de Manzana', 'Una deliciosa tarta con relleno de manzana.', '1. Pelar las manzanas. 2. Mezclar con azúcar', '2024-09-01', 1),
('Brochette de Pollo', 'Exquisito brochette con pollo y verduras.', '– Quitar la piel a las pechugas de pollo.– Cortar el pollo en cubos de 3 cm. de lado aproximadamente.– Retirar el cuero de la panceta y cortarla en pedacitos de 3 cm. de lado y 1 cm. de espesor.– Pelar las cebollas y cortarlas en trozos similares a los de la panceta.– Quitar las semillas y nervaduras del ají morrón y cortarlo como a la cebolla.– Ir pinchando en los palillos de brochette los ingredientes en el siguiente orden: , ciruela, pollo, panceta, cebolla, ají, ciruela y así sucesivamente hasta completar el palillo de brochette, cuidando de dejar unos 5 cm. en la parte superior para poder sostener la brochette y servirla.– Colocar las brochettes a asar en horno de moderado a caliente, sobre una rejilla y abajo una asadera.– Cuando ya está dorada la parte inferior se da vuelta y se sala sólo la superficie que quedó arriba (la que ya está cocinada), esto para que el pollo de la brochette no pierda sus jugos.– Cuando la carne esté dorada de ambos lados retirar y servir.', '2024-08-29', 2);

INSERT INTO Comentarios (Contenido, Fecha_comentario, ID_usuario, ID_receta)
VALUES 
('¡Me encantó esta receta! Muy fácil de hacer.', '2024-08-23', 2, 1),
('La pizza estaba deliciosa, gracias por compartir.', '2024-09-02', 1, 2);

INSERT INTO Colecciones (Nombre_coleccion, ID_usuario)
VALUES 
('Favoritas de Jeronimo', 1),
('Recetas Saludables', 2);

INSERT INTO Recetas_Colecciones (ID_coleccion, ID_receta)
VALUES 
(1, 1),
(2, 2);

INSERT INTO Interacciones (Tipo_interaccion, Fecha_interaccion, ID_usuario, ID_receta)
VALUES 
('like', '2024-09-02', 1, 2),
('save', '2024-09-02', 2, 1);

SHOW TABLES;

update recetas set habilitado = 1 where id_receta = 3
select *from recetas



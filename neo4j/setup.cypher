// Crear estudiantes
CREATE (juan:Estudiante {nombre: 'Juan Pérez'}),
       (maria:Estudiante {nombre: 'María López'}),
       (carlos:Estudiante {nombre: 'Carlos Díaz'});

// Crear profesores
CREATE (profCarlos:Profesor {nombre: 'Carlos García'}),
       (profAna:Profesor {nombre: 'Ana Torres'});

// Crear cursos
CREATE (cursoBD:Curso {nombre: 'Bases de Datos II'}),
       (cursoIA:Curso {nombre: 'Inteligencia Artificial'});

// Crear grupos
CREATE (grupoA:GrupoDeEstudio {nombre: 'Grupo A'}),
       (grupoB:GrupoDeEstudio {nombre: 'Grupo B'});

// Relaciones entre estudiantes
CREATE (juan)-[:SIGUE]->(maria),
       (maria)-[:SIGUE]->(carlos);

// Relaciones con grupos
CREATE (juan)-[:PERTENECE_A]->(grupoA),
       (maria)-[:PERTENECE_A]->(grupoA),
       (carlos)-[:PERTENECE_A]->(grupoB);

// Grupos asociados a cursos
CREATE (grupoA)-[:ASOCIADO_A]->(cursoBD),
       (grupoB)-[:ASOCIADO_A]->(cursoIA);

// Recomendaciones
CREATE (juan)-[:RECOMIENDA]->(profCarlos),
       (maria)-[:RECOMIENDA]->(profCarlos),
       (carlos)-[:RECOMIENDA]->(profAna);

// 1.Compañeros de grupo de "Juan Pérez"

MATCH (juan:Estudiante {nombre: 'Juan Pérez'})-[:PERTENECE_A]->(grupo)<-[:PERTENECE_A]-(compañero)
WHERE compañero <> juan
RETURN compañero.nombre AS Compañeros;

// 2 Cantidad de estudiantes que recomiendan al Profesor "Carlos García"
MATCH (e:Estudiante)-[:RECOMIENDA]->(p:Profesor {nombre: 'Carlos García'})
RETURN count(e) AS TotalRecomendaciones;

// 3 Grupos asociados al curso ‘Bases de Datos II’:
MATCH (g:GrupoDeEstudio)-[:ASOCIADO_A]->(c:Curso {nombre: 'Bases de Datos II'})
RETURN g.nombre AS GruposAsociados;
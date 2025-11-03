import dotenv from 'dotenv'
import neo4j from 'neo4j-driver'
import { createClient } from 'redis'

dotenv.config()

// --- Conexión Neo4j ---
const neo4jDriver = neo4j.driver(
  process.env.NEO4J_URI,
  neo4j.auth.basic(process.env.NEO4J_USER, process.env.NEO4J_PASSWORD)
)
const session = neo4jDriver.session()

// --- Conexión Redis ---
const redisClient = createClient({ url: process.env.REDIS_URL })
await redisClient.connect()

console.log('✅ Conectado a Neo4j y Redis')

// --- 1. Consultar los grupos de Juan Pérez en Neo4j ---
const result = await session.run(`
  MATCH (e:Estudiante {nombre: 'Juan Pérez'})-[:PERTENECE_A]->(g:GrupoDeEstudio)
  RETURN g.nombre AS grupo
`)

const grupos = result.records.map(r => r.get('grupo'))
console.log('📚 Grupos de Juan Pérez:', grupos)

// --- 2. Guardar los resultados en Redis ---
await redisClient.set('cache:grupos:juan', JSON.stringify(grupos))
await redisClient.expire('cache:grupos:juan', 3600)

console.log('💾 Caché en Redis guardado correctamente')

// --- 3. Leer desde Redis ---
const cache = await redisClient.get('cache:grupos:juan')
console.log('⚡ Desde Redis:', JSON.parse(cache))

await session.close()
await neo4jDriver.close()
await redisClient.disconnect()

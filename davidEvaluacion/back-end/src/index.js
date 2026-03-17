const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const path = require('path');

// Cargar variables de entorno desde el archivo .env en la raíz del backend
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const app = express();
const port = process.env.PORT || 3000;

// CONFIGURACIÓN CORS - IMPORTANTE PARA FLUTTER WEB
app.use(cors({
    origin: '*', // Permite cualquier origen (solo para desarrollo)
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Conexión a MySQL
console.log('🔄 Conectando a MySQL...');
console.log('📊 Configuración:', {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    database: process.env.DB_NAME || 'nombre_de_tu_bd'
});

const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'nombre_de_tu_bd'
});

db.connect((err) => {
    if (err) {
        console.error('❌ Error conectando a MySQL:');
        console.error(err);
        return;
    }
    console.log('✅ Conectado a MySQL exitosamente');
});

// Ruta de prueba
app.get('/', (req, res) => {
    res.json({ 
        message: 'API funcionando correctamente',
        endpoints: {
            login: '/api_v1/apiUserLogin (POST)',
            createRole: '/api_v1/role (POST)'
        }
    });
});

// ============================================
// ENDPOINT DE LOGIN - ACTUALIZADO CON TUS CAMPOS
// ============================================
app.post('/api_v1/apiUserLogin', (req, res) => {
    const { api_user, api_password } = req.body;
    
    console.log('📝 Intento de login:', { api_user });
    console.log('📦 Body completo:', req.body);
    
    // Verificar que llegaron los datos
    if (!api_user || !api_password) {
        console.log('❌ Faltan credenciales');
        return res.status(400).json({ 
            message: 'Faltan credenciales. Se requiere api_user y api_password' 
        });
    }
    
    // 🔥 CONSULTA ACTUALIZADA CON TUS CAMPOS REALES
    // Usando: User_user y User_password
    const query = 'SELECT * FROM users WHERE User_user = ? AND User_password = ?';
    
    db.query(query, [api_user, api_password], (err, results) => {
        if (err) {
            console.error('❌ Error en consulta:', err);
            return res.status(500).json({ 
                message: 'Error del servidor',
                error: err.message 
            });
        }
        
        console.log('📊 Resultados de BD:', results);
        
        if (results && results.length > 0) {
            const user = results[0];
            
            // Crear token JWT con los campos correctos
            const token = jwt.sign(
                { 
                    id: user.User_id, 
                    username: user.User_user,
                    rol: user.Roles_fk,
                    status: user.User_status_fk
                }, 
                process.env.JWT_SECRET || 'mi_secreto_temporal_2024',
                { expiresIn: '1h' }
            );
            
            console.log('✅ Login exitoso para:', api_user);
            res.json({ 
                token: token,
                user: {
                    id: user.User_id,
                    username: user.User_user,
                    rol: user.Roles_fk,
                    status: user.User_status_fk
                },
                message: 'Login exitoso' 
            });
        } else {
            console.log('❌ Login fallido - credenciales inválidas:', api_user);
            res.status(401).json({ 
                message: 'Credenciales inválidas' 
            });
        }
    });
});

// ============================================
// ENDPOINT PARA CREAR ROL - ACTUALIZADO CON TUS CAMPOS
// ============================================
app.post('/api_v1/role', (req, res) => {
    const { name, description } = req.body;
    
    console.log('📝 Creando rol:', { name, description });
    console.log('📦 Body completo:', req.body);
    
    // Verificar que llegaron los datos
    if (!name) {
        console.log('❌ Falta nombre del rol');
        return res.status(400).json({ 
            message: 'Falta el nombre del rol' 
        });
    }
    
    // 🔥 CONSULTA ACTUALIZADA CON TUS CAMPOS REALES
    // Usando: Roles_name, Roles_description, create_at
    const query = 'INSERT INTO roles (Roles_name, Roles_description, create_at) VALUES (?, ?, NOW())';
    
    db.query(query, [name, description || null], (err, result) => {
        if (err) {
            console.error('❌ Error creando rol:', err);
            return res.status(500).json({ 
                message: 'Error creando rol',
                error: err.message 
            });
        }
        
        console.log('✅ Rol creado con ID:', result.insertId);
        res.json({ 
            id: result.insertId,
            name: name,
            description: description,
            message: 'Rol creado exitosamente' 
        });
    });
});

// Manejo de errores 404
app.use((req, res) => {
    res.status(404).json({ 
        message: 'Endpoint no encontrado',
        path: req.path 
    });
});

// Iniciar servidor
app.listen(port, '0.0.0.0', () => {
    console.log('\n');
    console.log('🚀 ==================================');
    console.log('🚀 SERVIDOR INICIADO CORRECTAMENTE');
    console.log('🚀 ==================================');
    console.log(`📱 Local: http://localhost:${port}`);
    console.log(`📱 Red: http://${getLocalIP()}:${port}`);
    console.log('\n📝 ENDPOINTS DISPONIBLES:');
    console.log(`   🔐 POST http://localhost:${port}/api_v1/apiUserLogin`);
    console.log(`      Body: { "api_user": "usuario", "api_password": "pass" }`);
    console.log(`   📝 POST http://localhost:${port}/api_v1/role`);
    console.log(`      Body: { "name": "Rol", "description": "Desc" }`);
    console.log('🚀 ==================================\n');
});

// Función para obtener IP local
function getLocalIP() {
    try {
        const { networkInterfaces } = require('os');
        const nets = networkInterfaces();
        
        for (const name of Object.keys(nets)) {
            for (const net of nets[name]) {
                if (net.family === 'IPv4' && !net.internal) {
                    return net.address;
                }
            }
        }
    } catch (e) {
        console.log('Error obteniendo IP:', e);
    }
    return 'localhost';
}
import jwt
import datetime
from flask import Blueprint, request, jsonify
from werkzeug.security import check_password_hash, generate_password_hash
from .db import get_db_connection

auth_bp = Blueprint('auth', __name__)
SECRET_KEY = 'votre_clé_secrète'  # Remplacez par une clé secrète robuste

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if user and check_password_hash(user['password_hash'], password):
        # Génération du token JWT
        token = jwt.encode({
            'user_id': user['id'],  # ID de l'utilisateur
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)  # Expiration du token dans 24h
        }, SECRET_KEY, algorithm='HS256')

        return jsonify({"token": token}), 200
    else:
        return jsonify({"message": "Invalid credentials"}), 401

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()

    if user:
        cursor.close()
        conn.close()
        return jsonify({"message": "Utilisateur existe déjà"}), 400

    hashed_password = generate_password_hash(password)
    cursor.execute("INSERT INTO users (username, password_hash) VALUES (%s, %s)", (username, hashed_password))
    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({"message": "Utilisateur enregistré avec succès"}), 201

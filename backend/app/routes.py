from flask import Blueprint, jsonify, request
from .db import get_db_connection
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

bp = Blueprint('routes', __name__)

# Route pour obtenir la liste des utilisateurs
@bp.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(users)

# Route pour obtenir la liste des catégories
@bp.route('/categories', methods=['GET'])
def get_categories():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM categories")
    categories = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(categories)

# Route pour obtenir les topics d'une catégorie
@bp.route('/categories/<int:category_id>/topics', methods=['GET'])
def get_topics_by_category(category_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM topics WHERE category_id = %s", (category_id,))
    topics = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(topics)

# Route pour créer un nouveau topic
@bp.route('/topics', methods=['POST'])
def create_topic():
    data = request.get_json()
    title = data.get('title')
    description = data.get('description')  # Utilisez 'description' à la place de 'content'
    category_id = data.get('category_id')
    user_id = data.get('user_id')  # Assurez-vous que l'ID utilisateur est envoyé dans la requête

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        sql = "INSERT INTO topics (title, description, user_id, category_id, created_at) VALUES (%s, %s, %s, %s, NOW())"
        cursor.execute(sql, (title, description, user_id, category_id))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Topic créé avec succès"}), 201
    except mysql.connector.Error as err:
        print(f"Erreur: {err}")
        return jsonify({"error": "Erreur lors de la création du topic"}), 500

# Route for adding a reply to a topic
@bp.route('/reply', methods=['POST'])
def add_reply():
    data = request.get_json()
    topic_id = data.get('topic_id')
    user_id = data.get('user_id')
    description = data.get('description')

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        sql = "INSERT INTO reply (topic_id, user_id, description, created_at) VALUES (%s, %s, %s, NOW())"
        cursor.execute(sql, (topic_id, user_id, description))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Réponse ajoutée avec succès"}), 201
    except mysql.connector.Error as err:
        print(f"Erreur: {err}")
        return jsonify({"error": "Erreur lors de l'ajout de la réponse"}), 500

# Route to get replies for a specific topic
@bp.route('/replies/<int:topic_id>', methods=['GET'])
def get_replies(topic_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM reply WHERE topic_id = %s", (topic_id,))
    replies = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(replies if replies else []), 200

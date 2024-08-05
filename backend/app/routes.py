from flask import Blueprint, jsonify, request
from .db import get_db_connection

bp = Blueprint('routes', __name__)

@bp.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(users)

@bp.route('/categories', methods=['GET'])
def get_categories():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM categories")
    categories = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(categories)

@bp.route('/categories/<int:category_id>/topics', methods=['GET'])
def get_topics_by_category(category_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM topics WHERE category_id = %s", (category_id,))
    topics = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(topics)

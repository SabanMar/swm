from argparse import Action
from flask import Flask, request, jsonify, json, session
import pymysql
import secrets

# Details about base
config = {
    "user": "root",
    "password": "2255",
    "host": "localhost",
    "database": "SwM",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}

config1 = {
    "user": "root",
    "password": "2403",
    "host": "localhost",
    "database": "swm",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}

app = Flask(__name__)
# we use keys in order to store the user's data in sessions.
app.secret_key = secrets.token_hex(24)

@app.route("/login", methods=['POST'])
def login():
    if request.method == 'POST':
        data = request.get_json() 

        username = data.get('username')
        password = data.get('password')

        conn = pymysql.connect(**config) # connection with the database

        with conn.cursor() as cursor:
            query = "SELECT * FROM users WHERE username = %s AND password = %s"
            cursor.execute(query, (username, password))
            user = cursor.fetchone()

            if user:
                return jsonify(user)
            else:
                return jsonify({"error": "Invalid credentials"}), 401  # Unauthorized

    return jsonify({"error": "Method not allowed"}), 405  # Method not allowed


@app.route("/signup", methods = ['GET','POST'])
def signup():
    data = request.get_json()  # Assuming data is sent as JSON in the request body

    # Extract data from JSON payload
    username = data.get('username')
    password = data.get('password')
    university = data.get('university')
    email = data.get('email')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    phone = data.get('phone')
    
    conn = pymysql.connect(**config) 

    with conn.cursor() as cursor:
        query = "INSERT INTO users(username,password,university,email,first_name,last_name,phone) VALUES(%s,%s,%s,%s,%s,%s,%s)"
        cursor.execute(query, (username,password,university,email,first_name,last_name,phone))
        conn.commit()

        # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
        if cursor.rowcount > 0:
            return jsonify({"message" : "User registered successfully"})
        else:
            return jsonify({"message" : "User could not be registered"})


@app.route("/new_session", methods = ['GET','POST'])
def create_session():
    if 'user_id' not in session:
        return jsonify({"message": "User not logged in"})

    #Checking if user_id exists in the session
    host_id = session['user_id']     
    data = request.get_json()
    #host_id = data.get('host_id')
    subject = data.get('subject')
    location = data.get('location')
    start_time = data.get('start_time')
    end_time = data.get('end_time')

    conn = pymysql.connect(**config) 
    with conn.cursor() as cursor:
        query = "INSERT INTO sessions(host_id, subject, location, start_time, end_time) VALUES(%s, %s, %s, %s, %s)"
        cursor.execute(query, (host_id,subject,location,start_time,end_time))
        conn.commit()

        # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
        if cursor.rowcount > 0:
            return jsonify({"message" : "New session started successfully"})
        else:
            return jsonify({"message" : "The session didn't start"})


@app.route("/join_session/<int:sessions_id>", methods=['POST'])
def join_session(sessions_id):
    if 'user_id' not in session:
            return jsonify({"message": "User not logged in"})
    
    member_id = session['user_id']
    data = request.get_json()
    action = data.get('action')
    
    if action == 'join':
        conn = pymysql.connect(**config) 
        with conn.cursor() as cursor:
            query_check = "SELECT * FROM sessions WHERE id = %s"
            cursor.execute(query_check,(sessions_id,))
            result = cursor.fetchone()

            if result and result['host_id'] != member_id:
                query = ""
                if result['member1_id'] is None:
                    query = "UPDATE sessions SET member1_id = %s WHERE id = %s"
                elif result['member2_id'] is None:
                    query = "UPDATE sessions SET member2_id = %s WHERE id = %s"
                elif result['member3_id'] is None:
                    query = "UPDATE sessions SET member3_id = %s WHERE id = %s"
                elif result['member4_id'] is None:
                    query = "UPDATE sessions SET member4_id = %s WHERE id = %s"
                else:
                    return jsonify({"message" : "The session is full!"})
            
                if query:
                    cursor.execute(query, (member_id, sessions_id))
                    conn.commit()

                    # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
                    if cursor.rowcount > 0:
                        return jsonify({"message" : "User joined the session"})
                    else:
                        return jsonify({"message" : "User didn't join the session"})
            else: 
                return jsonify({"message" : "You are the host of the session"})
            
    return jsonify({"message": "Error joining the session"})


if __name__ == "__main__":
    app.run(debug=True)


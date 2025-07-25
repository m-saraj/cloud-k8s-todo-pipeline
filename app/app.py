from flask import Flask, request, jsonify, render_template

app = Flask(__name__)


# ✅ Homepage with HTML
@app.route("/", methods=["GET"])
def home():
    return render_template("index.html")


# ✅ Health check endpoint
@app.route("/healthz", methods=["GET"])
def health_check():
    return jsonify({"status": "OK"}), 200


# ✅ In-memory task list
tasks = []


@app.route("/tasks", methods=["GET"])
def get_tasks():
    return jsonify(tasks), 200


@app.route("/tasks", methods=["POST"])
def create_task():
    data = request.json
    if not data.get("title"):
        return jsonify({"error": "Title is required"}), 400
    task = {"id": len(tasks) + 1, "title": data["title"], "done": False}
    tasks.append(task)
    return jsonify(task), 201


@app.route("/tasks/<int:task_id>", methods=["PATCH"])
def update_task(task_id):
    for task in tasks:
        if task["id"] == task_id:
            task["done"] = True
            return jsonify(task), 200
    return jsonify({"error": "Task not found"}), 404


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    global tasks
    tasks = [task for task in tasks if task["id"] != task_id]
    return jsonify({"message": "Deleted"}), 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")

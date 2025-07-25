import json
from app.app import app



def test_health_check():
    tester = app.test_client()
    response = tester.get("/healthz")
    assert response.status_code == 200
    assert response.json == {"status": "OK"}


def test_get_tasks_empty():
    tester = app.test_client()
    response = tester.get("/tasks")
    assert response.status_code == 200
    assert response.json == []


def test_create_task():
    tester = app.test_client()
    response = tester.post(
        "/tasks",
        data=json.dumps({"title": "Test Task"}),
        content_type="application/json",
    )
    assert response.status_code == 201
    assert response.json["title"] == "Test Task"
    assert response.json["done"] is False

from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from supabase import create_client
import random
import os

load_dotenv(os.path.join(os.path.dirname(__file__), ".env"))

app = Flask(__name__)
CORS(app)

sb_url = os.environ.get("SUPABASE_URL")
sb_key = os.environ.get("SUPABASE_KEY")
sb = create_client(sb_url, sb_key)


def current_user():
    uid = request.headers.get("X-User-Id")
    if uid == None or uid == "":
        data = request.get_json(silent=True)
        if data != None:
            uid = data.get("user_id")
    return uid


def ensure_user(uid):
    if uid == None or uid == "":
        return
    res = sb.table("users").select("id").eq("username", uid).execute()
    if res.data == None or len(res.data) == 0:
        sb.table("users").insert({"username": uid}).execute()


def seed_if_empty():
    res = sb.table("challenges").select("id").execute()
    if res.data != None and len(res.data) > 0:
        return
    starter = [
        ("Wear your FASET shirt for a day", "Random"),
        ("No airpods for a day and walk around", "Fitness"),
        ("Get coffee with 4 shots of espresso", "Social"),
        ("Find a new building you've never seen", "Explore"),
        ("Do 20 jumping jacks on tech green", "Fitness"),
        ("Compliment a Kaldi's barista", "Social"),
        ("Take a photo of a friend without them knowing and send it to them", "Social"),
        ("Get someone's insta without telling them your name", "Social"),
        ("Meet someone from India Club", "Social"),
    ]
    ensure_user("adithya")
    rows = []
    for t, cat in starter:
        rows.append({"text": t, "category": cat, "created_by": "adithya"})
    sb.table("challenges").insert(rows).execute()


@app.route("/challenges/random", methods=["GET"])
def random_chall():
    res = sb.table("challenges").select("id, text, category, created_by, created_at").execute()
    rows = res.data
    if rows == None or len(rows) == 0:
        return jsonify({"error": "no challenges"}), 404
    r = random.choice(rows)
    return jsonify(r)


@app.route("/challenges", methods=["GET"])
def all_challs():
    res = sb.table("challenges").select("id, text, category, created_by, created_at").execute()
    rows = res.data
    if rows == None:
        rows = []
    return jsonify(rows)


@app.route("/challenges", methods=["POST"])
def add_chall():
    data = request.get_json()
    txt = data.get("text")
    cat = data.get("category")
    if cat == None or cat == "":
        cat = "Random"
    uid = current_user()
    if uid == None:
        uid = data.get("created_by")
    if uid == None or uid == "":
        uid = "anon"
    ensure_user(uid)
    if txt == None or txt.strip() == "":
        return jsonify({"error": "need text"}), 400
    res = sb.table("challenges").insert({"text": txt, "category": cat, "created_by": uid}).execute()
    row = res.data[0]
    return jsonify(row), 201


@app.route("/completions", methods=["POST"])
def add_completion():
    data = request.get_json()
    uid = current_user()
    if uid == None or uid == "":
        return jsonify({"error": "need user"}), 401
    ensure_user(uid)
    chall_id = data.get("challenge_id")
    if chall_id == None:
        return jsonify({"error": "need challenge_id"}), 400
    payload = {"challenge_id": chall_id, "user_id": uid}
    if data.get("lat") != None:
        payload["lat"] = data.get("lat")
    if data.get("lng") != None:
        payload["lng"] = data.get("lng")
    res = sb.table("completions").insert(payload).execute()
    row = res.data[0]
    return jsonify(row), 201


@app.route("/completions/<user>", methods=["GET"])
def user_completions(user):
    res = (
        sb.table("completions")
        .select("id, challenge_id, user_id, completed_at, lat, lng, challenges(text)")
        .eq("user_id", user)
        .order("completed_at", desc=True)
        .execute()
    )
    out = []
    if res.data == None:
        return jsonify(out)
    for r in res.data:
        txt = ""
        if r.get("challenges") != None:
            txt = r["challenges"]["text"]
        item = {
            "id": r["id"],
            "challenge_id": r["challenge_id"],
            "user_id": r["user_id"],
            "completed_at": r["completed_at"],
            "text": txt,
        }
        if r.get("lat") != None:
            item["lat"] = r["lat"]
        if r.get("lng") != None:
            item["lng"] = r["lng"]
        out.append(item)
    return jsonify(out)


if __name__ == "__main__":
    seed_if_empty()
    app.run(host="0.0.0.0", port=5050, debug=True)

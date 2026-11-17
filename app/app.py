import os
import socket
from decimal import Decimal

import psycopg2
from dotenv import load_dotenv
from flask import Flask, jsonify, request

# Les secrets sont lus depuis .env, à la racine du projet (non versionné)
RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
load_dotenv(os.path.join(RACINE, ".env"))

app = Flask(__name__)
SERVEUR = socket.gethostname()


def connexion():
    # Une connexion par requête : si la base revient, le service reprend sans redémarrage
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        connect_timeout=2,
    )


@app.route("/sante")
def sante():
    # Ne renvoie jamais 200 par principe : seul un SELECT réussi compte
    try:
        conn = connexion()
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
        finally:
            conn.close()
        return jsonify(statut="ok", server=SERVEUR), 200
    except Exception:
        return jsonify(statut="base indisponible", server=SERVEUR), 503


@app.route("/resultat")
def resultat():
    matricule = request.args.get("matricule", "").strip()
    if not matricule:
        return jsonify(erreur="paramètre matricule requis", server=SERVEUR), 400

    try:
        conn = connexion()
        try:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT matricule, nom, serie, moyenne, admis "
                    "FROM resultats WHERE matricule = %s",
                    (matricule,),
                )
                ligne = cur.fetchone()
        finally:
            conn.close()
    except Exception:
        return jsonify(erreur="base indisponible", server=SERVEUR), 503

    if ligne is None:
        return jsonify(found=False, server=SERVEUR), 404

    matricule, nom, serie, moyenne, admis = ligne
    if isinstance(moyenne, Decimal):
        moyenne = float(moyenne)
    return jsonify(
        found=True,
        candidat={"matricule": matricule, "nom": nom, "serie": serie,
                  "moyenne": moyenne, "admis": admis},
        server=SERVEUR,
    ), 200


@app.route("/info")
def info():
    return jsonify(server=SERVEUR)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
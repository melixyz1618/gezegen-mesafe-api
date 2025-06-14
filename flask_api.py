from flask import Flask, jsonify
from datetime import datetime
from skyfield.api import load_file, load

app = Flask(__name__)

planets = load_file('de421.bsp')
ts = load.timescale()
earth = planets['earth']

planet_names = [
    ('Mercury', 'Merkür'),
    ('Venus', 'Venüs'),
    ('Mars', 'Mars'),
    ('Jupiter Barycenter', 'Jüpiter'),
    ('Saturn Barycenter', 'Satürn'),
    ('Uranus Barycenter', 'Uranüs'),
    ('Neptune Barycenter', 'Neptün'),
    ('Sun', 'Güneş'),
    ('Moon', 'Ay')
]

@app.route('/mesafeler')
def get_distances():
    now = datetime.utcnow()
    t = ts.utc(now.year, now.month, now.day, now.hour, now.minute, now.second)

    veriler = []
    for eng_name, turkish_name in planet_names:
        planet = planets[eng_name]
        distance_au = earth.at(t).observe(planet).apparent().distance().au
        distance_km = distance_au * 149_597_870.7
        veriler.append({
            'gezegen': turkish_name,
            'mesafe_km': round(distance_km)
        })

    return jsonify({
        'zaman_utc': now.isoformat(),
        'veriler': veriler
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

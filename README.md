# Campus Quest

iOS app that gives you random campus challenges. SwiftUI + Flask + Supabase.

**Repo:** https://github.com/AdithyaRajesh1/CampusQuest  
**API:** https://campusquest-hw28.onrender.com/

## Run the app

1. Open `CampusQuest.xcodeproj` in Xcode
2. Pick your Apple team under Signing
3. Run on a simulator or your iPhone
4. Sign up and tap Give Me a Challenge

The app already uses the hosted API. First load after Render sleeps can take a bit.

Allow location and notifications if it asks.

## Run the backend locally (optional)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Put `SUPABASE_URL` and `SUPABASE_KEY` in `.env`, then:

```bash
python app.py
```

Runs on port 5050. If you do this, change `apiURL` in `CampusQuest/API.swift` to `http://127.0.0.1:5050` for the simulator.

# FullStack App
[demo video (please download first for best quality)](https://drive.google.com/file/d/1QSmQfVVjc-FAHOnpekFz9hqwt3JL2h8D/view?usp=sharing)

# Setup

## Backend

navigate to backend folder
```
cd backend
```

install dependencies
```
pip install -r requirements.txt
```

initialize gemini api key by editing `.env` file
```
GEMINI_API_KEY="<YOUR API KEY>"
```

run backend
```
python3 app.py
```

## Frontend

navigate to frontend folder
```
cd frontend
```

install dependencies
```
flutter pub get
```

list available emulators
```
flutter emulators
```

run specific emulator 
```
flutter emulators --launch <emulator-id>
```

run the app
```
flutter run
```

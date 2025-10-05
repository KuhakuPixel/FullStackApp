
# FullStack App

[demo video (please download first for best quality)](https://drive.google.com/file/d/1QSmQfVVjc-FAHOnpekFz9hqwt3JL2h8D/view?usp=sharing)

<br>

## 🚀 **Getting Started**

### Prerequisites

Make sure you have the following installed on your machine:

  - **Python 3.x**
  - **pip** (Python package installer)
  - **Flutter SDK**
  - **Git**
  - **Android Studio** (for the Android Emulator) or **VS Code** with Flutter extensions.

Once installed, verify your Flutter setup by running:

```bash
flutter doctor
```

Resolve any issues reported by the command.

### Getting the Code

First, clone the repository to your local machine:

```bash
git clone https://github.com/KuhakuPixel/FullStackApp
cd FullStackApp
```

## 💻 **Backend Setup**

### 1\. **Navigate to the Backend Directory**

```bash
cd backend
```

### 2\. **Create and Activate a Virtual Environment**

This is a recommended best practice to manage project dependencies.

```bash
python3 -m venv venv
```

Activate the virtual environment:

  - On macOS/Linux: `source venv/bin/activate`
  - On Windows: `.\venv\Scripts\activate`

### 3\. **Install Dependencies**

```bash
pip install -r requirements.txt
```

### 4\. **Initialize Gemini API Key**

Create a new file named **`.env`** in the `backend` folder.
Inside the file, add your Gemini API key:

```ini
GEMINI_API_KEY="<YOUR API KEY>"
```

### 5\. **Run the Backend Server**

```bash
python3 app.py
```

The server will start and be ready to accept requests.

### 6\. **Run Tests**

```bash
pytest test.py
```

## 📱 **Frontend Setup**

### 1\. **Navigate to the Frontend Directory**

```bash
cd frontend
```

### 2\. **Install Dependencies**

```bash
flutter pub get
```

### 3\. **Launch an Emulator or Connect a Device**

#### Option A: Using Command Line

List your available Android emulators:

```bash
flutter emulators
```

Launch a specific emulator using its ID:

```bash
flutter emulators --launch <emulator-id>
```

#### Option B: Using an IDE

  - In **Android Studio**, open the **Device Manager** and start a virtual device.
  - In **VS Code**, press `Ctrl+Shift+P`, type `Flutter: Launch Emulator`, select your desired emulator

#### Option C: Physical Device

Connect a physical device via USB with **USB Debugging** enabled.
Make sure your device is recognized by running:

```bash
flutter devices
```

### 4\. **Run the App**

With a device or emulator running, execute the following command:

```bash
flutter run
```

If multiple devices are detected, specify the device ID:

```bash
flutter run -d <device-id>
```

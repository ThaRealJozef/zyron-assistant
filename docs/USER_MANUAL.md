# 📖 User Manual

Welcome to your intelligent workspace. This manual covers how to interact with the **Pikachu Assistant** via **Telegram** and our experimental **Voice Control**.

---

> [!WARNING]
> **VOICE CONTROL STATUS: IN DEVELOPMENT**
> 
> The Voice Control mode is currently in an early experimental/development phase. While functional, there is **no guarantee of 100% accuracy, stability, or uptime**. Use with caution, especially when executing destructive commands.

---

## 📱 Telegram Remote Control (Stable)

Control your PC remotely from your phone with high reliability.

### **1. Getting Started**

1. **Open Telegram** on your phone or computer
2. **Search for your bot** (the username you created with @BotFather)
3. **Click Start** or type `/start`
4. A custom keyboard with quick action buttons will appear

---

### **2. The Command Menu**

When you type `/start` in the Telegram bot, a custom keyboard appears with these quick buttons:

| Button | Action |
|--------|--------|
| **📸 Screenshot** | Instantly takes a screenshot of your desktop and sends the image to you |
| **🔴 Camera On** | Starts a live webcam stream (sends a photo every 3 seconds) |
| **⚫ Camera Off** | Stops the webcam stream |
| **🔋 Battery** | Reports current charge status (percentage, charging/discharging) |
| **💤 Sleep** | Puts the remote PC to sleep mode |

**Usage Example:**

```
You: [Click 📸 Screenshot]
Bot: 📸 Screenshot captured!
     [Sends desktop image]
```

---

### **3. Text Commands**

You can type **natural language commands** just like you speak them. The AI "Brain" processes text exactly the same way it processes voice.

#### **App Control**

| You type... | System Action |
|-------------|---------------|
| `open calculator` | Launches the Windows Calculator app |
| `open chrome` | Opens Google Chrome browser |
| `open vs code` | Launches Visual Studio Code |
| `close spotify` | Force closes Spotify (without saving) |
| `close chrome` | Force closes Google Chrome |

**Example:**
```
You: open calculator
Bot: ✅ Opening Calculator...
```

---

#### **File Management**

| You type... | System Action |
|-------------|---------------|
| `list files in downloads` | Returns the top 20 files in your Downloads folder |
| `list files in documents` | Shows files in your Documents folder |
| `send me the file report.pdf` | Uploads `report.pdf` from your PC to Telegram |

**Example:**
```
You: list files in downloads
Bot: 📁 Files in Downloads:
     1. project_report.pdf
     2. vacation_photo.jpg
     3. setup.exe
     ...
```

---

#### **System Information**

| You type... | System Action |
|-------------|---------------|
| `check battery` | Shows battery percentage and charging status |
| `what time is it` | Returns current system time |
| `how much ram is being used` | Shows memory usage statistics |
| `cpu usage` | Reports CPU load percentage |

**Example:**
```
You: check battery
Bot: 🔋 Battery: 78% (Charging)
```

---

#### **Camera & Vision**

| You type... | System Action |
|-------------|---------------|
| `camera on` | Starts webcam streaming (photo every 3 seconds) |
| `camera off` | Stops webcam streaming |
| `take a photo` | Captures a single webcam frame |

**Privacy Note:** Only use camera commands when you're comfortable with your bot having access to your webcam.

---

#### **Navigation & Control**

| You type... | System Action |
|-------------|---------------|
| `press windows key` | Simulates pressing the Windows/Start key |
| `type hello world` | Types the text "hello world" |
| `go to sleep` | Puts PC into sleep mode |

---

#### **Memory & Personalization**

| You type... | System Action |
|-------------|---------------|
| `my name is Alex` | Saves "Alex" to long-term memory |
| `I am a developer` | Stores your profession for context |
| `remember that I like Python` | Adds preference to memory |

The assistant uses this information to provide better, personalized responses in future interactions.

---

### **4. Advanced Text Commands**

#### **Multi-Step Commands**

The assistant maintains **context** between messages:

```
You: open chrome
Bot: ✅ Opening Chrome...

You: close it
Bot: ✅ Closing Chrome...
```

The bot remembered that "it" refers to Chrome!

---

#### **Conversational Queries**

You can ask questions naturally:

```
You: what browser should I use for web development?
Bot: For web development, I recommend Google Chrome or 
     Microsoft Edge due to their excellent developer tools.
     Would you like me to open Chrome?
```

---

## 🗣️ Voice Control Mode (Beta / Experimental)

To use voice control, run `main.py` (or double-click `start_pikachu.bat`).

⚠️ **Important:** Because this feature is in active development, it may misinterpret commands or fail to trigger in noisy environments.

---

### **1. The Wake Word**

Start **every** command by saying one of the following:

- **"Hey Pikachu"**
- **"Pikachu"**
- **"Hey you"**

#### **How It Works:**

1. **Say the wake word**: "Pikachu"
2. **Wait for acknowledgment**: You'll hear a beep or see "Listening..." in the console
3. **Speak your command**: Clearly state what you want (e.g., "open calculator")
4. **Wait for response**: The assistant will confirm via text-to-speech

#### **Example Interaction:**

```
You: "Pikachu"
Assistant: [Beep sound] "Listening..."
You: "Open calculator"
Assistant: "Opening calculator..."
```

---

### **2. Voice Command Examples (Best Effort)**

| Category | You say... | System Action |
|----------|-----------|---------------|
| **Apps** | "Open VS Code" | Launches Visual Studio Code |
| | "Close Spotify" | Force closes Spotify |
| **System** | "Go to sleep" | Puts the Windows PC into Sleep mode |
| | "Press Windows key" | Opens the Start menu |
| **Information** | "Check battery" | Reads laptop battery percentage aloud |
| | "What time is it" | Speaks the current time |
| **Memory** | "My name is Alex" | Remembers your name in `long_term_memory.json` |
| | "Remember I'm a student" | Saves to long-term memory |

---

### **3. Voice Control Best Practices**

✅ **DO:**
- Speak clearly and at normal pace
- Use the wake word before EVERY command
- Wait for acknowledgment before speaking
- Keep commands short and direct
- Use in a quiet environment

❌ **DON'T:**
- Speak immediately after the wake word
- Use complex or multi-part sentences
- Expect 100% accuracy (it's experimental!)
- Rely on it for critical tasks

---

### **4. Troubleshooting Voice Control**

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| Wake word not detected | Background noise | Move to quieter room, adjust `energy_threshold` in `listener.py` |
| Commands misunderstood | Unclear speech | Speak slower and more clearly |
| No audio feedback | Speakers muted | Check volume settings, unmute PC |
| Assistant doesn't respond | Microphone not working | Check Windows privacy settings, verify microphone access |
| False wake word triggers | Sensitivity too high | Increase `energy_threshold` in configuration |

---

## 🧠 Memory & Context

The assistant has **Persistent Memory**. It remembers details about you and the current session.

### **Short-Term Memory (Session)**

Lasts only for the current conversation:

- **Last app opened**: "You just opened Chrome"
- **Recent actions**: "You asked me to sleep the PC 5 minutes ago"
- **Conversation flow**: Understands "it", "that", "the browser" based on context

**Example:**
```
You: open chrome
Bot: Opening Chrome...

You: maximize it
Bot: Maximizing Chrome...

You: close it
Bot: Closing Chrome...
```

---

### **Long-Term Memory (Persistent)**

Saved to `long_term_memory.json` and survives restarts:

- **User preferences**: "You prefer Python for scripting"
- **Personal details**: "Your name is Alex"
- **Custom shortcuts**: "You want 'music' to open Spotify"

**How to Add to Long-Term Memory:**

Via Telegram:
```
You: my name is Alex
Bot: ✅ I'll remember that your name is Alex.

You: I'm a developer
Bot: ✅ Noted. You're a developer.
```

Via Voice:
```
You: "Pikachu, remember I like coffee in the morning"
Bot: "I'll remember that you like coffee in the morning."
```

---

### **Viewing Your Memory**

```
You: what do you know about me?
Bot: Here's what I remember:
     - Name: Alex
     - Profession: Developer
     - Preferences: Likes Python, prefers Chrome
     - Last app opened: VS Code
```

---

### **Clearing Memory**

To reset long-term memory:

1. Navigate to the project folder
2. Delete `long_term_memory.json`
3. Restart the assistant

Or via command:
```
You: forget everything about me
Bot: ✅ Long-term memory cleared.
```

---

## ⚠️ Important Safety & Reliability Notes

### **1. No Guarantee on Voice**

Due to the experimental nature of the current voice engine, **do not rely on voice commands for critical tasks**. Always have the Telegram bot ready as a fallback.

**Recommended Use Cases for Voice:**
- ✅ Opening/closing applications
- ✅ Checking system information
- ✅ Casual queries

**Not Recommended for Voice:**
- ❌ File deletion
- ❌ System shutdown
- ❌ Financial transactions
- ❌ Anything requiring 100% accuracy

---

### **2. "Close App" is Aggressive**

The `close app` command uses **`taskkill /f`**. It does **not** ask to save your work.

**What this means:**
- Unsaved documents will be lost
- Applications are terminated immediately
- No "Are you sure?" prompt

**Best Practice:**
```
❌ BAD:  "Close Word" (when you have unsaved work)
✅ GOOD: Save your work manually, then say "Close Word"
```

---

### **3. Volume & Audio Feedback**

The assistant uses **Text-to-Speech (TTS)** for voice mode responses.

**Setup:**
- Ensure your PC **speakers are on**
- Set volume to a comfortable level
- Test with: "Pikachu, what time is it?"

**Adjusting TTS:**
- Speed: Edit `VOICE_RATE` in `.env` (default: 150)
- Volume: Edit `VOICE_VOLUME` in `.env` (default: 1.0)

---

### **4. Camera Privacy**

When using `camera on` command:

⚠️ **Your webcam is actively streaming to Telegram**

**Privacy Tips:**
- Only use in private settings
- Never share your bot token
- Add user restrictions (see [Configuration Guide](CONFIGURATION.md))
- Use `camera off` when done

---

### **5. File Access**

The bot can access **any file your Windows user can access**.

**Current Behavior:**
- Can list files in any directory
- Can send files from any location
- No sandboxing by default

**Recommendation:**
- See [Configuration Guide](CONFIGURATION.md) for sandboxing setup
- Don't share sensitive directories via commands

---

## 🎯 Common Use Cases

### **Scenario 1: Working From Phone**

```
[You're away from your PC]

You: screenshot
Bot: [Sends desktop image]

You: is VS Code still open?
Bot: Yes, VS Code is running.

You: close it
Bot: ✅ Closed VS Code.
```

---

### **Scenario 2: Hands-Free Computing**

```
[You're cooking and coding]

You: "Pikachu"
Bot: "Listening..."

You: "Open Spotify"
Bot: "Opening Spotify..."

You: "Pikachu"
You: "Play music"
Bot: "Playing music..."
```

---

### **Scenario 3: Quick System Checks**

```
You: battery
Bot: 🔋 45% (Discharging, ~2 hours remaining)

You: cpu usage
Bot: 💻 CPU: 23% | RAM: 8.2GB / 16GB
```

---

## 📊 Command Reference (Quick Sheet)

### **Telegram Commands**

| Command | Syntax | Example |
|---------|--------|---------|
| Screenshot | `/screenshot` or button | - |
| Battery | `/battery` or button | - |
| Camera | `camera on/off` | `camera on` |
| Open app | `open [app]` | `open chrome` |
| Close app | `close [app]` | `close spotify` |
| List files | `list files in [folder]` | `list files in downloads` |
| System info | `[metric]` | `cpu usage` |

### **Voice Commands**

All voice commands require the wake word first!

| Command Pattern | Example |
|----------------|---------|
| Open [app] | "Pikachu, open calculator" |
| Close [app] | "Pikachu, close chrome" |
| Check [status] | "Pikachu, check battery" |
| What [query] | "Pikachu, what time is it" |
| Remember [fact] | "Pikachu, remember I like tea" |

---

## 🆘 Getting Help

### **Built-in Help**

```
You: help
Bot: Here are available commands:
     - Open/Close apps
     - Camera control
     - Battery status
     - File listing
     ...
```

---

### **Feedback & Issues**

If you encounter bugs or have suggestions:

1. 📝 Open an issue on [GitHub](https://github.com/YOUR_USERNAME/pikachu-assistant/issues)
2. 💬 Include:
   - What you said/typed
   - Expected behavior
   - Actual behavior
   - Screenshots/logs if applicable

---

## 📚 Next Steps

- 🔧 [Configuration Guide](CONFIGURATION.md) - Customize settings
- 🏗️ [Architecture](ARCHITECTURE.md) - Understand how it works
- 💻 [Development Guide](DEVELOPMENT.md) - Add new features

---

**Enjoy your intelligent workspace! 🎉**

For quick help, type `help` in Telegram or say "Pikachu, help me" in voice mode.

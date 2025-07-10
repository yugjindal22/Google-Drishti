# Project Drishti

## 👥 Team AgenticFlow

**Team:** AgenticFlow - A team of driven developers building autonomous AI agents to tackle practical challenges — leveraging innovation, teamwork, and a strong problem-solving mindset, backed by our Smart India Hackathon 2024 win.

### Team Members

| Name                | Role        | Email                       |
| ------------------- | ----------- | --------------------------- |
| **Yug Jindal**      | Team Leader | yugjindal1234@gmail.com     |
| **Rishbh Arora**    | Developer   | vsryarora6879@gmail.com     |
| **Anjaneya Sharma** | Developer   | anjaneya.sharma25@gmail.com |
| **Krrish Sehgal**   | Developer   | krrishsehgal03@gmail.com    |

---

> ⚠️ **Note:** This project is a work-in-progress, being built for the **Google Cloud Agentic AI Hackathon (July 2025)** under **Problem Statement 3 – Improving Safety at Large Public Events**.

> So far, we've implemented the attendee mobile app core features and are actively building out the agent backend and admin systems.

---

## 🚨 Overview

**Project Drishti** is a fully agentic situational awareness platform designed to prevent disasters at crowded public events — concerts, rallies, religious gatherings, and more.

It combines real-time video intelligence, natural language agents, emergency dispatch logic, and predictive crowd forecasting to become the **AI-powered central nervous system of event safety**.

This repository contains the **entire codebase**:

- ✅ **Attendee mobile app** (Flutter)
- ✅ **Staff mobile interface**
- ⚙️ **Gemini agent backend** (Vertex AI Agents + LangGraph)
- 🖥️ **Admin dashboard + Gemini CLI interface** (Firebase + Maps + Veo)
- 🔌 **API gateways + Firestore + Maps integration**

---

## 🎯 Submitted for: Google Cloud Agentic AI Hackathon 2025

- **Track:** Safety
- **Problem Statement #3:** Improving Safety at Large Public Events
- **Team:** Project Drishti
- **Stack Used:** Vertex AI Agents, Gemini Flash, Gemini CLI, Firebase, Maps API, Veo 3, LangGraph

---

## 💡 Problem We’re Solving

At large-scale events, crowd surges, medical emergencies, and bottlenecks escalate in seconds. Traditional monitoring is **reactive and manual**. Security teams need to move from **monitoring → predicting → intervening** intelligently.

**Project Drishti** solves this by creating a network of Gemini agents that:

- Understand the crowd using cameras, sensors, and reports
- Predict dangerous patterns before they happen
- Respond autonomously to protect lives
- Empower admins and the crowd with live intelligence

---

## 🧠 Solution Overview

> Project Drishti is a **multi-agent AI platform** that:

- Observes crowd conditions (Vertex AI Vision)
- Predicts future congestion (Vertex Forecasting)
- Handles incidents (Gemini CLI + Agent Builder)
- Dispatches responders (GPS + Maps Routing)
- Keeps attendees informed (mobile app + Gemini assistant)

---

## 🧱 Architecture Snapshot

![Architecture Diagram](assets/drishti_architecture.png)

| Layer                        | Purpose                                                                        |
| ---------------------------- | ------------------------------------------------------------------------------ |
| **Mobile App (Flutter)**     | Interface for attendees and on-ground staff                                    |
| **Agent Intelligence Layer** | Gemini-based agents handle incident detection, dispatch, prediction, summaries |
| **Admin Interface**          | Firebase dashboard + Gemini CLI                                                |
| **Backend Infra**            | Firebase Auth, Firestore, Maps API, Vertex AI, Veo 3                           |

---

## 📱 Attendee App Features (Public Users)

| Feature                      | Description                                                          |
| ---------------------------- | -------------------------------------------------------------------- |
| 🗺 **Live Safety Map**        | Color-coded zones (green/yellow/red) using real-time video feeds     |
| 🧭 **Smart Navigation**      | Safest paths to exits or stalls using congestion data + Google Maps  |
| 🆘 **One-Tap SOS**           | Emergency reporting (medical, violence, etc) triggers agent dispatch |
| 🧒 **Lost & Found**          | Upload photo to locate missing child/person via Gemini Vision        |
| 🤖 **Gemini Chat Assistant** | Ask natural language queries like “Where’s nearest exit?”            |
| 🔊 **Panic Broadcasts**      | Receive calming messages + live alerts during emergencies            |
| 📸 **Replay Viewer**         | Watch Veo-powered incident replays from your current zone            |
| 😨 **Crowd Sentiment**       | Know if your zone is Calm / Alert / Panic via emotion detection      |

---

## 👮 Staff App Features (On-Ground Responders)

| Feature                          | Description                                              |
| -------------------------------- | -------------------------------------------------------- |
| 📍 **Live Incident Assignments** | Get real-time instructions from Dispatch Agent (via GPS) |
| 🗣 **Voice-to-Text Reports**      | Report incidents using speech (Gemini NLP)               |
| 📸 **Media Upload**              | Send photos/videos with tags (used by Veo + Admin)       |
| 🗺 **Live Navigation**            | Safest route to incident auto-shown via Google Maps      |
| 🔐 **Role-based Login**          | Auth via Firebase role access for security staff         |

---

## 🖥️ Admin Dashboard + Gemini CLI (Commander Interface)

| Tool              | Capabilities      |
| ----------------- | ----------------- |
| 🧠 **Gemini CLI** | Run queries like: |

- `summarize Red Zone incidents past 15 min`
- `replay crowd surge near Stage A`
- `dispatch 2 medics to Zone C`
  | 🔥 **Agent Engine** | Runs 8+ agents (incident, panic, forecast, dispatch, lost & found, anomaly, replay, sentiment)
  | 🗺️ **Live Heatmap Dashboard** | See real-time status of all zones (vision, sentiment, alerts)
  | 📢 **Mass Announcements** | Broadcast voice/text updates to crowd
  | 📽 **Veo Replay Viewer** | View automatic 30s incident replays

---

## 🔧 Tech Stack

| Layer              | Stack                                              |
| ------------------ | -------------------------------------------------- |
| **Frontend**       | Flutter (attendee & staff apps)                    |
| **Backend Agents** | Gemini CLI + Vertex Agent Builder + LangGraph      |
| **Cloud Infra**    | Firebase Auth, Firestore, Firebase Functions       |
| **Vision**         | Vertex AI Vision (CCTV + drone feeds)              |
| **Forecasting**    | Vertex AI Forecasting                              |
| **Multimodal**     | Gemini Multimodal (for anomalies, crowd sentiment) |
| **Maps**           | Google Maps API for navigation, routing            |
| **Video**          | Veo 3 for incident replay generation               |
| **Realtime**       | Firestore triggers + FCM notifications             |

---

## 🔨 Project Status

> ✅ = Done | 🚧 = In Progress | ⏳ = Planned

| Component                    | Status                       |
| ---------------------------- | ---------------------------- |
| 🧍 Attendee App Core UI      | ✅ Done                      |
| 👮 Staff App Interface       | ✅ Done                      |
| 🧠 Gemini Agent Setup        | ✅ Core agents integrated    |
| 📢 Admin CLI Interface       | 🚧 Implementing CLI commands |
| 🗺️ Realtime Safety Map       | ✅ Done                      |
| 📸 Veo Replay Viewer         | 🚧 Integrating Veo SDK       |
| 🧒 Lost & Found AI Search    | ✅ Working                   |
| 🔊 Emotion/Panic Agent       | ✅ Initial prototype         |
| 🔧 Firebase Role Auth        | ✅ Done                      |
| 🔀 Agent Routing (LangGraph) | ✅ Working with CLI          |
| 📦 Deployment & Hosting      | 🚧 Ongoing                   |

---

## 📦 Project Structure

```

project-drishti/
├── mobile/                # Flutter app (attendee + staff modes)
├── backend/
│   ├── agents/            # Vertex AI + Gemini agent logic
│   ├── langgraph/         # LangGraph flow controller
│   ├── firebase/          # Auth + Firestore setup
│   └── api/               # API endpoints
├── dashboard/             # Firebase web dashboard + CLI tools
├── assets/                # Diagrams, mockups, UI assets
└── README.md

```

---

## 🧪 Local Setup Instructions

> Requirements: Flutter, Firebase CLI, Node.js

### 1. Clone the Repo

```bash
git clone https://github.com/YOUR_USERNAME/project-drishti.git
cd project-drishti
```

### 2. Setup Firebase

- Enable:

  - Firebase Auth (OTP login)
  - Firestore
  - Firebase Functions

- Add `google-services.json` in `mobile/android/app`

### 3. Install Mobile App

```bash
cd mobile/
flutter pub get
flutter run
```

Best Pickup Station Finder – Optimization Project

A web-based information system developed as part of an Operations Research course. The goal of this project is to solve a real-world problem: finding the optimal pickup station for a group of people based on their home addresses using distance-based heuristics.

📌 Project Summary
Organizing group transportation for events such as weddings, schools, or company outings is often inefficient. This project aims to simplify the process by identifying the pickup point closest to the majority of participants using a custom-developed heuristic algorithm.

The system allows users to input multiple addresses and computes the location (from the input list) that minimizes the average distance to all other addresses — providing the most efficient pickup spot.

🚀 Key Features
📍 Address-to-Coordinate Conversion using the OpenStreetMap Nominatim API

🧠 Heuristic Algorithm to calculate average distances between addresses

🗺️ Interactive Web Map to display user-input addresses and the optimal station

⚙️ Client-Side Implementation using:

HTML & CSS for UI

JavaScript for logic and API integration

🧪 Robust Error Handling for invalid inputs and edge cases

🔁 Dynamic Interface with address deletion and real-time recalculations

📐 Algorithm Overview
Each address is converted into geographic coordinates.

The algorithm computes the average distance between each point and all others.

The address with the lowest average distance is selected as the optimal pickup point.

📉 Complexity: O(n²) – the algorithm iterates through every pair of addresses.

This is a heuristic solution and does not account for traffic conditions or road networks.

🧪 Testing & Validation
The system was tested with various real-world scenarios:

Clusters of addresses

Widely spread locations

Invalid address inputs

Real-time address deletions

Improvements were made based on observed bugs, such as fixing issues with address deletion not updating the underlying data correctly.

🛠 Technologies Used
JavaScript

HTML5 / CSS3

OpenStreetMap API

Visual Studio Code

📊 Performance Metrics
🔁 Reduction in total travel distance for passengers

🚍 Increase in ride participation after optimized station selection

💰 Lower average cost per rider due to more efficient routing

📈 Project Methodology
✅ Agile Development: Bi-weekly sprints and team meetings

🔄 SPSI Framework: Symptom → Problem → Solution → Implementation

👥 Team collaboration: Two developers (JavaScript) and two project managers (planning, documentation)

🔄 Future Work
🧭 Add support for multiple pickup stations using clustering algorithms

🚏 Integration of real-world road networks and traffic data

🧠 Use of AI optimization models (e.g., Traveling Salesman Problem for routing)

📊 Exportable reports for logistics teams or event organizers
Classification of Hotel Reviews using Embeddings & BigQuery Integration

This notebook demonstrates a complete pipeline for classifying hotel reviews using semantic embeddings and integrating the results with Google BigQuery. The process combines NLP techniques, embedding-based similarity matching, and cloud-based data storage for scalable insights.

🚀 Project Objectives
Load and preprocess hotel review data.

Generate embeddings for textual reviews using OpenAI’s embedding models.

Perform semantic similarity classification by comparing reviews with predefined category embeddings.

Integrate and export the processed results into Google BigQuery for analytics and visualization.

🧰 Technologies Used
Python (Pandas, Numpy)

OpenAI API – for generating embeddings.

Google BigQuery – for scalable cloud-based data storage and analysis.

Google Cloud SDK – for authentication and dataset access.

LangChain – for structured prompt formatting and potential agent integration.

📝 Main Features
Multi-label Classification: Each review is semantically compared to multiple predefined labels (e.g., cleanliness, location, service).

Cosine Similarity Matching: For each label, a score is computed using cosine similarity to determine relevance.

BigQuery Export: Automatically writes the final labeled dataset to a BigQuery table for further BI/dashboard use.
❄️ Snowflake 


🎯 Project Objective

Data Engineering | Cloud Analytics Pipeline (Snowflake + S3)
Project delivered as an independent consultant

Developed an end-to-end data pipeline for a business analytics use case. 

The project involved loading raw data from S3 into Snowflake, implementing a multi-stage data model with clear separation of concerns, and delivering business-ready analytical queries.

Focus: A production-oriented, architectural approach ensuring data integrity, performance, and clarity across each layer: ingestion → modeling → transformation → consumption.

🧱 Logical Architecture

The project follows a classic three-layer analytical architecture:

1. Ingestion Layer (raw / staging)

Load CSV files from an S3 bucket into Snowflake

Manage format and data quality issues

Fine control of COPY INTO parameters

2. Modeling Layer (star schema)

Transform normalized data

Build an analysis-oriented model (facts & dimensions)

Optimize for analytical queries

3. Consumption Layer

Business SQL queries

Persist query results into usable files

Approach similar to an analytical data mart

📦 Archive Contents
1️⃣ init.sql – Ingestion & Initialization

This script includes:

Creation of Snowflake tables

Loading data from S3 (s3://course-snowflakes/sample/music/)

Handling real data engineering issues:

CSV column mismatch

Invalid numeric values

Continuing load despite errors (ON_ERROR = CONTINUE)

Custom file formats (csv_error)

🎯 Goal: ensure robust ingestion that tolerates imperfect source data.

2️⃣ doc.txt – Transformation Approach

This document details, step by step:

The reasoning behind transforming normalized data

The transition to a star schema

Modeling choices to analyze tracks on CDs

🎯 Goal: demonstrate the ability to design an analytical model, not just write SQL.

3️⃣ star.sql – Analytical Modeling

This script implements:

Fact tables

Dimension tables

A structure suitable for analyzing performance, duration, genres, artists, and albums

🎯 Goal: provide a performant foundation for decision-making analytics.

4️⃣ query.sql – Business Queries

This file contains queries answering concrete analytical questions, such as:

Multi-CD albums

Tracks by production year

Genre-based analysis

Artist performance analysis

Average track duration

Cross-analysis between artists, playlists, and countries

🎯 Goal: demonstrate the ability to translate business needs into analytical SQL queries.

5️⃣ answer.txt – Results

Stores the output of the queries

Clear separation between computation and reporting

Similar logic to a client or BI deliverable

🧠 Skills Demonstrated

❄️ Snowflake (SQL, COPY INTO, File Formats)

☁️ Data ingestion from S3

🧩 Dimensional modeling (star schema)

🛠️ Data error handling

📊 Advanced analytical SQL

🏗️ Data Engineering / Data Architecture mindset

📁 Professional data project structuring

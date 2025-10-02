CREATE DATABASE IF NOT EXISTS portfolio_db;
USE portfolio_db;

CREATE TABLE IF NOT EXISTS contacts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200),
  description TEXT,
  image VARCHAR(255),
  link VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO projects (title, description, image, link) VALUES
('Cloud Infra Automation', 'Automated infra provisioning with Terraform and CI/CD.', 'images/cloud_infra.svg', '#'),
('Real-time Monitoring', 'Monitoring solution using Prometheus & Grafana.', 'images/monitoring.svg', '#'),
('Serverless App', 'Serverless file processing app on AWS Lambda.', 'images/serverless.svg', '#');

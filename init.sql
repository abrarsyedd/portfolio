CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  image VARCHAR(255),
  link VARCHAR(255)
);

INSERT INTO projects (title, description, image, link) VALUES
('Cloud Infra Automation', 'Automated infra provisioning with Terraform and CI/CD.', 'images/cloud_infra.svg', '#'),
('Serverless App', 'Built serverless stack with AWS Lambda + API Gateway.', 'images/serverless.svg', '#');


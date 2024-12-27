CREATE DATABASE IF NOT EXISTS gitlabhq_production;
CREATE USER IF NOT EXISTS gitlab WITH PASSWORD 'gitlabpass';
GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production TO gitlab;

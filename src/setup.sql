DROP DATABASE IF EXISTS silvercare;
CREATE DATABASE IF NOT EXISTS silvercare;
USE silvercare;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    zipcode VARCHAR(10)
) ENGINE=InnoDB;

INSERT INTO customers (username, password, full_name, email, phone, address, zipcode)
VALUES (
    'testuser',
    '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',
    'Test User',
    'testuser@example.com',
    '90000000',
    '123 test street',
    '123456'
);

CREATE TABLE service_category (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB;

INSERT INTO service_category (cat_id, name, description, image_url)
VALUES
(1, 'Personal Care', 'Services that support seniors with daily self-care tasks.', ''),
(2, 'Home Support', 'Practical help with household tasks.', ''),
(3, 'Social & Wellness Services', 'Services that support mental and emotional wellbeing.', '');

CREATE TABLE service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    cat_id INT,
    FOREIGN KEY (cat_id) REFERENCES service_category(cat_id)
) ENGINE=InnoDB;

INSERT INTO service (name, description, price, image_url, cat_id)
VALUES
('Bathing Assistance', '', 35.00, '', 1),
('Medication Reminder', '', 20.00, '', 1),
('Walking Support', '', 30.00, '', 1),
('Housekeeping', '', 25.00, '', 2),
('Laundry', '', 22.00, '', 2),
('Meal Preparation', '', 35.00, '', 2),
('Companionship', '', 40.00, '', 3),
('Medical Escort', '', 50.00, '', 3),
('Cognitive Activities', '', 28.00, '', 3);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB;

INSERT INTO bookings (customer_id, booking_date, status) VALUES
(1, NOW() - INTERVAL 2 DAY, 3),
(1, NOW() - INTERVAL 8 DAY, 3),
(1, NOW() - INTERVAL 30 DAY, 3),
(1, NOW() - INTERVAL 150 DAY, 3),
(1, NOW() - INTERVAL 380 DAY, 3);

CREATE TABLE caregiver (
    caregiver_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    years_experience INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 4.5,
    description VARCHAR(255),
    photo_url VARCHAR(255)
) ENGINE=InnoDB;

INSERT INTO caregiver (full_name, gender, years_experience, rating, description, photo_url)
VALUES
('Alice Tan', 'Female', 5, 4.7, '', ''),
('Benjamin Lee', 'Male', 7, 4.9, '', '');

CREATE TABLE caregiver_user (
    caregiver_user_id INT AUTO_INCREMENT PRIMARY KEY,
    caregiver_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
) ENGINE=InnoDB;

INSERT INTO caregiver_user (caregiver_id, username, password)
VALUES (1, 'cg1', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

CREATE TABLE booking_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    caregiver_id INT NULL,
    quantity INT DEFAULT 1,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    subtotal DECIMAL(10,2),
    special_request VARCHAR(255),
    caregiver_status TINYINT NOT NULL DEFAULT 0,
    check_in_at DATETIME NULL,
    check_out_at DATETIME NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (service_id) REFERENCES service(service_id),
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
) ENGINE=InnoDB;

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status)
VALUES
(1, 1, 1, 1, NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 1 DAY + INTERVAL 1 HOUR, 35.00, 'Bathing assistance', 2),
(1, 2, 1, 1, NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 1 HOUR, 20.00, 'Medication reminder', 1),
(2, 3, 1, 1, NOW() + INTERVAL 30 MINUTE, NOW() + INTERVAL 1 HOUR + INTERVAL 30 MINUTE, 30.00, 'Walking support', 0),
(3, 6, 1, 1, NOW() + INTERVAL 4 HOUR, NOW() + INTERVAL 5 HOUR, 35.00, 'Meal prep', 0),
(4, 7, 1, 1, NOW() + INTERVAL 1 DAY, NOW() + INTERVAL 1 DAY + INTERVAL 1 HOUR, 40.00, 'Companionship visit', 0),
(5, 8, 1, 1, NOW() + INTERVAL 7 DAY, NOW() + INTERVAL 7 DAY + INTERVAL 2 HOUR, 50.00, 'Medical escort', 0);

CREATE TABLE admin_user (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100),
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

INSERT INTO admin_user (username, email, password)
VALUES ('admin', 'admin@example.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9');

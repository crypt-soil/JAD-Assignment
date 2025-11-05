-- Create database (you can rename it)
CREATE DATABASE IF NOT EXISTS silvercare;
USE silvercare;

-- ==============================
-- Table: customers
-- ==============================
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,      -- ensure unique login
    password VARCHAR(255) NOT NULL,            -- remember to hash (e.g. SHA-256, bcrypt)
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,                 -- for password recovery & notifications
    phone VARCHAR(20),
    address VARCHAR(255),
    zipcode VARCHAR(10)
) ENGINE=InnoDB;

-- ====================================
-- Populate customers (8 users)
-- ====================================
INSERT INTO customers (username, password, full_name, email, phone, address, zipcode)
VALUES
('alice123', 'pass123', 'Alice Tan', 'alice.tan@example.com', '91234567', '123 Bedok North Ave 3', '460123'),
('bryan_l', 'abc456', 'Bryan Lim', 'bryan.lim@example.com', '98765432', '45 Choa Chu Kang Ave 4', '689045'),
('charlene', 'hello789', 'Charlene Goh', 'charlene.goh@example.com', '97451236', '89 Pasir Ris St 12', '519089'),
('danielng', 'secure888', 'Daniel Ng', 'daniel.ng@example.com', '96996655', '32 Bukit Batok West Ave 7', '650032'),
('eliza', 'mypwd123', 'Eliza Koh', 'eliza.koh@example.com', '93334455', '22 Serangoon Ave 3', '550022'),
('felix_t', 'pwd999', 'Felix Tan', 'felix.tan@example.com', '98112233', '11 Punggol Field', '828711'),
('gloriaw', 'happy456', 'Gloria Wong', 'gloria.wong@example.com', '96553322', '77 Tampines Ave 5', '520077'),
('harry_ong', 'silver2025', 'Harry Ong', 'harry.ong@example.com', '91227654', '99 Yishun Ring Rd', '760099');

-- ==============================
-- Table: service_category
-- ==============================
CREATE TABLE IF NOT EXISTS service_category (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)                     -- store relative path like '/images/elderly.png'
) ENGINE=InnoDB;

-- ==============================
-- Table: service
-- ==============================
CREATE TABLE IF NOT EXISTS service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    cat_id INT,
    FOREIGN KEY (cat_id) REFERENCES service_category(cat_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================
-- Table: bookings
-- ==============================
CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 1,                      -- 1=Pending, 2=Confirmed, 3=Completed, 4=Cancelled
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================
-- Table: booking_details
-- ==============================
CREATE TABLE IF NOT EXISTS booking_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    quantity INT DEFAULT 1,
    start_time DATETIME,
    end_time DATETIME,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================
-- Table: feedback
-- ==============================
CREATE TABLE IF NOT EXISTS feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    remarks VARCHAR(255),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================
-- Table: admin_user
-- ==============================
CREATE TABLE IF NOT EXISTS admin_user (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- ====================================
-- Populate admin_user
-- ====================================
INSERT INTO admin_user (username, password)
VALUES ('admin', 'admin123');

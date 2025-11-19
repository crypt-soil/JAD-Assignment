SELECT * FROM silvercare.admin_user;
-- drop database and recreate
DROP DATABASE IF EXISTS silvercare;
CREATE DATABASE IF NOT EXISTS silvercare;
USE silvercare;

-- table: customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,      -- ensure unique login
    password VARCHAR(255) NOT NULL,            -- remember to hash (e.g. sha-256, bcrypt)
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,                 -- for password recovery & notifications
    phone VARCHAR(20),
    address VARCHAR(255),
    zipcode VARCHAR(10)
) ENGINE=InnoDB;

-- insert 1 dummy customer for fk and analytics
-- original password for testuser: password
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

-- table: service_category
CREATE TABLE service_category (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)                     -- store relative path or full image url
) ENGINE=InnoDB;

-- insert service categories
INSERT INTO service_category (cat_id, name, description, image_url)
VALUES
(1, 'Personal Care',
 'Services that support seniors with daily self-care tasks. These include assistance with bathing, grooming, medication reminders, and mobility support to help them stay safe, comfortable, and independent at home.',
 'https://justinvillacare.com/wp-content/uploads/2021/10/Dressing-and-Grooming-Caregiver-Services-For-Seniors-Orange-County.jpg'),
(2, 'Home Support',
 'Practical help with maintaining a clean, safe, and organised living environment. This covers light housekeeping, meal preparation, laundry, and basic home tasks that reduce physical strain for seniors.',
 'https://static.vecteezy.com/system/resources/previews/021/780/287/non_2x/happy-family-walking-together-in-the-garden-old-elderly-using-a-walking-stick-to-help-walk-balance-concept-of-love-and-care-of-the-family-and-health-insurance-for-family-photo.jpg'),
(3, 'Social & Wellness Services',
 'Services that enhance emotional well-being and mental engagement. These include companionship visits, social activities, medical escorting, and cognitive exercises designed to prevent loneliness and keep seniors active.',
 'https://allsaintsseniorliving.com/wp-content/uploads/2023/04/How-Social-Connections-Keep-Seniors-Healthy-Hero.jpg');

-- table: service
CREATE TABLE service (
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

-- insert services (3 per category)
INSERT INTO service (name, description, price, image_url, cat_id)
VALUES
-- ===== category 1: personal care =====
('Bathing & Grooming Assistance',
 'Helps seniors stay clean and maintain self-confidence. Caregivers assist with showering, sponging, oral hygiene, and dressing.',
 35.00,
 'https://cdn.prod-carehubs.net/n1/802899ec472ea3d8/uploads/2022/11/AdobeStock_366108919-scaled.jpeg',
 1),
('Medication Reminder Support',
 'Ensures timely and accurate medication intake. Caregivers assist with labeling, preparing pill boxes, and reminders.',
 20.00,
 'https://www.homecareassistancetracy.com/wp-content/uploads/2020/12/5-Medications-that-Help-Manage-Sleep-Disorders-in-Seniors-in-Stockton-CA.jpg',
 1),
('Mobility & Walking Assistance',
 'Supports seniors who have difficulty walking or require supervision to move safely around the home.',
 30.00,
 'https://www.arthritis.org/getmedia/2c9df4a3-45b0-4197-b300-71cca3bba93b/walking-fb-og.jpg',
 1),

-- ===== category 2: home support =====
('Light Housekeeping',
 'Basic cleaning tasks including sweeping, mopping, dusting, and keeping living spaces safe and tidy.',
 25.00,
 'https://cdn.shopify.com/s/files/1/0273/4810/9812/articles/Summer_House_cleaning.jpg?v=1652752163',
 2),
('Laundry & Ironing Assistance',
 'Caregivers help wash, fold, and iron clothes to support seniors who have difficulty managing laundry on their own.',
 22.00,
 'https://www.thespruce.com/thmb/jLecWzMp0e0wiNmbPSrN91z0zQ8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/washandfoldLaundry-GettyImages-612733926-5ad60a67875db900372c59a5.jpg',
 2),
('Meal Preparation',
 'Prepares nutritious meals suited to dietary needs. Includes planning, cooking, and cleaning up after meals.',
 35.00,
 'https://www.eatright.org/-/media/eatrightimages/food/nutrition/agingwellwithnutrition/whatolderadultsneedtoknowaboutfoodandnutrition/olderadults_cooking_gettyimages-1056482120_600x450.jpg',
 2),

-- ===== category 3: social & wellness services =====
('Companionship Visits',
 'Provides emotional support through conversation, games, and social interaction to reduce loneliness.',
 40.00,
 'https://cdn.carelinkathome.com/wp-content/uploads/2020/10/23123141/companionship.jpg',
 3),
('Outdoor & Medical Escort',
 'Caregivers accompany seniors to medical appointments, grocery trips, or casual outdoor walks for safety.',
 50.00,
 'https://cdn.lovetoknow.com/images/opt/orig/268910-1600x1067-elderly-woman-wheelchair-assistance.jpg',
 3),
('Cognitive & Memory Activities',
 'Engaging activities such as puzzles, memory games, and mental exercises designed to improve cognitive health.',
 28.00,
 'https://cdn.britannica.com/51/170751-050-45C44A53/Volunteer-nursing-home.jpg',
 3);

-- table: bookings
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 1,                      --  1=pending, 2=confirmed, 3=completed, 4=cancelled
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert sample bookings for analytics
INSERT INTO bookings (customer_id, booking_date, status) VALUES
(1, NOW() - INTERVAL 2 DAY, 3),        -- this week
(1, NOW() - INTERVAL 8 DAY, 3),        -- this month
(1, NOW() - INTERVAL 30 DAY, 3),       -- this year
(1, NOW() - INTERVAL 150 DAY, 3),      -- this year
(1, NOW() - INTERVAL 380 DAY, 3);      -- last year (excluded from current year)

-- table: booking_details
CREATE TABLE booking_details (
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

-- insert booking details for revenue and popular service
INSERT INTO booking_details (booking_id, service_id, quantity, subtotal) VALUES
-- this week (booking 1)
(1, 1, 1, 35.00),   -- bathing assistance
(1, 2, 1, 20.00),   -- medication reminder

-- this month (booking 2)
(2, 6, 1, 35.00),   -- meal preparation
(2, 4, 1, 25.00),   -- light housekeeping

-- this year (booking 3)
(3, 8, 1, 50.00),   -- outdoor escort

-- this year (booking 4)
(4, 7, 1, 40.00),   -- companionship visits
(4, 9, 1, 28.00),   -- cognitive & memory activities

-- last year (booking 5)
(5, 4, 1, 40.00);   -- light housekeeping (excluded from current year)

-- table: feedback
CREATE TABLE feedback (
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

-- table: admin_user
CREATE TABLE admin_user (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- insert admin user
-- original password for admin: admin123
INSERT INTO admin_user (username, email, password)
VALUES (
    'admin',
    'admin@example.com',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9'
);

-- drop existing procedures and function if any
DROP PROCEDURE IF EXISTS sp_total_users;
DROP PROCEDURE IF EXISTS sp_popular_service;
DROP FUNCTION IF EXISTS fn_revenue;

--stored procedures and function for analytics dashboard
DELIMITER $$

CREATE PROCEDURE sp_total_users()
BEGIN
   SELECT COUNT(*) AS total FROM customers;
END $$

CREATE PROCEDURE sp_popular_service()
BEGIN
    SELECT s.name, SUM(bd.quantity) AS total_booked
    FROM booking_details bd
    JOIN service s ON bd.service_id = s.service_id
    GROUP BY s.service_id
    ORDER BY total_booked DESC
    LIMIT 1;
END $$

CREATE FUNCTION fn_revenue(rangeType VARCHAR(10))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE rev DECIMAL(10,2);

    IF rangeType = 'week' THEN
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEARWEEK(b.booking_date, 1) = YEARWEEK(CURDATE(), 1);

    ELSEIF rangeType = 'month' THEN
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEAR(b.booking_date) = YEAR(CURDATE())
          AND MONTH(b.booking_date) = MONTH(CURDATE());

    ELSE
        SELECT IFNULL(SUM(bd.subtotal), 0)
          INTO rev
        FROM bookings b
        JOIN booking_details bd ON b.booking_id = bd.booking_id
        WHERE YEAR(b.booking_date) = YEAR(CURDATE());
    END IF;

    RETURN rev;
END $$

DELIMITER ;

DESCRIBE customers;


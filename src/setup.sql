-- drop database and recreate
DROP DATABASE IF EXISTS silvercare;
CREATE DATABASE IF NOT EXISTS silvercare;
USE silvercare;





-- table: customers
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

-- 1 row per customer (simple)
CREATE TABLE customer_medical_info (
    medical_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    medical_info TEXT NULL,                  -- asthma, diabetes, allergies, care notes
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- allow multiple contacts per customer
CREATE TABLE emergency_contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50) NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;


INSERT INTO customer_medical_info (customer_id, medical_info)
VALUES (1, 'Asthma');

INSERT INTO emergency_contacts (customer_id, contact_name, relationship, phone)
VALUES
(1, 'Mum Tan', 'Mother', '91234567'),
(1, 'Dad Tan', 'Father', '98765432');


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
    status TINYINT NOT NULL DEFAULT 1,         -- 1=active, 0=inactive
    FOREIGN KEY (cat_id) REFERENCES service_category(cat_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert services (3 per category)
INSERT INTO service (name, description, price, image_url, cat_id, status)
VALUES
-- ===== category 1: personal care =====
('Bathing & Grooming Assistance',
 'Helps seniors stay clean and maintain self-confidence. Caregivers assist with showering, sponging, oral hygiene, and dressing.',
 35.00,
 'https://tse1.mm.bing.net/th/id/OIP.jBsQL9Bkk7m_w1zw9J03GwHaEq?pid=Api&P=0&h=180',
 1,
 1),
('Medication Reminder Support',
 'Ensures timely and accurate medication intake. Caregivers assist with labeling, preparing pill boxes, and reminders.',
 20.00,
 'https://www.elderly-homecare.com/wp-content/uploads/2019/08/Nurse-Helping-Senior-Man-To-Organize-Medication.jpg',
 1,
 1),
('Mobility & Walking Assistance',
 'Supports seniors who have difficulty walking or require supervision to move safely around the home.',
 30.00,
 'https://blog.honestmed.com/wp-content/uploads/2023/08/Blog-Main-Image-Best-Mobility-Aids-Web-Optimized.png',
 1,
 1),

-- ===== category 2: home support =====
('Light Housekeeping',
 'Basic cleaning tasks including sweeping, mopping, dusting, and keeping living spaces safe and tidy.',
 25.00,
 'https://fastmaidservice.com/wp-content/uploads/2022/01/Deep-Cleaning-and-Housekeeping-Services.jpg',
 2,
 1),
('Laundry & Ironing Assistance',
 'Caregivers help wash, fold, and iron clothes to support seniors who have difficulty managing laundry on their own.',
 22.00,
 'https://www.aidby.com/_next/static/media/laundry_image3.520466cc.jpg',
 2,
 1),
('Meal Preparation',
 'Prepares nutritious meals suited to dietary needs. Includes planning, cooking, and cleaning up after meals.',
 35.00,
 'https://www.bayshore.ca/wp-content/uploads/2018/03/Services-Meal-Prep-1350x850.jpg',
 2,
 1),

-- ===== category 3: social & wellness services =====
('Companionship Visits',
 'Provides emotional support through conversation, games, and social interaction to reduce loneliness.',
 40.00,
 'https://uploads-ssl.webflow.com/5de31e9059d27b1b2e24e0d8/5e850bd24f3580899765a71c_Senior%20Visit%20in%20home.jpg',
 3,
 1),
('Outdoor & Medical Companion',
 'Caregivers accompany seniors to medical appointments, grocery trips, or casual outdoor walks for safety.',
 50.00,
 'https://img.freepik.com/premium-photo/senior-woman-walker-nurse-outdoor-park-with-healthcare-elderly-exercise-walking-healthcare-professional-female-person-with-peace-physical-therapy-public-garden-with-carer_590464-279351.jpg?w=2000',
 3,
 1),
('Cognitive & Memory Activities',
 'Engaging activities such as puzzles, memory games, and mental exercises designed to improve cognitive health.',
 28.00,
 'https://www.setxseniors.com/wp-content/uploads/2014/03/game-night-southeast-texas-senior-citizens-1024x664.jpg',
 3,
 1);

-- table: bookings
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 1,                      -- 1=pending, 2=confirmed, 3=completed, 4=cancelled
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert sample bookings for analytics
-- status seeded as confirmed for current and future bookings
INSERT INTO bookings (customer_id, booking_date, status) VALUES
(1, NOW(), 2),
(1, NOW() + INTERVAL 1 DAY, 2),
(1, NOW() + INTERVAL 3 DAY, 2),
(1, NOW() + INTERVAL 7 DAY, 2),
(1, NOW() + INTERVAL 14 DAY, 2);

-- table: caregiver
CREATE TABLE caregiver (
    caregiver_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
	email VARCHAR(100),
    gender VARCHAR(10),
    years_experience INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 4.5,
    description VARCHAR(255),
    photo_url VARCHAR(255)
) ENGINE=InnoDB;

-- insert caregivers
INSERT INTO caregiver (full_name, gender, years_experience, rating, description, photo_url, phone, email)
VALUES
('Alice Tan', 'Female', 5, 4.7,
 'Experienced in personal hygiene care and mobility support.',
 'https://randomuser.me/api/portraits/women/65.jpg',
 '91234567',
 'alice.tan@silvercare.com'),
('Benjamin Lee', 'Male', 7, 4.9,
 'Expert in medication management and senior care.',
 'https://randomuser.me/api/portraits/men/32.jpg',
 '92345678',
 'benjamin.lee@silvercare.com'),
('Clara Lim', 'Female', 4, 4.6,
 'Strong background in dementia care and patient communication.',
 'https://randomuser.me/api/portraits/women/44.jpg',
 '93456789',
 'clara.lim@silvercare.com'),
('David Wong', 'Male', 3, 4.3,
 'Friendly caregiver skilled in housekeeping and light chores.',
 'https://randomuser.me/api/portraits/men/52.jpg',
 '94567890',
 'david.wong@silvercare.com'),
('Evelyn Koh', 'Female', 6, 4.8,
 'Specializes in meal prep tailored to dietary needs.',
 'https://randomuser.me/api/portraits/women/78.jpg',
 '95678901',
 'evelyn.koh@silvercare.com'),
('Farah Noor', 'Female', 8, 4.9,
 'Experienced escort caregiver for outings & medical appointments.',
 'https://randomuser.me/api/portraits/women/23.jpg',
 '96789012',
 'farah.noor@silvercare.com');

-- table: caregiver_user
CREATE TABLE caregiver_user (
    caregiver_user_id INT AUTO_INCREMENT PRIMARY KEY,
    caregiver_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert caregiver login accounts
-- password is password
INSERT INTO caregiver_user (caregiver_id, username, password)
VALUES
(1, 'cg1', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
(2, 'cg2', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
(3, 'cg3', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
(4, 'cg4', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
(5, 'cg5', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'),
(6, 'cg6', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

-- BRIDGE TABLE: caregiver_service (allows multi-service caregivers)
CREATE TABLE caregiver_service (
    id INT AUTO_INCREMENT PRIMARY KEY,
    caregiver_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Assign multiple caregivers to multiple services
INSERT INTO caregiver_service (caregiver_id, service_id) VALUES
-- Personal Care (1,2,3)
(1,1),(1,2),(1,3),
(2,1),(2,3),
(3,1),(3,2),(3,3),

-- Home Support (4,5,6)
(4,4),(4,5),
(5,4),(5,6),
(1,6),

-- Social & Wellness (7,8,9)
(6,7),(6,8),
(3,7),
(2,9);

-- table: booking_details
CREATE TABLE booking_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    service_id INT,
    caregiver_id INT NULL,
    quantity INT DEFAULT 1,
    start_time DATETIME,
    end_time DATETIME,
    subtotal DECIMAL(10,2),
    special_request VARCHAR(255) NULL,
    caregiver_status TINYINT NOT NULL DEFAULT 0,   -- 0=not_assigned, 1=assigned, 2=checked_in, 3=checked_out, 4=cancelled
    check_in_at DATETIME NULL,
    check_out_at DATETIME NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert booking details
-- start_time and end_time seeded to match booking_date for current and future bookings

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status, check_in_at, check_out_at)
VALUES
(1, 1, 1, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=1),
 (SELECT booking_date FROM bookings WHERE booking_id=1) + INTERVAL 1 HOUR,
 35.00, 'Wheelchair assistance needed', 2,
 (SELECT booking_date FROM bookings WHERE booking_id=1), NULL),

(1, 2, 2, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=1),
 (SELECT booking_date FROM bookings WHERE booking_id=1) + INTERVAL 30 MINUTE,
 20.00, NULL, 1, NULL, NULL),

(2, 6, 5, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=2),
 (SELECT booking_date FROM bookings WHERE booking_id=2) + INTERVAL 1 HOUR,
 35.00, 'Low salt meal preferred', 1, NULL, NULL),

(3, 8, 6, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=3),
 (SELECT booking_date FROM bookings WHERE booking_id=3) + INTERVAL 2 HOUR,
 50.00, NULL, 1, NULL, NULL),

(2, 4, NULL, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=2),
 (SELECT booking_date FROM bookings WHERE booking_id=2) + INTERVAL 2 HOUR,
 50.00, 'Please bring cleaning supplies', 0, NULL, NULL),

(3, 7, NULL, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=3),
 (SELECT booking_date FROM bookings WHERE booking_id=3) + INTERVAL 1 HOUR,
 40.00, 'Client prefers Chinese speaking caregiver', 0, NULL, NULL),

(1, 3, NULL, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=1),
 (SELECT booking_date FROM bookings WHERE booking_id=1) + INTERVAL 45 MINUTE,
 30.00, 'Needs assistance to stand up safely', 0, NULL, NULL);
 
 
 -- ==========================================
-- EXTRA BOOKINGS to test week/month/year filters
-- ==========================================

-- 1) This week (2 days ago)  ✅ should appear in "week", "month", "year"
INSERT INTO bookings (customer_id, booking_date, status)
VALUES (1, NOW() - INTERVAL 2 DAY, 2);

SET @b_week := LAST_INSERT_ID();

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status, check_in_at, check_out_at)
VALUES
(@b_week, 1, 1, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=@b_week),
 (SELECT booking_date FROM bookings WHERE booking_id=@b_week) + INTERVAL 1 HOUR,
 35.00, 'Seed: this week', 2,
 (SELECT booking_date FROM bookings WHERE booking_id=@b_week), NULL);


-- 2) This month but NOT this week (20 days ago) ✅ should appear in "month", "year" (usually NOT week)
INSERT INTO bookings (customer_id, booking_date, status)
VALUES (1, NOW() - INTERVAL 20 DAY, 2);

SET @b_month := LAST_INSERT_ID();

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status, check_in_at, check_out_at)
VALUES
(@b_month, 6, 5, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=@b_month),
 (SELECT booking_date FROM bookings WHERE booking_id=@b_month) + INTERVAL 2 HOUR,
 35.00, 'Seed: this month', 1,
 NULL, NULL);


-- 3) This year but NOT this month (3 months ago) ✅ should appear in "year" only
INSERT INTO bookings (customer_id, booking_date, status)
VALUES (1, NOW() - INTERVAL 3 MONTH, 2);

SET @b_year := LAST_INSERT_ID();

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status, check_in_at, check_out_at)
VALUES
(@b_year, 8, 6, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=@b_year),
 (SELECT booking_date FROM bookings WHERE booking_id=@b_year) + INTERVAL 1 HOUR,
 50.00, 'Seed: this year', 1,
 NULL, NULL);


-- 4) Last year (14 months ago) ✅ should NOT appear in this year's filter
INSERT INTO bookings (customer_id, booking_date, status)
VALUES (1, NOW() - INTERVAL 14 MONTH, 2);

SET @b_lastyear := LAST_INSERT_ID();

INSERT INTO booking_details
(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status, check_in_at, check_out_at)
VALUES
(@b_lastyear, 7, NULL, 1,
 (SELECT booking_date FROM bookings WHERE booking_id=@b_lastyear),
 (SELECT booking_date FROM bookings WHERE booking_id=@b_lastyear) + INTERVAL 1 HOUR,
 40.00, 'Seed: last year', 0,
 NULL, NULL);

-- =========================
-- table: feedback (NEW)
-- matches screenshot columns
-- =========================

DROP TABLE IF EXISTS feedback;

CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,

    caregiver_rating INT NOT NULL CHECK (caregiver_rating BETWEEN 1 AND 5),
    service_rating   INT NOT NULL CHECK (service_rating BETWEEN 1 AND 5),

    caregiver_remarks VARCHAR(255) NULL,
    service_remarks   VARCHAR(255) NULL,

    INDEX idx_feedback_booking (booking_id),
    INDEX idx_feedback_service (service_id),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================
-- dummy data (like screenshot)
-- =========================
INSERT INTO feedback
(booking_id, service_id, caregiver_rating, service_rating, caregiver_remarks, service_remarks)
VALUES
(2, 6, 3, 5, 'subpar', 'good'),
(1, 1, 5, 5, 'Excellent care, very attentive', 'Service was smooth and professional'),
(1, 2, 4, 4, 'Friendly and helpful', 'Good overall experience'),
(2, 3, 3, 4, 'Average performance', 'Service was okay'),
(2, 4, 2, 3, 'Caregiver seemed rushed', 'Service could be improved'),
(3, 1, 5, 5, 'Outstanding caregiver', 'Top quality service'),
(3, 5, 4, 5, 'Very patient and kind', 'Excellent service delivery'),
(4, 2, 3, 3, 'Acceptable but nothing special', 'Average service'),
(4, 6, 1, 2, 'Very poor attitude', 'Disappointing service'),
(5, 3, 4, 4, 'Professional and calm', 'Good service'),
(5, 4, 2, 3, 'Needs improvement', 'Service was below expectations');


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

-- cart
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- cart items
CREATE TABLE cart_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    service_id INT NOT NULL,
    caregiver_id INT NULL,
    quantity INT DEFAULT 1,
    start_time DATETIME NULL,
    end_time DATETIME NULL,
    special_request VARCHAR(255) NULL,
    status TINYINT NOT NULL DEFAULT 1,         -- 1=pending, 2=confirmed, 3=removed
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id)
        ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES service(service_id)
        ON DELETE CASCADE,
    FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- insert cart data for test user
INSERT INTO cart (customer_id) VALUES (1);

INSERT INTO cart_items (cart_id, service_id, caregiver_id, quantity, start_time, end_time, special_request, status)
VALUES
(1, 4, 4, 1, NOW() + INTERVAL 2 DAY, NOW() + INTERVAL 2 DAY + INTERVAL 2 HOUR, 'Light housekeeping', 1),
(1, 1, 1, 1, NOW() + INTERVAL 5 DAY, NOW() + INTERVAL 5 DAY + INTERVAL 1 HOUR, 'Shower chair requested', 1);

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  booking_id INT NULL,
  detail_id INT NULL,
  title VARCHAR(120) NOT NULL,
  message VARCHAR(500) NOT NULL,
  is_read TINYINT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_customer_unread (customer_id, is_read, created_at),

  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;


-- table : service inquiries 
CREATE TABLE service_inquiries (
  inquiry_id INT AUTO_INCREMENT PRIMARY KEY,

  customer_id INT NULL,
  service_id INT NULL,
  caregiver_id INT NULL,

  -- required fields from your form
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  message TEXT NOT NULL,

  -- preferred contact ( the radio buttons)
  preferred_contact ENUM('EMAIL','PHONE') NOT NULL DEFAULT 'EMAIL',
  phone VARCHAR(20) NULL,

  -- admin management
  status ENUM('NEW','READ','ARCHIVED') NOT NULL DEFAULT 'NEW',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_inquiry_status_date (status, created_at),
  INDEX idx_inquiry_customer (customer_id),
  INDEX idx_inquiry_service (service_id),
  INDEX idx_inquiry_caregiver (caregiver_id),

  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,

  FOREIGN KEY (service_id) REFERENCES service(service_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,

  FOREIGN KEY (caregiver_id) REFERENCES caregiver(caregiver_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- drop existing procedures and function if any
DROP PROCEDURE IF EXISTS sp_total_users;
DROP PROCEDURE IF EXISTS sp_popular_service;
DROP FUNCTION IF EXISTS fn_revenue;

-- stored procedures and function for analytics dashboard
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
